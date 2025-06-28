/// Data model representing user profile information.
/// Currently contains only the username but can be extended for additional profile data.
class UserProfileModel {
  /// The user's display name/username
  String username;

  /// Creates a new user profile model with the specified username
  UserProfileModel({required this.username});
}
