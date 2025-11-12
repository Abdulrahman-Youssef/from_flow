import 'package:flutter/foundation.dart'; // for @immutable

@immutable
class ProcurementSpecialistsModel {
  final int id;
  final String name;

  // 1. Default constructor
  const ProcurementSpecialistsModel({
    required this.id,
    required this.name,
  });

  // 2. copyWith method (for immutability)
  ProcurementSpecialistsModel copyWith({
    int? id,
    String? name,
  }) {
    return ProcurementSpecialistsModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  // 3. fromJson (Named constructor with initializer list)
  ProcurementSpecialistsModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String;

  // 4. toJson (for sending data to an API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  // 5. Value equality (for comparing two instances)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProcurementSpecialistsModel &&
        other.id == id &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  // 6. toString (for easy debugging)
  @override
  String toString() => name;
}