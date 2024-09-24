import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery_delivery_boy/common/models/order_model.dart';
import 'package:grocery_delivery_boy/common/providers/tracker_provider.dart';
import 'package:grocery_delivery_boy/common/widgets/custom_button_widget.dart';
import 'package:grocery_delivery_boy/features/auth/providers/auth_provider.dart';
import 'package:grocery_delivery_boy/features/chat/screens/chat_screen.dart';
import 'package:grocery_delivery_boy/features/language/providers/localization_provider.dart';
import 'package:grocery_delivery_boy/features/order/domain/models/timeslot_model.dart';
import 'package:grocery_delivery_boy/features/order/providers/order_provider.dart';
import 'package:grocery_delivery_boy/features/order/screens/order_delivered_screen.dart';
import 'package:grocery_delivery_boy/features/order/widgets/custom_divider_widget.dart';
import 'package:grocery_delivery_boy/features/order/widgets/delivery_dialog_widget.dart';
import 'package:grocery_delivery_boy/features/order/widgets/order_image_note_widget.dart';
import 'package:grocery_delivery_boy/features/order/widgets/slider_button_widget.dart';
import 'package:grocery_delivery_boy/features/splash/providers/splash_provider.dart';
import 'package:grocery_delivery_boy/helper/date_converter_helper.dart';
import 'package:grocery_delivery_boy/helper/location_helper.dart';
import 'package:grocery_delivery_boy/helper/price_converter_helper.dart';
import 'package:grocery_delivery_boy/helper/show_custom_snackbar_helper.dart';
import 'package:grocery_delivery_boy/localization/language_constrants.dart';
import 'package:grocery_delivery_boy/main.dart';
import 'package:grocery_delivery_boy/utill/dimensions.dart';
import 'package:grocery_delivery_boy/utill/images.dart';
import 'package:grocery_delivery_boy/utill/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModelItem;

  const OrderDetailsScreen({Key? key, this.orderModelItem}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderModel? orderModel;
  double? deliveryCharge = 0;
  final TextEditingController inputPinTextController = TextEditingController();
  bool? isLoading = false;

  _loadData() {
    orderModel = widget.orderModelItem;
    if (orderModel?.orderAmount == null) {
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderModel('${orderModel!.id}')
          .then((OrderModel? value) {
        orderModel = value;
        if (orderModel?.orderType == 'delivery') {
          deliveryCharge = orderModel?.deliveryCharge;
        }
      }).then((value) {
        Provider.of<OrderProvider>(context, listen: false)
            .getOrderDetails(orderModel!.id.toString(), widget.orderModelItem!);
      });
    } else {
      if (orderModel?.orderType == 'delivery') {
        deliveryCharge = orderModel?.deliveryCharge;
      }
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderDetails(orderModel!.id.toString(), widget.orderModelItem!);
    }
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          getTranslated('order_details', context),
          style: rubikRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge!.color),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          double itemsPrice = 0;
          double discount = 0;
          double extraDiscount = orderModel?.extraDiscount ?? 0;
          double tax = 0;
          bool? isVatInclude = false;
          TimeSlotModel? timeSlot;
          if (order.orderDetails != null && orderModel?.orderAmount != null) {
            for (var orderDetails in order.orderDetails!) {
              itemsPrice =
                  itemsPrice + (orderDetails.price! * orderDetails.quantity!);
              discount = discount +
                  (orderDetails.discountOnProduct! * orderDetails.quantity!);
              tax = tax + (orderDetails.taxAmount! * orderDetails.quantity!);
              isVatInclude = orderDetails.isVatInclude;
            }
            try {
              timeSlot = order.timeSlots!.firstWhere(
                  (timeSlot) => timeSlot.id == orderModel?.timeSlotId);
            } catch (e) {
              timeSlot = null;
            }
          }
          double subTotal = itemsPrice + (isVatInclude! ? 0 : tax);
          double totalPrice = subTotal -
              discount +
              deliveryCharge! -
              (orderModel?.couponDiscountAmount ?? 0) -
              extraDiscount;

       /*   List<OrderPartialPayment> paymentList = [];
          double dueAmount = 0;

          if (orderModel != null &&
              orderModel?.orderPartialPayments != null &&
              orderModel!.orderPartialPayments!.isNotEmpty) {


            // paymentList.addAll(orderModel!.orderPartialPayments!);
            OrderPartialPayment paidModel = OrderPartialPayment();
            double? paidAmount = 0;
            orderModel!.orderPartialPayments!.asMap().forEach((key, value) {
              print("VALUE_________${value.paidAmount}");
              paidAmount = paidAmount! + value.paidAmount!;
            });

            paidModel = orderModel!.orderPartialPayments!.first;
            paidModel.paidAmount = paidAmount;

            paymentList.add(paidModel);

            if ((orderModel?.orderPartialPayments?.first.dueAmount ?? 0) > 0) {
              dueAmount = orderModel?.orderPartialPayments?.first.dueAmount ?? 0;
              paymentList.add(OrderPartialPayment(
                id: -1,
                paidAmount: 0,
                paidWith: orderModel?.paymentMethod,
                dueAmount: orderModel?.orderPartialPayments?.first.dueAmount,
              ));
            }
          }

*/

          return order.orderDetails != null && orderModel?.orderAmount != null
              ? Column(
                  children: [
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        children: [
                          Row(children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                      child: Text(
                                          getTranslated('order_id', context),
                                          style: rubikRegular.copyWith())),
                                  Text(' # ${orderModel?.id}',
                                      style: rubikMedium),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(Icons.watch_later, size: 17),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  if (orderModel?.createdAt != null)
                                    Text(
                                        DateConverterHelper
                                            .isoStringToLocalDateOnly(
                                                orderModel!.createdAt!),
                                        style: rubikRegular.copyWith()),
                                ],
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),

                          timeSlot != null
                              ? Row(children: [
                                  Text(
                                      '${getTranslated('delivery_time', context)}:',
                                      style: rubikRegular),
                                  const SizedBox(
                                      width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                      DateConverterHelper.convertTimeRange(
                                          timeSlot.startTime!,
                                          timeSlot.endTime!,
                                          context),
                                      style: rubikMedium),
                                ])
                              : const SizedBox(),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Container(
                            padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('customer', context),
                                      style: rubikRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall)),
                                  ListTile(
                                    leading: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholderUser,
                                        image:
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.customerImageUrl}/${orderModel?.customer?.image ?? ''}',
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder: (c, o, s) =>
                                            Image.asset(Images.placeholderUser,
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                    title: Text(
                                      orderModel?.deliveryAddress
                                              ?.contactPersonName ??
                                          '',
                                      style: rubikRegular.copyWith(
                                          fontSize: Dimensions.fontSizeLarge),
                                    ),
                                    trailing: orderModel?.deliveryAddress
                                                ?.contactPersonNumber !=
                                            null
                                        ? InkWell(
                                            onTap: () {
                                              launchUrlString(
                                                  'tel:${orderModel?.deliveryAddress?.contactPersonNumber}',
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(
                                                  Dimensions
                                                      .paddingSizeExtraSmall),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .hintColor
                                                      .withOpacity(0.2)),
                                              child: const Icon(
                                                  Icons.call_outlined),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ),
                                ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text('${getTranslated('item', context)}:',
                                    style: rubikRegular.copyWith()),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Text(order.orderDetails!.length.toString(),
                                    style: rubikMedium.copyWith(
                                        color: Theme.of(context).primaryColor)),
                              ]),
                              orderModel?.orderStatus == 'processing' ||
                                      orderModel?.orderStatus ==
                                          'out_for_delivery'
                                  ? Row(children: [
                                      Text(
                                          '${getTranslated('payment_status', context)}:',
                                          style: rubikRegular.copyWith()),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(
                                          getTranslated(
                                              '${orderModel?.paymentStatus}',
                                              context),
                                          style: rubikMedium.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ])
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const Divider(height: Dimensions.paddingSizeLarge),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: order.orderDetails!.length,
                            itemBuilder: (context, index) {
                              final String variationValue = _getVariationValue(
                                  order.orderDetails?[index].modifiedVariation);

                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderImage,
                                          height: 70,
                                          width: 80,
                                          fit: BoxFit.cover,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.productImageUrl}/${(order.orderDetails?[index].productDetails?.image?.isNotEmpty ?? false) ? (order.orderDetails?[index].productDetails?.image?.first) : ''}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                                  Images.placeholderImage,
                                                  height: 70,
                                                  width: 80,
                                                  fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(
                                          width: Dimensions.paddingSizeSmall),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      order
                                                          .orderDetails![index]
                                                          .productDetails!
                                                          .name!,
                                                      style: rubikRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${getTranslated('quantity', context)}:',
                                                      style: rubikRegular),
                                                  const SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                      order.orderDetails![index]
                                                          .quantity
                                                          .toString(),
                                                      style:
                                                          rubikRegular.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)),
                                                ],
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeExtraSmall),
                                              Row(children: [
                                                Text(
                                                  PriceConverterHelper.convertPrice(
                                                      context,
                                                      order.orderDetails![index]
                                                              .price! -
                                                          order
                                                              .orderDetails![
                                                                  index]
                                                              .discountOnProduct!
                                                              .toDouble()),
                                                  style: rubikRegular,
                                                ),
                                                const SizedBox(width: 5),
                                                order.orderDetails![index]
                                                            .discountOnProduct! >
                                                        0
                                                    ? Expanded(
                                                        child: Text(
                                                        PriceConverterHelper
                                                            .convertPrice(
                                                                context,
                                                                order
                                                                    .orderDetails![
                                                                        index]
                                                                    .price!
                                                                    .toDouble()),
                                                        style: rubikRegular
                                                            .copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                          color:
                                                              Theme.of(context)
                                                                  .hintColor,
                                                        ),
                                                      ))
                                                    : const SizedBox(),
                                              ]),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeSmall),
                                              Builder(builder: (context) {
                                                return variationValue.isNotEmpty
                                                    ? Row(children: [
                                                        Container(
                                                            height: 10,
                                                            width: 10,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color,
                                                            )),
                                                        const SizedBox(
                                                            width: Dimensions
                                                                .paddingSizeExtraSmall),
                                                        Text(
                                                          variationValue,
                                                          style: rubikRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeSmall),
                                                        ),
                                                      ])
                                                    : const SizedBox();
                                              })
                                            ]),
                                      ),
                                    ]),
                                    const Divider(
                                        height: Dimensions.paddingSizeLarge),
                                  ]);
                            },
                          ),

                          (orderModel?.orderNote != null &&
                                  orderModel!.orderNote!.isNotEmpty)
                              ? Container(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  margin: const EdgeInsets.only(
                                      bottom: Dimensions.paddingSizeLarge),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).hintColor),
                                  ),
                                  child: Text('${orderModel?.orderNote}',
                                      style: rubikRegular.copyWith(
                                          color: Theme.of(context).hintColor)),
                                )
                              : const SizedBox(),

                          if (orderModel?.orderImageList?.isNotEmpty ?? false)
                            OrderImageNoteWidget(orderModel: orderModel),

                          // Total
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('items_price', context),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                                Text(
                                    PriceConverterHelper.convertPrice(
                                        context, itemsPrice),
                                    style: rubikRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge)),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${getTranslated('tax', context)} ${isVatInclude ? getTranslated('include', context) : ''}',
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                                Text(
                                    '${isVatInclude ? '' : '(+)'} ${PriceConverterHelper.convertPrice(context, tax)}',
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeSmall),
                            child: CustomDividerWidget(),
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('subtotal', context),
                                    style: rubikMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                                Text(
                                    PriceConverterHelper.convertPrice(
                                        context, subTotal),
                                    style: rubikMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('discount', context),
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                                Text(
                                    '(-) ${PriceConverterHelper.convertPrice(context, discount)}',
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          if (extraDiscount > 0)
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getTranslated('extra_discount', context),
                                      style: rubikRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                      )),
                                  Text(
                                      '(-) ${PriceConverterHelper.convertPrice(context, extraDiscount)}',
                                      style: rubikRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                      )),
                                ]),
                          if (extraDiscount > 0) const SizedBox(height: 10),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('coupon_discount', context),
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                                Text(
                                  '(-) ${PriceConverterHelper.convertPrice(context, orderModel?.couponDiscountAmount)}',
                                  style: rubikRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                  ),
                                ),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('delivery_fee', context),
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                                Text(
                                    '(+) ${PriceConverterHelper.convertPrice(context, deliveryCharge)}',
                                    style: rubikRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                    )),
                              ]),

                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeSmall),
                            child: CustomDividerWidget(),
                          ),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('total_amount', context),
                                    style: rubikMedium.copyWith(
                                        fontSize: Dimensions.fontSizeExtraLarge,
                                        color: Theme.of(context).primaryColor)),
                                Text(
                                  PriceConverterHelper.convertPrice(
                                      context, totalPrice),
                                  style: rubikMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraLarge,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          if (orderModel?.orderPartialPayments != null &&
                              orderModel!.orderPartialPayments!.isNotEmpty)
                            DottedBorder(
                              dashPattern: const [8, 4],
                              strokeWidth: 1.1,
                              borderType: BorderType.RRect,
                              color: Theme.of(context).colorScheme.primary,
                              radius: const Radius.circular(
                                  Dimensions.radiusDefault),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.02),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall,
                                    vertical: 1),
                                child: Column(
                                    children: widget.orderModelItem!.paymentList
                                        .map((payment) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${getTranslated(payment.paidAmount! > 0 ? 'paid_amount' : 'due_amount', context)} (${getTranslated('${payment.paidWith}', context)})",
                                                    style:
                                                        rubikRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .color),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    PriceConverterHelper
                                                        .convertPrice(
                                                            context,
                                                            payment.paidAmount! >
                                                                    0
                                                                ? payment
                                                                    .paidAmount
                                                                : payment
                                                                    .dueAmount),
                                                    style: rubikRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeDefault,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge!
                                                            .color),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList()),
                              ),
                            ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    orderModel?.orderStatus == 'processing' ||
                            orderModel?.orderStatus == 'out_for_delivery'
                        ? Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  child: CustomButtonWidget(
                                      btnTxt:
                                          getTranslated('direction', context),
                                      onTap: () {
                                        Geolocator.getCurrentPosition(
                                                desiredAccuracy:
                                                    LocationAccuracy.high)
                                            .then((position) {
                                          LocationHelper.openMap(
                                              double.parse(
                                                  '${orderModel?.deliveryAddress?.latitude}'),
                                              double.parse(
                                                  '${orderModel?.deliveryAddress?.longitude}'),
                                              position.latitude,
                                              position.longitude);
                                        });
                                      }),
                                ),
                              ),
                              if(orderModel?.orderStatus == 'out_for_delivery')
                                Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: CustomButtonWidget(
                                    btnTxt: "Resent Otp",
                                    isLoading: order.isLoading,
                                    onTap: () {
                                      LocationHelper.checkPermission(context,
                                          callBack: () {
                                        Provider.of<TrackerProvider>(context, listen: false).setOrderID(orderModel!.id!);
                                        Provider.of<TrackerProvider>(context,
                                            listen: false)
                                            .startLocationService();
                                        String token = Provider.of<AuthProvider>(
                                                context,
                                                listen: false)
                                            .getUserToken();
                                        Provider.of<OrderProvider>(context, listen: false)
                                            .updateOrderStatus(
                                          token: token,
                                          orderId: orderModel?.id,
                                          status: 'out_for_delivery',
                                        );
                                        Provider.of<OrderProvider>(context, listen: false).getAllOrders();
                                        // Navigator.pop(context);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    orderModel?.orderStatus != 'delivered' &&
                            !(orderModel?.isGuestOrder ?? false)
                        ? Center(
                            child: Container(
                              width: 1170,
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              child: CustomButtonWidget(
                                  btnTxt: getTranslated(
                                      'chat_with_customer', context),
                                  onTap: () {
                                    if (orderModel?.customer != null) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => ChatScreen(
                                                  orderModel: orderModel)));
                                    } else {
                                      showCustomSnackBarHelper(getTranslated(
                                          'user_not_available', context));
                                    }
                                  }),
                            ),
                          )
                        : const SizedBox(),
                    orderModel?.orderStatus == 'processing'
                        ? Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(.05)),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: Transform.rotate(
                              angle: Provider.of<LocalizationProvider>(context)
                                      .isLtr
                                  ? pi * 2
                                  : pi, // in radians
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: SliderButtonWidget(
                                  action: () {
                                    LocationHelper.checkPermission(context,
                                        callBack: () {
                                      Provider.of<TrackerProvider>(context,
                                              listen: false)
                                          .setOrderID(orderModel!.id!);
                                      Provider.of<TrackerProvider>(context,
                                              listen: false)
                                          .startLocationService();
                                      String token = Provider.of<AuthProvider>(
                                              context,
                                              listen: false)
                                          .getUserToken();
                                      Provider.of<OrderProvider>(context,
                                          listen: false)
                                          .updateOrderStatus(
                                        token: token,
                                        orderId: orderModel?.id,
                                        status: 'out_for_delivery',
                                      );
                                       Provider.of<OrderProvider>(context, listen: false).getAllOrders();
                                      Navigator.pop(context, true);
                                    });
                                  },

                                  ///Put label over here
                                  label: Text(
                                    getTranslated(
                                        'swip_to_deliver_order', context),
                                    style: rubikRegular.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  dismissThresholds: 0.5,
                                  dismissible: false,
                                  icon: const Center(
                                      child: Icon(
                                    Icons.double_arrow_sharp,
                                    color: Colors.white,
                                    size: Dimensions.paddingSizeLarge,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  )),

                                  ///Change All the color and size from here.
                                  radius: 10,
                                  boxShadow: const BoxShadow(blurRadius: 0.0),
                                  buttonColor: Theme.of(context).primaryColor,
                                  backgroundColor: Theme.of(context).cardColor,
                                  baseColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          )
                        : orderModel?.orderStatus == 'out_for_delivery'
                            ? Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.all(
                                    Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.paddingSizeSmall),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(.05)),
                                  color:
                                      Theme.of(context).colorScheme.background,
                                ),
                                child: Transform.rotate(
                                  angle:
                                      Provider.of<LocalizationProvider>(context)
                                              .isLtr
                                          ? pi * 2
                                          : pi, // in radians
                                  child: Directionality(
                                    textDirection:
                                        TextDirection.ltr, // set it to rtl
                                    child: SliderButtonWidget(
                                      action: () {
                                        String token =
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .getUserToken();

                                        if (orderModel?.paymentStatus ==
                                            'paid') {
                                          showDialog(
                                            context: Get.context!,
                                            barrierDismissible: false,
                                            builder: (ctx) => AlertDialog(
                                              // title: Text(""),
                                              content: otpDialog(
                                                  context, token, order),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          );
                                        } else {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0)),
                                                  child: DeliveryDialogWidget(
                                                    onTap: () {},
                                                    totalPrice: (widget.orderModelItem!.dueAmount > 0
                                                        ? widget.orderModelItem!.dueAmount
                                                        : totalPrice),
                                                    orderModel: orderModel,
                                                    inputPinTextController:
                                                        inputPinTextController,
                                                  ),
                                                );
                                              });
                                        }
                                      },

                                      ///Put label over here
                                      label: Text(
                                        getTranslated(
                                            'swip_to_confirm_order', context),
                                        style: rubikRegular.copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      dismissThresholds: 0.5,
                                      dismissible: false,
                                      icon: const Center(
                                          child: Icon(
                                        Icons.double_arrow_sharp,
                                        color: Colors.white,
                                        size: Dimensions.paddingSizeLarge,
                                        semanticLabel:
                                            'Text to announce in accessibility modes',
                                      )),

                                      ///Change All the color and size from here.
                                      radius: 10,
                                      boxShadow:
                                          const BoxShadow(blurRadius: 0.0),
                                      buttonColor:
                                          Theme.of(context).primaryColor,
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                      baseColor: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }

  Widget otpDialog(BuildContext context, String token, OrderProvider order) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(Images.icOtp, height: 70,),
        SizedBox(height: 20,),
        const Text("Take OTP from customer for verification"),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 35),
          child: PinCodeTextField(
            controller: inputPinTextController,
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
            onChanged: (query) {
              // if (query.length == 6) {}
              inputPinTextController!.text = query;
              setState(() {});
            },
            beforeTextPaste: (text) {
              return true;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomButtonWidget(
              btnTxt: "Verify",
              isLoading: order.isLoading!,
              onTap: () {
                if (inputPinTextController.text.length == 6) {
                  isLoading = true;

                  Provider.of<TrackerProvider>(context, listen: false).stopLocationService();
                  Provider.of<OrderProvider>(context, listen: false)
                      .updateOrderStatus(
                          token: token,
                          orderId: orderModel?.id,
                          status: 'delivered',
                          otp: inputPinTextController!.text).then((value){
                    if (value.isSuccess) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) =>
                              OrderDeliveredScreen(
                                  orderID: orderModel?.id.toString())));
                    }else{
                      inputPinTextController!.text = "";
                      setState(() {});
                    }
                  });

                  setState(() {});
                }else{
                  Fluttertoast.showToast(msg: "Enter OTP");
                }
              }),
        )
      ],
    );
  }

  String _getVariationValue(Map<String, dynamic>? orderVariation) {
    String variation = '';

    orderVariation?.forEach((key, value) {
      variation = '$variation ${variation.isEmpty ? '' : '-'} $value';
    });

    return variation;
  }
}
