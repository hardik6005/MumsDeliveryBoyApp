import 'package:flutter/material.dart';

class OrderDetailsModel {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  ProductDetails? _productDetails;
  List<Variation>? _variation;
  double? _discountOnProduct;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;
  String? _variant;
  bool? _isVatInclude;
  Map<String, dynamic>? _formattedVariation;


  OrderDetailsModel(
      {int? id,
        int? productId,
        int? orderId,
        double? price,
        ProductDetails? productDetails,
        List<Variation>? variation,
        double? discountOnProduct,
        String? discountType,
        int? quantity,
        double? taxAmount,
        String? createdAt,
        String? updatedAt,
        String? variant,
        bool? isVatInclude,
        Map<String, dynamic>? formattedVariation,

      }) {
    _id = id;
    _productId = productId;
    _orderId = orderId;
    _price = price;
    _productDetails = productDetails;
    _variation = variation;
    _discountOnProduct = discountOnProduct;
    _discountType = discountType;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _variant = variant;
    _isVatInclude = isVatInclude;
    _formattedVariation = formattedVariation;
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  ProductDetails? get productDetails => _productDetails;
  List<Variation>? get variation => _variation;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get variant => _variant;
  bool? get isVatInclude => _isVatInclude;
  Map<String, dynamic>? get modifiedVariation => _formattedVariation;

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    _productDetails = json['product_details'] != null
        ? ProductDetails.fromJson(json['product_details'])
        : null;
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation!.add(Variation.fromJson(v));
      });
    }
    _discountOnProduct = json['discount_on_product'].toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _variant = json['variant'];
    _isVatInclude = '${json['vat_status']}' == 'included';
    _formattedVariation = json['formatted_variation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['order_id'] = _orderId;
    data['price'] = _price;
    if (_productDetails != null) {
      data['product_details'] = _productDetails!.toJson();
    }
    if (_variation != null) {
      data['variation'] = _variation!.map((v) => v.toJson()).toList();
    }
    data['discount_on_product'] = _discountOnProduct;
    data['discount_type'] = _discountType;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['variant'] = _variant;
    data['included'] = _isVatInclude;
    data['formatted_variation'] = _formattedVariation;
    return data;
  }
}

class ProductDetails {
  int? _id;
  String? _name;
  String? _description;
  List<String>? _image;
  double? _price;
  List<Variations>? _variations;
  double? _tax;
  String? _availableTimeStarts;
  String? _availableTimeEnds;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  List<String>? _attributes;
  List<CategoryIds>? _categoryIds;
  List<ChoiceOptions>? _choiceOptions;
  double? _discount;
  String? _discountType;
  String? _taxType;

  ProductDetails(
      {int? id,
        String? name,
        String? description,
        List<String>? image,
        double? price,
        List<Variations>? variations,
        double? tax,
        String? availableTimeStarts,
        String? availableTimeEnds,
        int? status,
        String? createdAt,
        String? updatedAt,
        List<String>? attributes,
        List<CategoryIds>? categoryIds,
        List<ChoiceOptions>? choiceOptions,
        double? discount,
        String? discountType,
        String? taxType}) {
    _id = id;
    _name = name;
    _description = description;
    _image = image;
    _price = price;
    _variations = variations;
    _tax = tax;
    _availableTimeStarts = availableTimeStarts;
    _availableTimeEnds = availableTimeEnds;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _attributes = attributes;
    _categoryIds = categoryIds;
    _choiceOptions = choiceOptions;
    _discount = discount;
    _discountType = discountType;
    _taxType = taxType;
  }

  int? get id => _id;
  String? get name => _name;
  String? get description => _description;
  List<String>? get image => _image;
  double? get price => _price;
  List<Variations>? get variations => _variations;
  double? get tax => _tax;
  String? get availableTimeStarts => _availableTimeStarts;
  String? get availableTimeEnds => _availableTimeEnds;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  List<String>? get attributes => _attributes;
  List<CategoryIds>? get categoryIds => _categoryIds;
  List<ChoiceOptions>? get choiceOptions => _choiceOptions;
  double? get discount => _discount;
  String? get discountType => _discountType;
  String? get taxType => _taxType;

  ProductDetails.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _image = json['image'].cast<String>();
    _price = json['price'].toDouble();
    if (json['variations'] != null) {
      _variations = [];
      json['variations'].forEach((v) {
        _variations!.add(Variations.fromJson(v));
      });
    }
    _tax = json['tax'].toDouble();
    _availableTimeStarts = json['available_time_starts'];
    _availableTimeEnds = json['available_time_ends'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _attributes = json['attributes'].cast<String>();
    if (json['category_ids'] != null) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryIds.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions!.add(ChoiceOptions.fromJson(v));
      });
    }
    _discount = json['discount'].toDouble();
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['image'] = _image;
    data['price'] = _price;
    if (_variations != null) {
      data['variations'] = _variations!.map((v) => v.toJson()).toList();
    }
    data['tax'] = _tax;
    data['available_time_starts'] = _availableTimeStarts;
    data['available_time_ends'] = _availableTimeEnds;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['attributes'] = _attributes;
    if (_categoryIds != null) {
      data['category_ids'] = _categoryIds!.map((v) => v.toJson()).toList();
    }
    if (_choiceOptions != null) {
      data['choice_options'] =
          _choiceOptions!.map((v) => v.toJson()).toList();
    }
    data['discount'] = _discount;
    data['discount_type'] = _discountType;
    data['tax_type'] = _taxType;
    return data;
  }
}

class Variations {
  String? _type;
  double? _price;

  Variations({String? type, double? price}) {
    _type = type;
    _price = price;
  }

  String? get type => _type;
  double? get price => _price;

  Variations.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = _type;
    data['price'] = _price;
    return data;
  }
}

class CategoryIds {
  String? _id;
  int? _position;

  CategoryIds({String? id, int? position}) {
    _id = id;
    _position = position;
  }

  String? get id => _id;
  int? get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['position'] = _position;
    return data;
  }
}

class ChoiceOptions {
  String? _name;
  String? _title;
  List<String>? _options;

  ChoiceOptions({String? name, String? title, List<String>? options}) {
    _name = name;
    _title = title;
    _options = options;
  }

  String? get name => _name;
  String? get title => _title;
  List<String>? get options => _options;

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = _name;
    data['title'] = _title;
    data['options'] = _options;
    return data;
  }
}

class Variation {
  String? _type;
  double? _price;

  Variation({String? type, double? price}) {
    _type = type;
    _price = price;
  }

  String? get type => _type;
  double? get price => _price;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    try{
      _type = json.values.first;
    }catch(error){
      _type = json['type'];
      debugPrint('variation error --> $error');
    }
    if(json['price'] != null) {
      _price = json['price'].toDouble();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = _type;
    data['price'] = _price;
    return data;
  }
}
