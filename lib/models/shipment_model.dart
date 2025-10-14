import 'package:form_flow/models/trip_data.dart';

class SupplyDeliveryData {
  final String id;
  final String name;
  final DateTime date;
  final List<TripData> trips;

  SupplyDeliveryData({
    required this.id,
    required this.name,
    required this.date,
    required this.trips,
  });

  // ✨ ADD THIS METHOD ✨
  // It creates a copy of the current object, allowing you to override specific fields.
  SupplyDeliveryData copyWith({
    String? id,
    String? name,
    DateTime? date,
    List<TripData>? trips,
  }) {
    return SupplyDeliveryData(
      // Use the new value if provided, otherwise use the old one (`this.name`).
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      trips: trips ?? this.trips,
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