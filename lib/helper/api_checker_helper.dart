import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/common/models/error_response_model.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/main.dart';
import 'package:provider/provider.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/features/auth/screens/login_screen.dart';

class ApiCheckerHelper {
  static void checkApi(ApiResponseModel apiResponse) {
    ErrorResponseModel error = getError(apiResponse);

    if((error.errors![0].code == '401' || error.errors![0].code == 'auth-001')) {
      Provider.of<SplashProvider>(Get.context!, listen: false).removeSharedData();
      Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    }else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(error.errors![0].message ?? getTranslated('not_found', Get.context!)
            , style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    }
  }

  static ErrorResponseModel getError(ApiResponseModel apiResponse){
    ErrorResponseModel error;

    try{
      error = ErrorResponseModel.fromJson(apiResponse);
    }catch(e){
      if(apiResponse.error != null){
        error = ErrorResponseModel.fromJson(apiResponse.error);
      }else{
        error = ErrorResponseModel(errors: [Errors(code: '', message: apiResponse.error.toString())]);
      }
    }
    return error;
  }
}