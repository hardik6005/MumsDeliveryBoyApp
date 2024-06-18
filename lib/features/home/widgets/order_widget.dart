import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_delivery_boy/common/models/order_model.dart';
import 'package:grocery_delivery_boy/helper/location_helper.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:grocery_delivery_boy/features/order/screens/order_details_screen.dart';
import 'package:provider/provider.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel? orderModel;
  final int index;
  const OrderWidget({Key? key, this.orderModel, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(.5),
          spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1),
        )],
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text(
                getTranslated('order_id', context),
                style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
              ),

              Text(
                ' # ${orderModel?.id}',
                style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
              ),
            ]),

            Stack(clipBehavior: Clip.none, children: [
              Container(),

              Provider.of<LocalizationProvider>(context).isLtr ? Positioned(
                right: -10,
                top: -23,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(Dimensions.paddingSizeSmall),
                          bottomLeft: Radius.circular(Dimensions.paddingSizeSmall))),
                  child: Text(
                    getTranslated('${orderModel?.orderStatus}', context),
                    style: rubikRegular
                        .copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
              ) : Positioned(
                left: -10,
                top: -28,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(Dimensions.paddingSizeSmall),
                          bottomLeft: Radius.circular(Dimensions.paddingSizeSmall))),
                  child: Text(
                    getTranslated('${orderModel?.orderStatus}', context),
                    style: rubikRegular
                        .copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                ),
              ),
            ]),

          ]),
          const SizedBox(height: 25),

          Row(children: [
            Image.asset(
              Images.location,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              width: Dimensions.paddingSizeDefault,
              height: Dimensions.paddingSizeLarge,
            ),
            const SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(child: Text(
              orderModel?.deliveryAddress?.address ?? getTranslated('address_not_found', context),
              style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
            )),
          ]),
          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

          Row(children: [
            Expanded(
              child: CustomButtonWidget(
                btnTxt: getTranslated('view_details', context),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderModelItem: orderModel)));
                },
                isShowBorder: true,
              ),
            ),
            const SizedBox(width: Dimensions.paddingSizeLarge),

            Expanded(child: CustomButtonWidget(
              btnTxt: getTranslated('direction', context),
              onTap: () {
                Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) {
                  LocationHelper.openMap(
                    double.parse(orderModel?.deliveryAddress?.latitude ?? '0'),
                    double.parse(orderModel?.deliveryAddress?.longitude ?? '0'),
                    position.latitude,
                    position.longitude,
                  );
                });
              },
            )),
          ]),
        ],
      ),
    );
  }
}
