import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syllabus_tracker/model/subject_list_model.dart';

class SubjectListViewModel with ChangeNotifier {
  final SubjectListModel _subjectListModel = SubjectListModel(
    subjectNames: [],
    subjectCodes: [],
    topics: [],
  );

  List<String> get subjectNames => _subjectListModel.subjectNames;
  List<String> get subjectCodes => _subjectListModel.subjectCodes;
  List<List<String>> get topics => _subjectListModel.topics;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _subjectsLoaded = false;
  bool get subjectsLoaded => _subjectsLoaded;

  Future<void> loadSubjectData() async {
    if (_isLoading) return;

    _subjectsLoaded = false;
    _isLoading = true;
    notifyListeners();

    try {
      final String jsonString = await rootBundle.loadString(
        'lib/db/subject_data.json',
      );

      final Map<String, dynamic> jsonData =
          json.decode(jsonString) as Map<String, dynamic>;

      _subjectListModel.subjectCodes.clear();
      _subjectListModel.subjectNames.clear();
      _subjectListModel.topics.clear();

      jsonData.forEach((code, details) {
        _subjectListModel.subjectCodes.add(code);
        _subjectListModel.subjectNames.add(details['name'] as String);
        _subjectListModel.topics.add(
          (details['topics'] as List).cast<String>(),
        );
      });

      _subjectsLoaded = true;
    } catch (error) {
      _subjectsLoaded = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
