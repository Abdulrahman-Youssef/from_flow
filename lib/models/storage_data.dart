class StorageData {
  final int? id;
  final String? name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StorageData({
     this.id,
     this.name,
    this.createdAt,
    this.updatedAt,
  });

  // Copy with method for immutability
  StorageData copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StorageData(
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

    return other is StorageData &&
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
  factory StorageData.fromJson(Map<String, dynamic> json) {
    return StorageData(
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
  String toString() => 'StorageData(id: $id, name: $name)';

  // Validation method
  bool isValid() => id! > 0 && name!.isNotEmpty;
}