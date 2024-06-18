import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/common/models/order_model.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_image_widget.dart';
import 'package:grocery_delivery_boy/features/order/screens/image_view_screen.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:provider/provider.dart';

class OrderImageNoteWidget extends StatelessWidget {
  final OrderModel? orderModel;
  const OrderImageNoteWidget({Key? key, required this.orderModel}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return (orderModel?.orderImageList?.isNotEmpty ?? false) ? Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            splashProvider.configModel?.orderImageLabelName ?? '',
            style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          Divider(height: Dimensions.paddingSizeLarge, color: Theme.of(context).dividerColor.withOpacity(0.3)),

          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: orderModel?.orderImageList?.length ?? 0,
              itemBuilder: (ctx, index){

                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ImageViewScreen(
                      baseUrl: splashProvider.configModel?.baseUrls?.orderImageUrl,
                      title: splashProvider.configModel?.orderImageLabelName,
                      imageList: [orderModel?.orderImageList?[index].image ?? ''],
                    )));

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                      child: CustomImageWidget(
                          width: 100, height: 100,
                          image: '${splashProvider.configModel?.baseUrls?.orderImageUrl}/${orderModel?.orderImageList?[index].image}'
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    ) : const SizedBox();
  }
}
