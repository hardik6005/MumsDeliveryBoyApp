import 'package:dio/dio.dart';

class ApiResponseModel {
  final Response? response;
  final dynamic error;

  ApiResponseModel(this.response, this.error);

  ApiResponseModel.withError(dynamic errorValue)
      : response = null,
        error = errorValue;

  ApiResponseModel.withSuccess(Response responseValue)
      : response = responseValue,
        error = null;
}
