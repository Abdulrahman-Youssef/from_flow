import 'package:form_flow/core/utils/parse_list.dart';
import 'package:form_flow/models/fleet_supervisors_model.dart';
import 'package:form_flow/models/procurement_specialists_model.dart';
import 'package:form_flow/models/storage_data.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/vehicle_model.dart';

class DropdownDataResponse {
  final List<VehicleModel> vehicles;
  final List<StorageModel> storages;
  final List<SupplierModel> suppliers;
  final List<FleetSupervisorsModel> fleetSupervisors;
  final List<ProcurementSpecialistsModel> procurementSpecialists;

  DropdownDataResponse({
    required this.vehicles,
    required this.storages,
    required this.suppliers,
    required this.fleetSupervisors,
    required this.procurementSpecialists,
  });

  factory DropdownDataResponse.fromJson(Map<String, dynamic> json) {
    return DropdownDataResponse(
        vehicles: parseList("vehicles", json, VehicleModel.fromJson),
        storages: parseList("storages", json, StorageModel.fromJson),
        suppliers: parseList("suppliers", json, SupplierModel.fromJson),
        fleetSupervisors:
            parseList("fleetSupervisors", json, FleetSupervisorsModel.fromJson),
        procurementSpecialists: parseList("procurementSpecialists", json,
            ProcurementSpecialistsModel.fromJson));
  }
}
