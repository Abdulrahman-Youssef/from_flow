class SupplierData {
  final int id;
  final String supplierName;
  final String storageName;
  final String carId;
  final String procurementSpecialist;
  final String supervisorName;
  final DateTime actualArriveDate;
  final DateTime actualLeaveDate;

  SupplierData({
    required this.id,
    required this.supplierName,
    required this.storageName,
    required this.carId,
    required this.procurementSpecialist,
    required this.supervisorName,
    required this.actualArriveDate,
    required this.actualLeaveDate,
  });

  SupplierData copyWith({
    int? id,
    String? supplierName,
    String? storageName,
    String? carId,
    String? procurementSpecialist,
    String? supervisorName,
    DateTime? actualArriveDate,
    DateTime? actualLeaveDate,
  }) {
    return SupplierData(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      storageName: storageName ?? this.storageName,
      carId: carId ?? this.carId,
      procurementSpecialist: procurementSpecialist ?? this.procurementSpecialist,
      supervisorName: supervisorName ?? this.supervisorName,
      actualArriveDate: actualArriveDate ?? this.actualArriveDate,
      actualLeaveDate: actualLeaveDate ?? this.actualLeaveDate,
    );
  }

  int get waitingDays {
    return actualLeaveDate.difference(actualArriveDate).inDays;
  }
}