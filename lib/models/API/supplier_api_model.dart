class SupplierApiModel {
  final int supplierId;
  final String planArriveDate; // as "YYYY-MM-DD HH:mm"
  final String? actualArriveDate; // as "YYYY-MM-DD HH:mm"
  final String? actualDepartureDate; // as "YYYY-MM-DD HH:mm"

  SupplierApiModel({
    required this.supplierId,
    required this.planArriveDate,
    this.actualArriveDate,
    this.actualDepartureDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "supplier_id": supplierId,
      "plan_arrive_date": planArriveDate,
      "actual_arrive_date": actualArriveDate,
      "actual_departure_date": actualDepartureDate,
    };
  }
}
