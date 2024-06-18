import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:grocery_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:grocery_delivery_boy/features/language/domain/models/language_model.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  LanguageRepo({required this.dioClient, required this.sharedPreferences});

  List<LanguageModel> getAllLanguages({BuildContext? context}) {
    return AppConstants.languages;
  }

  Future<ApiResponseModel> changeLanguageApi({required String? languageCode}) async {
    try {
      Response? response = await dioClient!.post(
        AppConstants.changeLanguage,
        data: {'language_code' : languageCode, 'token' : sharedPreferences!.get(AppConstants.token)},
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
