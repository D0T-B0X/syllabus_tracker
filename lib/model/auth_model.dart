//╔══════════════════════════════════════════════════════════════════════════╗
//║ AUTH MODEL                                                               ║
//║                                                                          ║
//║ Simple data container for authentication fields with validation state.   ║
//╚══════════════════════════════════════════════════════════════════════════╝
class AuthModel {
  //┌─────────────────────────────────────────────┐
  //│ PROPERTIES                                  │
  //└─────────────────────────────────────────────┘

  /// Input value (email/password)
  String? value;

  /// Validation error message
  String? error;

  /// Creates a new auth model instance
  AuthModel({this.value, this.error});
}
