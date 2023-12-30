/// User profile datastructure.
class User {
  /// Constructor.
  User({
    required this.userId,
    required this.email,
    required this.emailVerified,
    required this.picture,
    required this.name,
    required this.nickname,
    this.isAdmin,
  });

  /// Used to convert from json to UserProfile.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      emailVerified: json['email_verified'],
      picture: json['picture'],
      name: json['name'],
      nickname: json['nickname'],
    );
  }

  /// UserID from the user
  final String userId;

  /// Email from the user
  final String email;

  /// Email verified from the user
  final bool emailVerified;

  /// Picture from the user
  final String picture;

  /// Name from the user
  final String name;

  /// Nickname from the user
  final String nickname;

  /// Role from the user
  bool? isAdmin;
}
