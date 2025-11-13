import 'package:form_flow/models/storage_data.dart';
import 'package:form_flow/models/supplier_data.dart';

class TripData {
  final int? id;
  final String vehicleCode;
  final String procurementSpecialist;
  final String fleetSupervisor;
  final List<SupplierModel> suppliers ;
  final List<StorageModel> storages;
  final String? note;

  bool isExpanded;

  TripData({
    this.id,
    required this.vehicleCode,
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
    String? vehicleCode,
    String? procurementSpecialist,
    String? fleetSupervisor,
    List<SupplierModel>? suppliers,
    List<StorageModel>? storages, // <-- Renamed from 'storageName'
    String? note,
  }) {
    return TripData(
      id: id ?? this.id,
      vehicleCode: vehicleCode ?? this.vehicleCode,
      storages: storages ?? this.storages, // <-- Fixed logic
      procurementSpecialist:
      procurementSpecialist ?? this.procurementSpecialist,
      fleetSupervisor: fleetSupervisor ?? this.fleetSupervisor,
      suppliers: suppliers ?? this.suppliers,
      note: note ?? this.note, // <-- Added note
    );
  }

  // --- Getters (no changes) ---
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


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleCode': vehicleCode,
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
      vehicleCode: json['vehicleCode'] as String,
      procurementSpecialist: json['procurementSpecialist'] as String,
      fleetSupervisor: json['fleetSupervisor'] as String,
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