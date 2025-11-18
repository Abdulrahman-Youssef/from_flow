import 'package:form_flow/models/API/trip_api_model.dart';
import 'package:form_flow/models/mappers/supplier_mapper.dart';
import 'package:form_flow/models/trip_data.dart';

extension TripMapper on TripData {
  TripApiModel toApiModel() {
    return TripApiModel(
      vehicleId: vehicle.id,
      procurementSpecialistId: procurementSpecialist.id,
      fleetSupervisorId: fleetSupervisor.id,
      note: note,
      storages: storages.map((s) => s.id!).toList(),
      suppliers: suppliers.map((s) => s.toApiModel()).toList(),
    );
  }
}
