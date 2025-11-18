import 'package:form_flow/models/API/trip_api_model.dart';

class DeliveryApiModel {
  final int? id;
  final String name;
  final String date;
  final List<TripApiModel> trips;

  DeliveryApiModel({
    this.id,
    required this.name,
    required this.date,
    required this.trips,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "date": date,
    "trips": trips.map((e) => e.toJson()).toList(),
  };
}
