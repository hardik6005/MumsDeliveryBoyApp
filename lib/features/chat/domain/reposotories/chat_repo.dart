import 'dart:io';
import 'dart:async';
import 'package:grocery_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:grocery_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:grocery_delivery_boy/utill/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ChatRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ChatRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getMessage(int? orderId,int offset) async {
    try {
      final response = await dioClient!.post('${AppConstants.getMessageUri}?offset=$offset&limit=100',  data: {"order_id": orderId, "token": sharedPreferences!.getString(AppConstants.token)},);
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> sendMessage(String message, List<XFile> file, int? orderId) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.sendMessageUri}'));
    for(int i=0; i<file.length;i++){
      File file0 = File(file[i].path);
      request.files.add(http.MultipartFile('image[]', file0.readAsBytes().asStream(), file0.lengthSync(), filename: file0.path.split('/').last));
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'message': message,
      'token':  sharedPreferences!.getString(AppConstants.token)!,
      'order_id': orderId.toString(),

    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

}
