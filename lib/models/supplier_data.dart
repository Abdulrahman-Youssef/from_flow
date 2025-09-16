class SupplierData {
  final int? id;
   String? supplierName;
  // final String storageName;
  // final String vehicleCode;
  // final String procurementSpecialist;
  // final String fleetSupervisor;
   DateTime? actualArriveDate;
   DateTime? actualDepartureDate;

  SupplierData({
     this.id,
     this.supplierName,
    // required this.storageName,
    // required this.vehicleCode,
    // required this.procurementSpecialist,
    // required this.fleetSupervisor,
     this.actualArriveDate,
     this.actualDepartureDate,
  });

  SupplierData copyWith({
    int? id,
    String? supplierName,
    String? storageName,
    String? carId,
    String? procurementSpecialist,
    String? supervisorName,
    DateTime? actualArriveDate,
    DateTime? actualDepartureDate,
  }) {
    return SupplierData(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      // storageName: storageName ?? this.storageName,
      // vehicleCode: carId ?? this.vehicleCode,
      // procurementSpecialist:
      //     procurementSpecialist ?? this.procurementSpecialist,
      // fleetSupervisor: supervisorName ?? this.fleetSupervisor,
      actualArriveDate: actualArriveDate ?? this.actualArriveDate,
      actualDepartureDate: actualDepartureDate ?? this.actualDepartureDate,
    );
  }

  String get waitingTime {
    final difference = actualDepartureDate!.difference(actualArriveDate!);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
