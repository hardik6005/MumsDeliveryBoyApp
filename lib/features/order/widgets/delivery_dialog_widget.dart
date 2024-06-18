import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/common/models/order_model.dart';
import 'package:grocery_delivery_boy/helper/price_converter_helper.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:grocery_delivery_boy/features/order/providers/order_provider.dart';
import 'package:grocery_delivery_boy/common/providers/tracker_provider.dart';
import 'package:grocery_delivery_boy/main.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:grocery_delivery_boy/features/order/screens/order_details_screen.dart';
import 'package:grocery_delivery_boy/features/order/screens/order_delivered_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class DeliveryDialogWidget extends StatefulWidget {
  final Function onTap;
  final OrderModel? orderModel;
  final double? totalPrice;
  TextEditingController? inputPinTextController;

  DeliveryDialogWidget({Key? key, required this.onTap, this.totalPrice, this.orderModel, this.inputPinTextController}) : super(key: key);

  @override
  State<DeliveryDialogWidget> createState() => _DeliveryDialogWidgetState();
}

class _DeliveryDialogWidgetState extends State<DeliveryDialogWidget> {

  @override
  void initState() {
    super.initState();
    widget.inputPinTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
            border: Border.all(color: Theme.of(context).primaryColor, width: 0.2)),
        child: Stack(
          clipBehavior: Clip.none, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Image.asset(Images.money),
                const SizedBox(height: 20),
                Center(
                    child: Text(
                  getTranslated('do_you_collect_money', context),
                  style: rubikRegular,
                )),
                const SizedBox(height: 20),
                Center(
                    child: Text(
                  PriceConverterHelper.convertPrice(context, widget.totalPrice),
                  style: rubikRegular.copyWith(color: Theme.of(context).primaryColor,fontSize: 30),
                )),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: CustomButtonWidget(
                      btnTxt: getTranslated('no', context),
                      isShowBorder: true,
                      onTap: () {

                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModelItem: widget.orderModel)));

                      },
                    )),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(
                        child: Consumer<OrderProvider>(
                      builder: (context, order, child) {
                        return !order.isLoading ? CustomButtonWidget(
                          btnTxt: getTranslated('yes', context),
                          onTap: () {
                            widget.inputPinTextController = TextEditingController();
                            showDialog(
                              context: Get.context!,
                              barrierDismissible: false,
                              builder: (ctx) {
                                return AlertDialog(
                                  // title: Text(""),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(Images.icOtp, height: 70,),
                                      SizedBox(height: 20,),
                                      const Text("Take OTP from customer for verification"),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 35),
                                        child: PinCodeTextField(
                                          controller: widget.inputPinTextController,
                                          length: 6,
                                          appContext: context,
                                          obscureText: false,
                                          enabled: true,
                                          keyboardType: TextInputType.number,
                                          animationType: AnimationType.fade,
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            fieldHeight: 43,
                                            fieldWidth: 32,
                                            borderWidth: 1,
                                            borderRadius: BorderRadius.circular(5),
                                            selectedColor: Theme.of(context).primaryColor.withOpacity(.2),
                                            selectedFillColor: Colors.white,
                                            inactiveFillColor: Theme.of(context).cardColor,
                                            inactiveColor: Theme.of(context).primaryColor.withOpacity(.2),
                                            activeColor: Theme.of(context).primaryColor.withOpacity(.4),
                                            activeFillColor: Theme.of(context).cardColor,
                                          ),
                                          animationDuration: const Duration(milliseconds: 300),
                                          backgroundColor: Colors.transparent,
                                          enableActiveFill: true,
                                          onChanged: (query) => {if (query.length == 6) {}},
                                          beforeTextPaste: (text) {
                                            return true;
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Consumer<OrderProvider>(
                                          builder: (context, order, child) {
                                            return !order.isLoading?CustomButtonWidget(
                                                btnTxt: "Verify",
                                                isLoading: false,
                                                onTap: () {
                                                  if (widget.inputPinTextController!.text.length == 6) {
                                                    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDeliveredScreen(orderID: widget.orderModel!.id.toString())));
                                                    Provider.of<TrackerProvider>(context, listen: false).stopLocationService();
                                                    Provider.of<OrderProvider>(context, listen: false).updateOrderStatus(
                                                        token: Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                                                        orderId: widget.orderModel!.id,
                                                        status: 'delivered', otp: widget.inputPinTextController!.text).then((value) {
                                                      if (value.isSuccess) {
                                                        order.updatePaymentStatus(
                                                            token: Provider.of<AuthProvider>(context, listen: false).getUserToken(), orderId: widget.orderModel!.id, status: 'paid');
                                                        Provider.of<OrderProvider>(context, listen: false).getAllOrders();
                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDeliveredScreen(orderID: widget.orderModel!.id.toString())));
                                                      }
                                                    });

                                                    setState(() {});

                                                  }
                                                }) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          10)),
                                );
                              },
                            );

                          },
                        ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
                      },
                    )),
                  ],
                ),
              ],
            ),
            Positioned(
              right: -20,
              top: -20,
              child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.clear, size: Dimensions.paddingSizeLarge),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModelItem: widget.orderModel)));
                  }),
            ),
          ],
        ),
      ),
    );
  }

}
