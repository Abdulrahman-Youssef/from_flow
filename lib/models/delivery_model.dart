import 'package:form_flow/models/simple_user.dart';
import 'package:form_flow/models/trip_data.dart';

class DeliveryData {
  final int? id;
  final String name;
  final DateTime date;
  final List<TripData> trips;

  final SimpleUserModel createdBy;
  final SimpleUserModel? editedBy;
  final DateTime createdAt;
  final DateTime? updatedAt;

  DeliveryData({
    this.id,
    required this.name,
    required this.date,
    required this.trips,
    required this.createdBy,
    required this.createdAt,
    this.editedBy,
    this.updatedAt,
  });

  DeliveryData copyWith({
    int? id,
    String? name,
    DateTime? date,
    List<TripData>? trips,
    SimpleUserModel? createdBy,
    SimpleUserModel? editedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeliveryData(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      trips: trips ?? this.trips,
      createdBy: createdBy ?? this.createdBy,
      editedBy: editedBy ?? this.editedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get tripsCount => trips.length;

  int get suppliersCount =>
      trips.expand((trip) => trip.suppliers).length;

  int get vehiclesCount =>
      trips.map((trip) => trip.vehicle).toSet().length;

  int get storagesCount =>
      trips.expand((trip) => trip.storages).map((s) => s.name).toSet().length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'created_by': createdBy.toJson(),
      'edited_by': editedBy?.toJson(),
      'created_date': createdAt.toIso8601String(),
      'updated_date': updatedAt?.toIso8601String(),
      'trips': trips.map((t) => t.toJson()).toList(),
    };
  }

  factory DeliveryData.fromJson(Map<String, dynamic> json) {
    return DeliveryData(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      createdBy: SimpleUserModel.fromJson(json['created_by']),
      editedBy: json['edited_by'] != null
          ? SimpleUserModel.fromJson(json['edited_by'])
          : null,
      createdAt: DateTime.parse(json['created_date']),
      updatedAt: json['updated_date'] != null
          ? DateTime.parse(json['updated_date'])
          : null,
      trips: (json['trips'] as List)
          .map((t) => TripData.fromJson(t))
          .toList(),
    );
  }
}
