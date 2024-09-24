import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:grocery_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  OrderRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getAllOrders() async {
    try {
      final response = await dioClient!.get('${AppConstants.currentOrdersUri}${sharedPreferences!.get(AppConstants.token)}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getOrderDetails({String? orderID}) async {
    try {
      final response = await dioClient!.post('${AppConstants.orderDetailsUri}${sharedPreferences!.get(AppConstants.token)}&order_id=$orderID');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getAllOrderHistory() async {
    try {
      final response = await dioClient!.get('${AppConstants.orderHistoryUri}${sharedPreferences!.get(AppConstants.token)}');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> updateOrderStatus({String? token, int? orderId, String? status, String? otp}) async {
    try {
      // print("REQUEST:::::-------"+{"token": token, "order_id": orderId, "status": status, "_method": 'put', "order_otp": otp}.toString());
      Response response = await dioClient!.post(
        AppConstants.updateOrderStatusUri,
        data: {"token": token, "order_id": orderId, "status": status, "_method": 'put', "order_otp": otp??""},
      );
      // print("EWEWEWEWEWEWEWEWEWEWEWWEWE-------${response.data.toString()}");
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      // print("EWEWEWEWEWEWEWEWE------${e.toString()}");
      Fluttertoast.showToast(
          msg: "Invalid Otp!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> updatePaymentStatus({String? token, int? orderId, String? status}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.updatePaymentStatusUri,
        data: {"token": token, "order_id": orderId, "status": status, "_method": 'put'},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponseModel> getOrderModel(String orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.getOrderModel}${sharedPreferences!.get(AppConstants.token)}&id=$orderId');
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }


}
