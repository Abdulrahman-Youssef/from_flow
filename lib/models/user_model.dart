class UserModel {
  final int id;
  final String name;
  final String email;
  final String? profilePic; // Can be null
  final String profilePicUrl;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePic,
    required this.profilePicUrl,
    required this.role,
  });

  // This factory constructor is the "parser"
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePic: json['profile_pic'], // This will be null from your example
      profilePicUrl: json['profile_pic_url'],
      role: json['role'],
    );
  }
}