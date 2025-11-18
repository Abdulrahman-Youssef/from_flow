import 'package:form_flow/models/fleet_supervisors_model.dart';
import 'package:form_flow/models/procurement_specialists_model.dart';
import 'package:form_flow/models/storage_data.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/vehicle_model.dart';

class TripData {
  final int? id;
  final VehicleModel vehicle;
  final ProcurementSpecialistsModel procurementSpecialist;
  final FleetSupervisorsModel fleetSupervisor;
  final List<SupplierModel> suppliers;

  final List<StorageModel> storages;
  final String? note;

  bool isExpanded;

  TripData({
    this.id,
    required this.vehicle,
    required this.storages,
    required this.procurementSpecialist,
    required this.fleetSupervisor,
    required this.suppliers,
    this.note,
    this.isExpanded = false,
  });

  // --- UPDATED copyWith (Fixed typo and added 'note') ---
  TripData copyWith({
    int? id,
    VehicleModel? vehicle,
    ProcurementSpecialistsModel? procurementSpecialist,
    FleetSupervisorsModel? fleetSupervisor,
    List<SupplierModel>? suppliers,
    List<StorageModel>? storages, // <-- Renamed from 'storageName'
    String? note,
  }) {
    return TripData(
      id: id ?? this.id,
      vehicle: vehicle ?? this.vehicle,
      storages: storages ?? this.storages,
      // <-- Fixed logic
      procurementSpecialist:
          procurementSpecialist ?? this.procurementSpecialist,
      fleetSupervisor: fleetSupervisor ?? this.fleetSupervisor,
      suppliers: suppliers ?? this.suppliers,
      note: note ?? this.note, // <-- Added note
    );
  }

  DateTime? get earliestArrival {
    // Filter out null actualArriveDate
    final dates = suppliers.map((s) => s.actualArriveDate).whereType<DateTime>().toList();
    if (dates.isEmpty) return null;
    return dates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  DateTime? get latestDeparture {
    // Filter out null actualDepartureDate
    final dates = suppliers.map((s) => s.actualDepartureDate).whereType<DateTime>().toList();
    if (dates.isEmpty) return null;
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  String get totalWaitingTime {
    final start = earliestArrival;
    final end = latestDeparture;

    if (start != null && end != null) {
      final difference = end.difference(start);
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      return "not assigned yet";
    }
  }



  String get suppliersList {
    if (suppliers.length == 1) {
      return suppliers.first.supplierName!;
    } else {
      return '${suppliers.first.supplierName} (+${suppliers.length - 1} more)';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleCode': vehicle,
      'procurementSpecialist': procurementSpecialist,
      'fleetSupervisor': fleetSupervisor,
      'note': note,
      'suppliers': suppliers.map((s) => s.toJson()).toList(),
      'storages': storages.map((s) => s.toJson()).toList(),
    };
  }

  factory TripData.fromJson(Map<String, dynamic> json) {
    return TripData(
      id: json['id'] as int?,
      vehicle: VehicleModel.fromJson(json['vehicle']),
      procurementSpecialist:
          ProcurementSpecialistsModel.fromJson(json['procurement_specialist']),
      fleetSupervisor: FleetSupervisorsModel.fromJson(json['fleet_supervisor']),
      note: json['note'] as String?,
      suppliers: (json['suppliers'] as List<dynamic>)
          .map((s) => SupplierModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      storages: (json['storages'] as List<dynamic>)
          .map((s) => StorageModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      // 'isExpanded' is local state, so it's not included in JSON
    );
  }
}
