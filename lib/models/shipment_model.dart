import 'package:form_flow/models/trip_data.dart';

class SupplyDeliveryData {
  final int id;
  final String name;
  final DateTime date;
  final List<TripData> trips;

  // --- NEW FIELDS ---
  final String createdBy;
  final String? editedBy;
  final DateTime? lastEditedAt;
  // ------------------

  SupplyDeliveryData({
    required this.id,
    required this.name,
    required this.date,
    required this.trips,
    // Add new fields to the constructor
    required this.createdBy,
    this.editedBy,
    this.lastEditedAt,
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
    DateTime? lastEditedAt,
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
      lastEditedAt: lastEditedAt ?? this.lastEditedAt,
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
}