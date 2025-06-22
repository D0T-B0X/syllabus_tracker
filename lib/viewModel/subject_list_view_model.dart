import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syllabus_tracker/model/subject_list_model.dart';

/// ViewModel for managing the subject list and related data.
class SubjectListViewModel with ChangeNotifier {
  /// Internal model holding lists of subject names, codes, and topics.
  final SubjectListModel _subjectListModel = SubjectListModel(
    subjectNames: [],
    subjectCodes: [],
    topics: [],
  );

  /// Map of subject names to subject codes for quick lookup.
  final Map<String, String> _subjectNameCodeMap = {};

  /// List of subject names.
  List<String> get subjectNames => _subjectListModel.subjectNames;

  /// List of subject codes.
  List<String> get subjectCodes => _subjectListModel.subjectCodes;

  /// List of topics for each subject.
  List<List<String>> get topics => _subjectListModel.topics;

  /// Public getter for the subject name to code map.
  Map<String, String> get subjectNameCodeMap => _subjectNameCodeMap;

  /// Indicates if data is currently being loaded.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Indicates if subjects have been loaded successfully.
  bool _subjectsLoaded = false;
  bool get subjectsLoaded => _subjectsLoaded;

  /// Loads subject data from a local JSON file and populates the model.
  Future<void> loadSubjectData() async {
    // Prevent duplicate loading if already in progress.
    if (_isLoading) return;

    _subjectsLoaded = false;
    _isLoading = true;
    notifyListeners();

    try {
      // Load the JSON string from assets.
      final String jsonString = await rootBundle.loadString(
        'assets/data/subject_data.json',
      );

      // Decode the JSON string into a map.
      final Map<String, dynamic> jsonData =
          json.decode(jsonString) as Map<String, dynamic>;

      // Clear existing data before loading new data.
      _subjectListModel.subjectCodes.clear();
      _subjectListModel.subjectNames.clear();
      _subjectListModel.topics.clear();

      // Populate the model and map with new data.
      jsonData.forEach((code, details) {
        _subjectListModel.subjectCodes.add(code);
        _subjectListModel.subjectNames.add(details['name'] as String);

        // Add subject name and code to the map.
        _subjectNameCodeMap[details['name'] as String] = code;

        // Add topics for the subject.
        _subjectListModel.topics.add(
          (details['topics'] as List).cast<String>(),
        );
      });

      _subjectsLoaded = true;
    } catch (error) {
      // Handle errors by marking subjects as not loaded.
      _subjectsLoaded = false;
    } finally {
      // Reset loading state and notify listeners.
      _isLoading = false;
      notifyListeners();
    }
  }
}
