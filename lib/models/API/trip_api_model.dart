import 'package:form_flow/models/API/supplier_api_model.dart';

class TripApiModel {
  final int vehicleId;
  final int procurementSpecialistId;
  final int fleetSupervisorId;
  final String? note;
  final List<int> storages;
  final List<SupplierApiModel> suppliers;

  TripApiModel({
    required this.vehicleId,
    required this.procurementSpecialistId,
    required this.fleetSupervisorId,
    required this.storages,
    required this.suppliers,
    this.note,
  });

  Map<String, dynamic> toJson() => {
    "vehicle_id": vehicleId,
    "procurement_specialist_id": procurementSpecialistId,
    "fleet_supervisor_id": fleetSupervisorId,
    "note": note,
    "storages": storages,
    "suppliers": suppliers.map((e) => e.toJson()).toList(),
  };
}
