class SupplierData {
  final int? id;
  String? supplierName;
  DateTime? actualArriveDate;
  DateTime? actualDepartureDate;
  DateTime? planArriveDate;

  SupplierData({
    this.id,
    this.supplierName,
    this.actualArriveDate,
    this.actualDepartureDate,
    this.planArriveDate,
  });

  SupplierData copyWith({
    int? id,
    String? supplierName,
    DateTime? actualArriveDate,
    DateTime? actualDepartureDate,
    DateTime? planArriveDate,
  }) {
    return SupplierData(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      actualArriveDate: actualArriveDate ?? this.actualArriveDate,
      actualDepartureDate: actualDepartureDate ?? this.actualDepartureDate,
      planArriveDate : planArriveDate ?? this.planArriveDate,
    );
  }

  String get waitingTime {
    final difference = actualDepartureDate!.difference(actualArriveDate!);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
