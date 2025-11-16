class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profilePic;        // Can be null
  final String? emailVerifiedAt;   // Optional, nullable
  final String profilePicUrl;
  final String role;
  final DateTime? createdAt;       // Parsed from string
  final DateTime? updatedAt;       // Parsed from string

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePic,
    this.emailVerifiedAt,
    required this.profilePicUrl,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  /// Parse from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePic: json['profile_pic'],
      emailVerifiedAt: json['email_verified_at'],
      profilePicUrl: json['profile_pic_url'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_pic': profilePic,
      'email_verified_at': emailVerifiedAt,
      'profile_pic_url': profilePicUrl,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
