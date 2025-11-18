class SupplierModel {
  final int? id;
  String? supplierName;
  DateTime? actualArriveDate;
  DateTime? actualDepartureDate;
  DateTime? planArriveDate;

  SupplierModel({
    this.id,
    this.supplierName,
    this.actualArriveDate,
    this.actualDepartureDate,
    this.planArriveDate,
  });

  SupplierModel copyWith({
    int? id,
    String? supplierName,
    DateTime? actualArriveDate,
    DateTime? actualDepartureDate,
    DateTime? planArriveDate,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      supplierName: supplierName ?? this.supplierName,
      actualArriveDate: actualArriveDate ?? this.actualArriveDate,
      actualDepartureDate: actualDepartureDate ?? this.actualDepartureDate,
      planArriveDate : planArriveDate ?? this.planArriveDate,
    );
  }

 @override
  String toString() => '$supplierName';



  String get waitingTime {
    // null error
    if(actualArriveDate != null && actualDepartureDate != null )
      {
        final difference = actualDepartureDate!.difference(actualArriveDate!);
        final hours = difference.inHours;
        final minutes = difference.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      }
    else{
      return "not set yet";
    }

  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierName': supplierName,
      'actualArriveDate': actualArriveDate?.toIso8601String(),
      'actualDepartureDate': actualDepartureDate?.toIso8601String(),
      'planArriveDate': planArriveDate?.toIso8601String(),
    };
  }

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as int?,
      supplierName: json['name'] as String?,
      actualArriveDate: json['actual_arrive_date'] != null
          ? DateTime.parse(json['actual_arrive_date'] as String)
          : null,
      actualDepartureDate: json['actual_departure_date'] != null
          ? DateTime.parse(json['actual_departure_date'] as String)
          : null,
      planArriveDate: json['plan_arrive_date'] != null
          ? DateTime.parse(json['plan_arrive_date'] as String)
          : null,
    );
  }


}
