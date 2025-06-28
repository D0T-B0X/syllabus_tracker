/// Data model representing the complete subject list structure.
/// Contains parallel lists for subject names, codes, and their associated topics.
class SubjectListModel {
  /// List of human-readable subject names
  final List<String> subjectNames;

  /// List of subject codes (e.g., "CS-101", "MATH-201")
  final List<String> subjectCodes;

  /// List of topic lists - each inner list contains topics for the corresponding subject
  final List<List<String>> topics;

  /// Creates a new subject list model with the provided data
  /// All three lists should have the same length and corresponding indices
  SubjectListModel({
    required this.subjectNames,
    required this.subjectCodes,
    required this.topics,
  });
}
