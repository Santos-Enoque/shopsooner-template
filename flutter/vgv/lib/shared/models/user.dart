/// User model
class User {
  /// Creates a new user instance
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  /// User ID
  final String id;

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// URL to user's avatar image
  final String? avatarUrl;

  /// Create a user from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  /// Convert user to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }

  /// Create a copy of this user with modified fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
