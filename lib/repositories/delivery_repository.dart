import 'package:dio/dio.dart';
import 'package:form_flow/core/data/constant/services_routes.dart';
import 'package:form_flow/core/utils/handle_dio_errors.dart';
import 'package:form_flow/models/API/delivery_api_model.dart';
import 'package:form_flow/repositories/api_repository.dart';
import 'package:get/get.dart';

class DeliveryRepository {
  final ApiRepository _apiService = Get.find<ApiRepository>();

  // this what every function will return

  Future<Map<String, dynamic>> getDropDownData() async {
    try {
      final response = await _apiService.get(ServicesRoutes.deliveryDropData);
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw "Response has no data";
      }
    } on DioException catch (e) {
      throw handleDioException(e);
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
      throw handleDioException(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<Map<String, dynamic>> createDelivery(DeliveryApiModel delivery) async {
    try {
      final response = await _apiService.post( ServicesRoutes.createDelivery,
          data: delivery.toJson());
      if (response.statusCode == 201 && response.data != null) {
        return response.data;
      } else {
        throw "create request failed";
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw "an unexpected error";
    }
  }

  Future<Map<String, dynamic>> updateDelivery(DeliveryApiModel delivery) async {
    try {
      // id checked in the previous  step
      final response = await _apiService.put(
          ServicesRoutes.updateDelivery(delivery.id!),
          data: delivery.toJson());
      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw "create request failed";
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw "An unexpected error";
    }
  }

  Future<Map<String, dynamic>> fetchDelivery(int deliveryID)async {
    try {
      final response =
         await _apiService.get(ServicesRoutes.deliveryDetails(deliveryID));
      print(response.data);
      if(response.statusCode == 200 && response.data != null){
        return response.data;
      }else{
        throw "failed fetching delivery with id : $deliveryID";
      }
    } on DioException catch (e) {
     throw handleDioException(e);
    } catch (e) {
      throw "An unexpected error $e";
    }
  }

  Future<bool> removeDelivery(int deliveryID) async {

      try{
        final response = await _apiService.delete(ServicesRoutes.deleteDelivery(deliveryID));
        if(response.statusCode == 200 && response.data != null )
        {
          return true;
        }else{
          return false ;
        }
      }on DioException catch(e){
        throw handleDioException(e);
      }catch(e){
        throw "An unexpected error $e";
      }
  }
}
