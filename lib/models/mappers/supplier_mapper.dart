import 'package:form_flow/models/API/supplier_api_model.dart';
import 'package:form_flow/models/supplier_data.dart';

extension SupplierMapper on SupplierModel {
  SupplierApiModel toApiModel() {
    return SupplierApiModel(
      supplierId: id!,
      planArriveDate: planArriveDate!
          .toIso8601String()
          .replaceAll("T", " ")
          .substring(0, 16),
    );
  }
}
