import 'package:dio/dio.dart';
import 'package:grocery_delivery_boy/common/models/track_body_model.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:grocery_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:grocery_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;
  TrackerRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> addTrack(double lat, double long, String location) async {
    try {
      TrackBodyModel trackBody = TrackBodyModel(
        orderId: sharedPreferences!.getInt(AppConstants.orderId).toString(),
        token: sharedPreferences!.getString(AppConstants.token),
        latitude: lat, longitude: long, location: location,
      );
      Response response = await dioClient!.post(AppConstants.recordLocationUri, data: trackBody.toJson());
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<bool> setOrderID(int orderID) async {
    return await sharedPreferences!.setInt(AppConstants.orderId, orderID);
  }

}