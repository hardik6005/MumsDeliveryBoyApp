class UserInfoModel {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? identityNumber;
  String? identityType;
  String? identityImage;
  String? image;
  String? password;
  String? createdAt;
  String? updatedAt;
  String? authToken;

  UserInfoModel(
      {this.id,
        this.fName,
        this.lName,
        this.phone,
        this.email,
        this.identityNumber,
        this.identityType,
        this.identityImage,
        this.image,
        this.password,
        this.createdAt,
        this.updatedAt,
        this.authToken});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    identityNumber = json['identity_number'];
    identityType = json['identity_type'];
    identityImage = json['identity_image'];
    image = json['image'];
    password = json['password'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    authToken = json['auth_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['identity_number'] = identityNumber;
    data['identity_type'] = identityType;
    data['identity_image'] = identityImage;
    data['image'] = image;
    data['password'] = password;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['auth_token'] = authToken;
    return data;
  }
}
