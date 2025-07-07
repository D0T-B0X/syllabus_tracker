import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syllabus_tracker/model/topics_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TopicsViewModel extends ChangeNotifier {
  final List<Course> _courses = [];
  final Map<String, Map<String, bool>> _topicsList = {};
  String? _selectedCode;

  // getters
  List<Course> get courses => _courses;
  Map<String, bool> getList(String code) => _topicsList[code] ?? {};
  Course? getCourse(String code) {
    final match = _courses.where((c) => c.code == code);
    return match.isNotEmpty ? match.first : null;
  }

  String? get selectedCode => _selectedCode;
  Map<String, bool> get currentSelections {
    if (_selectedCode == null) return {};
    return _topicsList[_selectedCode!] ?? {};
  }

  // functions

  // function - 1
  Future<void> loadCourse() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = await rootBundle.loadString(
      'assets/data/subject_data.json',
    );
    final Map<String, dynamic> data = jsonDecode(jsonString);

    _courses.clear();
    _topicsList.clear();

    data.forEach((code, value) {
      final course = Course.fromJson(code, value);
      _courses.add(course);

      final saved = prefs.getString('topics_$code');
      if (saved != null) {
        final decodedSelections = jsonDecode(saved);
        _topicsList[code] = Map<String, bool>.from(decodedSelections);
      } else {
        _topicsList[code] = {for (var topic in course.topics) topic: false};
      }
    });
    notifyListeners();
  }

  // function - 2
  void toggleTopic(
    String code,
    String topic,
    bool selected,
    String userID,
  ) async {
    _topicsList[code]![topic] = selected;
    notifyListeners();

    // Saving data locally
    await _saveSelectedTopics();

    // supabase updation
    await UpdateTotalCount(userID);
  }

  //function - 3
  double progress(String code) {
    final topics = _topicsList[code];
    if (topics == null || topics.isEmpty) return 0;
    final completed = topics.values.where((v) => v).length;
    return completed / (topics.length);
  }

  // function - 4
  void setSelectedCode(String code) {
    _selectedCode = code;
    notifyListeners();
  }

  // function - 5
  int get totalTopicsCompleted {
    int total = 0;
    _topicsList.forEach((code, topics) {
      total = total + topics.values.where((v) => v).length;
    });
    return total;
  }

  // function - 6
  Future<void> UpdateTotalCount(String userID) async {
    int total = totalTopicsCompleted;
    await Supabase.instance.client
        .from('user_data')
        .update({'topics_completed': total})
        .eq('user_id', userID);
  }

  // function  -7
  Future<void> _saveSelectedTopics() async {
    final prefs = await SharedPreferences.getInstance();

    for (final code in _topicsList.keys) {
      final selections = _topicsList[code];
      final encoded = jsonEncode(selections);
      await prefs.setString('topics_$code', encoded);
    }
  }
}
