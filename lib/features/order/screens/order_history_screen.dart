import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/helper/date_converter_helper.dart';
import 'package:grocery_delivery_boy/helper/price_converter_helper.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/features/order/providers/order_provider.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:grocery_delivery_boy/features/order/screens/order_details_screen.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getOrderHistory(context);
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          getTranslated('order_history', context),
          style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) => order.allOrderHistory == null ? Center(child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        )) : (order.allOrderHistory?.isNotEmpty ?? false) ? RefreshIndicator(
          onRefresh: () => order.refresh(context),
          displacement: 20,
          color: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          key: _refreshIndicatorKey,
          child: order.allOrderHistory!.isNotEmpty ? ListView.builder(
            itemCount: order.allOrderHistory!.length,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_)
                => OrderDetailsScreen(orderModelItem: order.allOrderHistory![index])));
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(.5), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${getTranslated('order_id', context)} #${order.allOrderHistory![index].id}',
                                style:
                                rubikMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(getTranslated('amount', context), style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(
                            children: [
                              Text(getTranslated('status', context),
                                  style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
                              Text(getTranslated('${order.allOrderHistory![index].orderStatus}', context),
                                  style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                            ],
                          ),
                          Text(PriceConverterHelper.convertPrice(context, order.allOrderHistory![index].orderAmount),
                              style: rubikMedium.copyWith(color: Theme.of(context).primaryColor)),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Row(children: [
                          Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).textTheme.bodyLarge!.color)),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            '${getTranslated('order_at', context)}${DateConverterHelper.isoStringToLocalDateOnly(order.allOrderHistory![index].updatedAt!)}',
                            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color),
                          ),
                        ]),
                      ]),
                    ),
                  ]),
                ]),
              ),
            ),
          ) : Center(child: Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Text(
              getTranslated('no_data_found', context),
              style: rubikRegular.copyWith(color: Theme.of(context).primaryColor),
            ),
          )),
        ) : Center(child: Text(
          getTranslated('no_history_available', context),
          style: rubikRegular,
        )),
      ),
    );
  }
}
