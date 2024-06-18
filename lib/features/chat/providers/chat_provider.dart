
import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:grocery_delivery_boy/features/chat/domain/models/chat_model.dart';
import 'package:grocery_delivery_boy/features/chat/domain/reposotories/chat_repo.dart';
import 'package:grocery_delivery_boy/helper/api_checker_helper.dart';
import 'package:grocery_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
class ChatProvider with ChangeNotifier {
  final ChatRepo? chatRepo;
  ChatProvider({required this.chatRepo});

  List<Messages>  _messages = [];
  List<Messages> get messages => _messages;

  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;

  List <XFile>? _imageFile;
  List <XFile>? get imageFile => _imageFile;

  List <XFile>_chatImage = [];
  List<XFile> get chatImage => _chatImage;

  bool _isLoading= false;
  bool get isLoading => _isLoading;

  Future<void> getChatMessages (int? orderId) async {

    ApiResponseModel apiResponse = await chatRepo!.getMessage(orderId,1);

    if (apiResponse.response != null&& apiResponse.response!.data['messages']!= {} && apiResponse.response!.statusCode == 200) {
      _messages = [];
      _messages.addAll(ChatModel.fromJson(apiResponse.response!.data).messages!);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    notifyListeners();
  }

  void onPickImage(bool isRemove) async {
    final ImagePicker picker = ImagePicker();
    if(isRemove) {
      _imageFile = [];
      _chatImage = [];
    }else {
      _imageFile = await picker.pickMultiImage(imageQuality: 30);
      if (_imageFile != null) {
        _chatImage.addAll(_imageFile!);
      }
    }
    _isSendButtonActive = true;
    notifyListeners();
  }

  void removeImage(int index){
    chatImage.removeAt(index);
    notifyListeners();
  }

  void onChangeSendButtonStatus() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  Future<http.StreamedResponse> sendMessage(String message, List<XFile> file, int? orderId) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await chatRepo!.sendMessage(message, file, orderId);
    if (response.statusCode == 200) {
      _imageFile = [];
      _chatImage = [];
      file =[];
      await getChatMessages(orderId);
      _isLoading= false;
    } else {
      showCustomSnackBarHelper(response.statusCode.toString());
    }
    _imageFile = [];
    _isLoading= false;
    notifyListeners();
    return response;
  }

}
