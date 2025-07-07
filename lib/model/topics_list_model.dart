class Course {
  final String? code;
  final String name;
  final List<String> topics;

  Course({this.code, required this.name, required this.topics});

  factory Course.fromJson(String code, Map<String, dynamic> json) {
    return Course(
      code: code,
      name: json['name'],
      topics: List<String>.from(json['topics']),
    );
  }
}




































// class Course {
//   final String code;
//   final String name;
//   final List<String> topics;
//
//   Course({
//     required this.code,
//     required this.name,
//     required this.topics,
//   });
//
//   factory Course.fromJson(String code, Map<String, dynamic> json) {
//     return Course(
//       code: code,
//       name: json['name'],
//       topics: List<String>.from(json['topics']),
//     );
//   }
// }