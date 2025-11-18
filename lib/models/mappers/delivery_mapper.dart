import 'package:form_flow/models/API/delivery_api_model.dart';
import 'package:form_flow/models/delivery_model.dart';
import 'package:form_flow/models/mappers/trip_mapper.dart';

extension DeliveryMapper on DeliveryData {
  DeliveryApiModel toApiModel() {
    return DeliveryApiModel(
      name: name,
      date: date.toIso8601String().split("T").first,
      trips: trips.map((t) => t.toApiModel()).toList(),
    );
  }
}
