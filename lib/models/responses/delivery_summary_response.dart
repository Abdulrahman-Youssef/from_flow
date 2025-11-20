class DeliverySummary {
  final int deliveryId;
  final String deliveryName;
  final DateTime deliveryDate;

  final int createdByUserId;
  final String createdBy;

  final int? editedByUserId;
  final String? editedBy;

  final int tripsCount;
  final int suppliersCount;
  final int storagesCount;
  final int vehiclesCount;

  DeliverySummary({
    required this.deliveryId,
    required this.deliveryName,
    required this.deliveryDate,
    required this.createdByUserId,
    required this.createdBy,
    this.editedByUserId,
    this.editedBy,
    required this.tripsCount,
    required this.suppliersCount,
    required this.storagesCount,
    required this.vehiclesCount,
  });

  factory DeliverySummary.fromJson(Map<String, dynamic> json) {
    return DeliverySummary(
      deliveryId: json['delivery_id'],
      deliveryName: json['delivery_name'],
      deliveryDate: DateTime.parse(json['delivery_date']),
      createdByUserId: json['createdBy_user_id'],
      createdBy: json['createdBy'],
      editedByUserId: json['editedBy_user_id'],
      editedBy: json['editedBy'],
      tripsCount: json['trips_count'],
      suppliersCount: json['suppliers_count'],
      storagesCount: json['storages_count'],
      vehiclesCount: json['vehicle_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'delivery_id': deliveryId,
      'delivery_name': deliveryName,
      'delivery_date':  deliveryDate.toIso8601String(),
      'createdBy_user_id': createdByUserId,
      'createdBy': createdBy,
      'editedBy_user_id': editedByUserId,
      'editedBy': editedBy,
      'trips_count': tripsCount,
      'suppliers_count': suppliersCount,
      'storages_count': storagesCount,
      'vehicle_count': vehiclesCount,
    };
  }
}