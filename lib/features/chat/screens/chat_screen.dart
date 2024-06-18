
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:grocery_delivery_boy/common/models/order_model.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_image_widget.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/features/chat/providers/chat_provider.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:provider/provider.dart';

import '../widgets/message_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  final OrderModel? orderModel;
  const ChatScreen({Key? key,required this.orderModel}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver{
  final TextEditingController _inputMessageController = TextEditingController();
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    final ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);

    chatProvider.getChatMessages(widget.orderModel?.id);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      chatProvider.getChatMessages(widget.orderModel?.id);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      chatProvider.getChatMessages(widget.orderModel?.id);

    });

  }
  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.orderModel?.customer?.fName} ${widget.orderModel?.customer?.lName ?? ''}', style: rubikMedium.copyWith(color: Colors.white),),
        leading: const BackButton(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Container(width: 40,height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 2,color: Theme.of(context).cardColor),
                color: Theme.of(context).cardColor),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomImageWidget(
                fit: BoxFit.cover,
                placeholder: Images.placeholderImage,
                image: '${splashProvider.baseUrls?.customerImageUrl}/${widget.orderModel?.customer?.image}',
              ),
            ),
          ),
        )],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          return Column(children: [
            Expanded(
              child: chatProvider.messages.isNotEmpty ?  ListView.builder(
                reverse: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index){
                  return MessageBubbleWidget(messages: chatProvider.messages[index]);
                },
              ) : const SizedBox(),
            ),

            Container(color: Theme.of(context).cardColor, child: Column(
              children: [

                chatProvider.chatImage.isNotEmpty ? SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: chatProvider.chatImage.length,
                    itemBuilder: (BuildContext context, index){
                      return  chatProvider.chatImage.isNotEmpty?
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(width: 100, height: 100,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                child: Image.file(File(chatProvider.chatImage[index].path), width: 100, height: 100, fit: BoxFit.cover,
                                ),
                              ) ,
                            ),
                            Positioned(
                              top:0,right:0,
                              child: InkWell(
                                onTap :() => chatProvider.removeImage(index),
                                child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(Icons.clear,color: Colors.red,size: 15,),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ):const SizedBox();

                    },
                  ),
                ) : const SizedBox(),

                Row(children: [
                  InkWell(
                    onTap: ()=> chatProvider.onPickImage(false),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(width: 25,height: 25,
                        child: Image.asset(Images.image, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                  ),

                  SizedBox(height: 25, child: VerticalDivider(
                    width: 0, thickness: 1,
                    color: Theme.of(context).hintColor,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(child: TextField(
                    controller: _inputMessageController,
                    textCapitalization: TextCapitalization.sentences,
                    style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (newText){
                      if(newText.trim().isNotEmpty && !chatProvider.isSendButtonActive) {
                        chatProvider.onChangeSendButtonStatus();
                      }else if(newText.isEmpty && chatProvider.isSendButtonActive) {
                        chatProvider.onChangeSendButtonStatus();
                      }
                    },
                    onSubmitted: (String newText) {
                      if(newText.trim().isNotEmpty && !chatProvider.isSendButtonActive) {
                        chatProvider.onChangeSendButtonStatus();
                      }else if(newText.isEmpty && chatProvider.isSendButtonActive) {
                        chatProvider.onChangeSendButtonStatus();
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: getTranslated('type_here', context),
                      hintStyle: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
                    ),
                  )),

                  InkWell(
                    onTap: () async {
                      if(chatProvider.isSendButtonActive){
                        chatProvider.sendMessage(_inputMessageController.text.trim(),chatProvider.chatImage,widget.orderModel!.id).then((value){
                          _inputMessageController.clear();
                          if(value.statusCode==200){
                            chatProvider.getChatMessages(widget.orderModel!.id);
                            _inputMessageController.clear();
                          }
                        });
                        chatProvider.onChangeSendButtonStatus();

                      }else{
                        showCustomSnackBarHelper(getTranslated('write_some_thing', context));
                      }

                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: chatProvider.isLoading ? const SizedBox(
                        width: 25, height: 25,
                        child: CircularProgressIndicator(),
                      ) : Image.asset(Images.send, width: 25, height: 25,
                        color: chatProvider.isSendButtonActive ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                      ),
                    ),
                  ),

                ]),
              ],
            )),
          ]);
        }
      ),
    );
  }
}