class UserModel {
  int? id;
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? gender;
  bool? isActive;
  String? birthday;
  String? createdAt;
  String? updatedAt;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? phoneCountryCode;
  List<UserRoleModel>? roles;

  UserModel({
    this.id,
    this.fName,
    this.lName,
    this.gender,
    this.email,
    this.phone,
    this.roles,
    this.isActive,
    this.birthday,
    this.createdAt,
    this.updatedAt,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneCountryCode = json['phone_country_code'];
    fName = json['first_name'];
    lName = json['last_name'];
    gender = json['gender'];
    isActive = json['is_active'];
    email = json['email'];
    phone = json['phone'];
    birthday = json['birthday'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['roles'] != null) {
      roles = <UserRoleModel>[];
      json['roles'].forEach((v) => roles!.add(UserRoleModel.fromJson(v)));
    }
  }
}

class UserRoleModel {
  int? id;
  String? name;
  String? guardName;
  String? createdAt;
  String? updatedAt;

  UserRoleModel({
    this.id,
    this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
  });

  UserRoleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
