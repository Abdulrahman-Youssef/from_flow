class SimpleUserModel {
  final int id;
  final String name;
  final String email;

  SimpleUserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // ---- COPY WITH ----
  SimpleUserModel copyWith({
    int? id,
    String? name,
    String? email,
  }) {
    return SimpleUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  // ---- FROM JSON ----
  factory SimpleUserModel.fromJson(Map<String, dynamic> json) {
    return SimpleUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // ---- TO JSON ----
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // ---- STRING ----
  @override
  String toString() => 'SimpleUserModel(id: $id, name: $name, email: $email)';

  // ---- EQUALITY ----
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SimpleUserModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              email == other.email;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode;
}
