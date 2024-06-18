import 'dart:async';

import 'package:flutter/material.dart';
import 'package:grocery_delivery_boy/common/models/api_response_model.dart';
import 'package:grocery_delivery_boy/common/models/response_model.dart';
import 'package:grocery_delivery_boy/features/order/domain/models/order_details_model.dart';
import 'package:grocery_delivery_boy/common/models/order_model.dart';
import 'package:grocery_delivery_boy/features/order/domain/models/timeslot_model.dart';
import 'package:grocery_delivery_boy/features/order/domain/reposotories/order_repo.dart';
import 'package:grocery_delivery_boy/helper/api_checker_helper.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepo orderRepo;

  OrderProvider({required this.orderRepo});

  List<OrderModel>? _currentOrders;
  List<OrderModel>? _currentOrdersReverse;
  List<TimeSlotModel>? _timeSlots;
  OrderModel? _currentOrderModel;
  bool _isLoading = false;
  List<OrderDetailsModel>? _orderDetails;
  List<OrderModel>? _allOrderHistory;
  late List<OrderModel> _allOrderReverse;

  List<OrderModel>? get currentOrders => _currentOrders;
  List<TimeSlotModel>? get timeSlots => _timeSlots;
  OrderModel? get currentOrderModel => _currentOrderModel;
  bool get isLoading => _isLoading;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;
  List<OrderModel>? get allOrderHistory => _allOrderHistory;


  Future getAllOrders() async {
    ApiResponseModel apiResponse = await orderRepo.getAllOrders();
    if (apiResponse.response?.statusCode == 200) {
      _currentOrders = [];
      _currentOrdersReverse = [];

      apiResponse.response?.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if(orderModel.orderStatus == 'processing' || orderModel.orderStatus == 'out_for_delivery') {
          _currentOrdersReverse?.add(orderModel);
        }
      });

      _currentOrders = List.from(_currentOrdersReverse!.reversed);

    } else {
      ApiCheckerHelper.checkApi(apiResponse);

    }
    notifyListeners();
  }



  Future<List<OrderDetailsModel>?> getOrderDetails(String orderID) async {
    _orderDetails = null;

    ApiResponseModel apiResponse = await orderRepo.getOrderDetails(orderID: orderID);

    if (apiResponse.response?.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach((orderDetail) => _orderDetails?.add(OrderDetailsModel.fromJson(orderDetail)));

    } else {
      ApiCheckerHelper.checkApi( apiResponse);

    }

    notifyListeners();

    return _orderDetails;
  }


  Future<List<OrderModel>?> getOrderHistory(BuildContext context) async {
    ApiResponseModel apiResponse = await orderRepo.getAllOrderHistory();
    if (apiResponse.response?.statusCode == 200) {
      _allOrderHistory = [];
      _allOrderReverse = [];

      apiResponse.response!.data.forEach((orderDetail) => _allOrderReverse.add(OrderModel.fromJson(orderDetail)));

      _allOrderHistory = List.from(_allOrderReverse.reversed);

      _allOrderHistory!.removeWhere((order) => (order.orderStatus) != 'delivered');

    } else {
      ApiCheckerHelper.checkApi( apiResponse);

    }

    notifyListeners();

    return _allOrderHistory;
  }



  Future<ResponseModel> updateOrderStatus({String? token, int? orderId, String? status, String? otp}) async {
    _isLoading = true;
    notifyListeners();

    print("DSDSDSDSDSD--------");
    // await Future.delayed(Duration(seconds: 100), (){});
    ApiResponseModel apiResponse = await orderRepo.updateOrderStatus(token: token, orderId: orderId, status: status, otp: otp);

    _isLoading = false;
    notifyListeners();
    ResponseModel responseModel;

    if (apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel(true, apiResponse.response?.data['message']);
    }else {
      responseModel = ResponseModel(false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
    }

    notifyListeners();

    return responseModel;
  }

  Future updatePaymentStatus({String? token, int? orderId, String? status}) async {
    await orderRepo.updatePaymentStatus(token: token, orderId: orderId, status: status);
    notifyListeners();
  }

  Future<List<OrderModel>?> refresh(BuildContext context) async{
    getAllOrders();
    Timer(const Duration(seconds: 5), () {});
    return getOrderHistory(context);
  }


  Future<OrderModel?> getOrderModel(String orderID) async {
    _currentOrderModel = null;
    ApiResponseModel apiResponse = await orderRepo.getOrderModel(orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _currentOrderModel = OrderModel.fromJson(apiResponse.response!.data);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
    return _currentOrderModel;
  }


}
