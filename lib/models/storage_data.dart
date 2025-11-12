class StorageModel {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StorageModel({
     this.id,
     this.name,
    this.createdAt,
    this.updatedAt,
  });

  // Copy with method for immutability
  StorageModel copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StorageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StorageModel &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // JSON deserialization
  factory StorageModel.fromJson(Map<String, dynamic> json) {
    return StorageModel(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  @override
  String toString() => '$name';

  // Validation method
  bool isValid() => id! > 0 && name!.isNotEmpty;
}