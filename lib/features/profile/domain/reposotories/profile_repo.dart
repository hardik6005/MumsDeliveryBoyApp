import 'package:grocery_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:grocery_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getUserInfo() async {
    try {
      final response = await dioClient!.get('${AppConstants.profileUri}${sharedPreferences!.getString(AppConstants.token)}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
