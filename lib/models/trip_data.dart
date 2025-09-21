import 'package:form_flow/models/storage_data.dart';
import 'package:form_flow/models/supplier_data.dart';

class TripData {
  final int? id;

  final String vehicleCode;
  final String procurementSpecialist;
  final String fleetSupervisor;
  final List<SupplierData> suppliers;
  final List<StorageData> storages;
  // final String storageName;
  bool isExpanded;

  TripData({
     this.id,
    required this.vehicleCode,
    required this.storages,
    required this.procurementSpecialist,
    required this.fleetSupervisor,
    required this.suppliers,
    this.isExpanded = false,
  });

  TripData copyWith(
      {int? id, String? vehicleCode,List<StorageData>? storageName, String? procurementSpecialist, String? fleetSupervisor, List<
          SupplierData>? suppliers }) {
    return TripData(id: id ?? this.id,
        vehicleCode: vehicleCode ?? this.vehicleCode,
        storages: storageName ?? this.storages,
        procurementSpecialist: procurementSpecialist ?? this.procurementSpecialist,
        fleetSupervisor: fleetSupervisor ?? this.fleetSupervisor,
        suppliers: suppliers ?? this.suppliers);
  }


  DateTime? get earliestArrival => suppliers
      .map((s) => s.actualArriveDate)
      .reduce((a, b) => a!.isBefore(b!) ? a : b);

  DateTime? get latestDeparture => suppliers
      .map((s) => s.actualDepartureDate)
      .reduce((a, b) => a!.isAfter(b!) ? a : b);

  String get totalWaitingTime {
    final difference = latestDeparture!.difference(earliestArrival!);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String get suppliersList {
    if (suppliers.length == 1) {
      return suppliers.first.supplierName!;
    } else {
      return '${suppliers.first.supplierName} (+${suppliers.length - 1} more)';
    }
  }


}