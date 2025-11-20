import 'package:dio/dio.dart';
import 'package:form_flow/core/data/constant/services_routes.dart';
import 'package:form_flow/core/utils/handle_dio_errors.dart';
import 'package:form_flow/repositories/api_repository.dart';
import 'package:get/get.dart';

class VersionRepository {
  final ApiRepository _api = Get.find<ApiRepository>();

  Future<Map<String, dynamic>> getVersion() async {
    try {
      final response = await _api.get(ServicesRoutes.appVersion);

      if (response.statusCode == 200 && response.data != null) {
        return response.data;
      } else {
        throw "Request failed";
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw "Unexpected error: $e";
    }
  }
}
