class DeliveryManBodyModel {
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? password;
  String? identityType;
  String? identityNumber;
  String? branchId;

  DeliveryManBodyModel(
      {this.fName,
        this.lName,
        this.phone,
        this.email,
        this.password,
        this.identityType,
        this.identityNumber,
        this.branchId,
      });

  DeliveryManBodyModel.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    identityType = json['identity_type'];
    identityNumber = json['identity_number'];
    branchId = json['branch_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['f_name'] = fName ?? '';
    data['l_name'] = lName ?? '';
    data['phone'] = phone!;
    data['email'] = email!;
    data['password'] = password!;
    data['identity_type'] = identityType!;
    data['identity_number'] = identityNumber!;
    data['branch_id'] = branchId!;
    return data;
  }
}
