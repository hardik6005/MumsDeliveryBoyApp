import 'dart:convert';

class OrderModel {
  int? _id;
  int? _userId;
  double? _orderAmount;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  String? _paymentStatus;
  String? _orderStatus;
  double? _totalTaxAmount;
  String? _paymentMethod;
  String? _transactionReference;
  int? _deliveryAddressId;
  String? _createdAt;
  String? _updatedAt;
  int? _deliveryManId;
  double? _deliveryCharge;
  String? _orderNote;
  String? _couponCode;
  String? _orderType;
  int? _branchId;
  int? _timeSlotId;
  String? _date;
  String? _deliveryDate;
  DeliveryAddress? _deliveryAddress;
  Customer? _customer;
  List<OrderPartialPayment>? _orderPartialPayments;
  double? _extraDiscount;
  List<OrderImage>? _orderImageList;
  bool? _isGuestOrder;



  OrderModel(
      {int? id,
        int? userId,
        double? orderAmount,
        double? couponDiscountAmount,
        String? couponDiscountTitle,
        String? paymentStatus,
        String? orderStatus,
        double? totalTaxAmount,
        String? paymentMethod,
        String? transactionReference,
        int? deliveryAddressId,
        String? createdAt,
        String? updatedAt,
        int? deliveryManId,
        double? deliveryCharge,
        String? orderNote,
        String? couponCode,
        String? orderType,
        int? branchId,
        int? timeSlotId,
        String? date,
        String? deliveryDate,
        DeliveryAddress? deliveryAddress,
        Customer? customer,
        List<OrderPartialPayment>? orderPartialPayments,
        double? extraDiscount,
        List<OrderImage>? orderImageList,
        bool? isGuestOrder,

      }) {
    _id = id;
    _userId = userId;
    _orderAmount = orderAmount;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _paymentStatus = paymentStatus;
    _orderStatus = orderStatus;
    _totalTaxAmount = totalTaxAmount;
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    _deliveryAddressId = deliveryAddressId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deliveryManId = deliveryManId;
    _deliveryCharge = deliveryCharge;
    _orderNote = orderNote;
    _couponCode = couponCode;
    _orderType = orderType;
    _branchId = branchId;
    _timeSlotId = timeSlotId;
    _date = date;
    _deliveryDate = deliveryDate;
    _deliveryAddress = deliveryAddress;
    _customer = customer;
    _orderPartialPayments = orderPartialPayments;
    _extraDiscount = extraDiscount;
    _orderImageList = orderImageList;
    _isGuestOrder = isGuestOrder;

  }

  int? get id => _id;
  int? get userId => _userId;
  double? get orderAmount => _orderAmount;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  String? get paymentStatus => _paymentStatus;
  // ignore: unnecessary_getters_setters
  String? get orderStatus => _orderStatus;
  set orderStatus(String? status) => _orderStatus = status;
  double? get totalTaxAmount => _totalTaxAmount;
  String? get paymentMethod => _paymentMethod;
  String? get transactionReference => _transactionReference;
  int? get deliveryAddressId => _deliveryAddressId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get deliveryManId => _deliveryManId;
  double? get deliveryCharge => _deliveryCharge;
  String? get orderNote => _orderNote;
  String? get couponCode => _couponCode;
  String? get orderType => _orderType;
  int? get branchId => _branchId;
  int? get timeSlotId => _timeSlotId;
  String? get date => _date;
  String? get deliveryDate => _deliveryDate;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;
  Customer? get customer => _customer;
  List<OrderPartialPayment>? get orderPartialPayments => _orderPartialPayments;
  double? get extraDiscount => _extraDiscount;
  List<OrderImage>? get orderImageList => _orderImageList;
  bool? get isGuestOrder => _isGuestOrder;


  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _orderAmount = json['order_amount'].toDouble();
    _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'];
    _totalTaxAmount = json['total_tax_amount'].toDouble();
    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _deliveryAddressId = json['delivery_address_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deliveryManId = json['delivery_man_id'];
    _deliveryCharge = json['delivery_charge'].toDouble();
    _orderNote = json['order_note'];
    _couponCode = json['coupon_code'];
    _orderType = json['order_type'];
    _branchId = json['branch_id'];
    _timeSlotId = json['time_slot_id'];
    _date = json['date'];
    _deliveryDate = json['delivery_date'];
    _deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    _customer = json['customer'] != null
        ? Customer.fromJson(json['customer'])
        : null;
    _orderPartialPayments = json["partial_payment"] == null ? [] : List<OrderPartialPayment>.from(json["partial_payment"]!.map((x) => OrderPartialPayment.fromMap(x)));
    _extraDiscount = double.tryParse('${json['extra_discount']}');
    _orderImageList = json["order_image"] == null ? [] : List<OrderImage>.from(json["order_image"]!.map((x) => OrderImage.fromMap(x)));
    _isGuestOrder = '${json['is_guest']}'.contains('1');


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['order_amount'] = _orderAmount;
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['payment_status'] = _paymentStatus;
    data['order_status'] = _orderStatus;
    data['total_tax_amount'] = _totalTaxAmount;
    data['payment_method'] = _paymentMethod;
    data['transaction_reference'] = _transactionReference;
    data['delivery_address_id'] = _deliveryAddressId;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['delivery_man_id'] = _deliveryManId;
    data['delivery_charge'] = _deliveryCharge;
    data['order_note'] = _orderNote;
    data['coupon_code'] = _couponCode;
    data['order_type'] = _orderType;
    data['branch_id'] = _branchId;
    data['time_slot_id'] = _timeSlotId;
    data['date'] = _date;
    data['delivery_date'] = _deliveryDate;
    if (_deliveryAddress != null) {
      data['delivery_address'] = _deliveryAddress!.toJson();
    }
    if (_customer != null) {
      data['customer'] = _customer?.toJson();
    }
    data['extra_discount'] = _extraDiscount;
    return data;
  }
}

class DeliveryAddress {
  int? _id;
  String? _addressType;
  String? _contactPersonNumber;
  String? _address;
  String? _latitude;
  String? _longitude;
  String? _createdAt;
  String? _updatedAt;
  int? _userId;
  String? _contactPersonName;

  DeliveryAddress(
      {int? id,
        String? addressType,
        String? contactPersonNumber,
        String? address,
        String? latitude,
        String? longitude,
        String? createdAt,
        String? updatedAt,
        int? userId,
        String? contactPersonName}) {
    _id = id;
    _addressType = addressType;
    _contactPersonNumber = contactPersonNumber;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _userId = userId;
    _contactPersonName = contactPersonName;
  }

  int? get id => _id;
  String? get addressType => _addressType;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get userId => _userId;
  String? get contactPersonName => _contactPersonName;

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'];
    _contactPersonNumber = json['contact_person_number'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _userId = json['user_id'];
    _contactPersonName = json['contact_person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['address_type'] = _addressType;
    data['contact_person_number'] = _contactPersonNumber;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['user_id'] = _userId;
    data['contact_person_name'] = _contactPersonName;
    return data;
  }
}

class Customer {
  int? _id;
  String? _fName;
  String? _lName;
  String? _email;
  String? _image;
  int? _isPhoneVerified;
  String? _createdAt;
  String? _updatedAt;
  String? _phone;
  String? _cmFirebaseToken;

  Customer(
      {int? id,
        String? fName,
        String? lName,
        String? email,
        String? image,
        int? isPhoneVerified,
        void emailVerifiedAt,
        String? createdAt,
        String? updatedAt,
        void emailVerificationToken,
        String? phone,
        String? cmFirebaseToken}) {
    _id = id;
    _fName = fName;
    _lName = lName;
    _email = email;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _phone = phone;
    _cmFirebaseToken = cmFirebaseToken;
  }

  int? get id => _id;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get email => _email;
  String? get image => _image;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get phone => _phone;
  String? get cmFirebaseToken => _cmFirebaseToken;

  Customer.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _email = json['email'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _phone = json['phone'];
    _cmFirebaseToken = json['cm_firebase_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['f_name'] = _fName;
    data['l_name'] = _lName;
    data['email'] = _email;
    data['image'] = _image;
    data['is_phone_verified'] = _isPhoneVerified;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['phone'] = _phone;
    data['cm_firebase_token'] = _cmFirebaseToken;
    return data;
  }
}

class OrderPartialPayment {
  int? id;
  int? orderId;
  String? paidWith;
  double? paidAmount;
  double? dueAmount;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderPartialPayment({
    this.id,
    this.orderId,
    this.paidWith,
    this.paidAmount,
    this.dueAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderPartialPayment.fromJson(String str) => OrderPartialPayment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderPartialPayment.fromMap(Map<String, dynamic> json) => OrderPartialPayment(
    id: json["id"],
    orderId: json["order_id"],
    paidWith: json["paid_with"],
    paidAmount: double.parse('${json["paid_amount"]}'),
    dueAmount: double.parse('${json["due_amount"]}'),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "order_id": orderId,
    "paid_with": paidWith,
    "paid_amount": paidAmount,
    "due_amount": dueAmount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}


class OrderImage {
  String? image;

  OrderImage({
    this.image,
  });

  factory OrderImage.fromJson(String str) => OrderImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderImage.fromMap(Map<String, dynamic> json) => OrderImage(
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "image": image,
  };
}
