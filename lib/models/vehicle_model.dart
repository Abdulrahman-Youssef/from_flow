
import 'package:flutter/cupertino.dart';

@immutable
class VehicleModel {
  final int id;
  final String vehicleCode; // camelCase in Dart

  // 1. Default constructor
  const VehicleModel({
    required this.id,
    required this.vehicleCode,
  });

  // 2. copyWith method
  VehicleModel copyWith({
    int? id,
    String? vehicleCode,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      vehicleCode: vehicleCode ?? this.vehicleCode,
    );
  }

  // 3. fromJson (maps 'vehicle_code' to 'vehicleCode')
  VehicleModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        vehicleCode = json['vehicle_code'] as String; // JSON key

  // 4. toJson (maps 'vehicleCode' back to 'vehicle_code')
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_code': vehicleCode, // API/JSON key
    };
  }

  // 5. Value equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleModel &&
        other.id == id &&
        other.vehicleCode == vehicleCode;
  }

  @override
  int get hashCode => id.hashCode ^ vehicleCode.hashCode;

  // 6. toString (for debugging)
  @override
  String toString() => 'VehicleModel(id: $id, vehicleCode: $vehicleCode)';
}