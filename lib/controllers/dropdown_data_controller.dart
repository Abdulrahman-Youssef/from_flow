import 'package:form_flow/models/fleet_supervisors_model.dart';
import 'package:form_flow/models/procurement_specialists_model.dart';
import 'package:form_flow/models/responses/dropdown_data_response.dart';
import 'package:form_flow/models/storage_data.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/vehicle_model.dart';
import 'package:form_flow/repositories/delivery_repository.dart';
import 'package:get/get.dart';

class DropDownDataController extends GetxController {
  late final List<SupplierModel> suppliers;

  late final List<StorageModel> storages;

  late final List<VehicleModel> vehicles;

  late final List<FleetSupervisorsModel> fleetSupervisors;

  late final List<ProcurementSpecialistsModel> procurementSpecialists;
  //
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    DeliveryRepository deliveryRepository = DeliveryRepository();

    try {
      final data = await deliveryRepository.getDropDownData();

      DropdownDataResponse response = DropdownDataResponse.fromJson(data);

      suppliers = response.suppliers;
      storages = response.storages;
      vehicles = response.vehicles;
      fleetSupervisors=response.fleetSupervisors;
      procurementSpecialists=response.procurementSpecialists;

    } catch (e) {
      throw "parsing data error :$e";
    }
  }
}
