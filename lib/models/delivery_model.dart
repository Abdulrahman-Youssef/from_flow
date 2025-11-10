import 'package:form_flow/models/trip_data.dart';

class SupplyDeliveryData {
  final int id;
  final String name;
  final DateTime date;
  final List<TripData> trips;

  // --- NEW FIELDS ---
  final String createdBy;
  final String? editedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // ------------------

  SupplyDeliveryData({
    required this.id,
    required this.name,
    required this.date,
    required this.trips,
    // Add new fields to the constructor
    required this.createdBy,
    this.editedBy,
    this.createdAt,
    this.updatedAt,
  });

  // ✨ ADD THIS METHOD ✨
  // It creates a copy of the current object, allowing you to override specific fields.
  SupplyDeliveryData copyWith({
    int? id,
    String? name,
    DateTime? date,
    List<TripData>? trips,
    // Add new fields to copyWith
    String? createdBy,
    String? editedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupplyDeliveryData(
      // Use the new value if provided, otherwise use the old one (`this.name`).
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      trips: trips ?? this.trips,
      // Pass along the new or old values
      createdBy: createdBy ?? this.createdBy,
      editedBy: editedBy ?? this.editedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get tripsCount => trips.length;

  int get suppliersCount => trips
      .expand((trip) => trip.suppliers)
      .length;

  int get vehiclesCount => trips
      .map((trip) => trip.vehicleCode)
      .toSet()
      .length;

  int get storagesCount => trips
      .expand((trip) => trip.storages)
      .map((storage) => storage.name)
      .toSet()
      .length;


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'createdBy': createdBy,
      'editedBy': editedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'trips': trips.map((t) => t.toJson()).toList(),
    };
  }

  factory SupplyDeliveryData.fromJson(Map<String, dynamic> json) {
    return SupplyDeliveryData(
      id: json['id'] as int,
      name: json['name'] as String,
      date: DateTime.parse(json['date'] as String),
      createdBy: json['createdBy'] as String,
      editedBy: json['editedBy'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      trips: (json['trips'] as List<dynamic>)
          .map((t) => TripData.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

}