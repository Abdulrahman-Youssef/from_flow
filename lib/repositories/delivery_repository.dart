import 'package:dio/dio.dart';
import 'package:form_flow/core/data/constant/services_routes.dart';
import 'package:form_flow/core/utils/handle_dio_errors.dart';
import 'package:form_flow/repositories/api_repository.dart';

class DeliveryRepository  {
  final ApiRepository _apiService = ApiRepository();

  // this what every function will return
  late Map<String, dynamic> responseData;

  Future<Map<String, dynamic>> getDropDownData() async {
    try {
      final response = await _apiService.get(ServicesRoutes.deliveryDormData);
      if (response.statusCode == 200 && response.data != null) {
        responseData = response.data;
        return responseData;
      } else {
        throw "Response has no data";
      }
    } on DioException catch(e)  {
      throw handleDioException;
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<List<dynamic>> fetchDeliveriesSummaryData() async {
    try {
      final response = await _apiService.get(ServicesRoutes.deliveriesSummary);
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw "Response has no data";
      }
    } on DioException catch (e) {
      throw handleDioException;
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }
}
