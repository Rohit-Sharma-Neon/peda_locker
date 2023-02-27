class LoginResponse {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  LoginResponse({this.status, this.message, this.data, this.request});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? countryCode;
  String? phone;
  String? image;
  String? dob;
  String? gender;
  String? deviceType;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  String? accessToken;

  Data(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.countryCode,
      this.phone,
      this.image,
      this.dob,
      this.gender,
      this.deviceType,
      this.deviceToken,
      this.createdAt,
      this.updatedAt,
      this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    countryCode = json['country_code'];
    phone = json['phone'];
    image = json['image'];
    dob = json['dob'];
    gender = json['gender'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['access_token'] = this.accessToken;
    return data;
  }
}

class Request {
  String? phone;
  String? countryCode;
  String? password;

  Request({this.phone, this.countryCode, this.password});

  Request.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    countryCode = json['country_code'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    data['password'] = this.password;
    return data;
  }
}
