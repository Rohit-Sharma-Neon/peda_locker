class VerifyOtpResponse {
  bool? status;
  String? message;
  dynamic data;
  dynamic request;

  VerifyOtpResponse({this.status, this.message, this.data, this.request});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    request = json['request'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  String? name;
  String? email;
  String? countryCode;
  String? phone;
  String? deviceType;
  String? deviceToken;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? accessToken;

  Data(
      {this.name,
        this.email,
        this.countryCode,
        this.phone,
        this.deviceType,
        this.deviceToken,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.accessToken});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['access_token'] = this.accessToken;
    return data;
  }
}

class Request {
  String? password;
  String? name;
  String? deviceToken;
  String? deviceType;
  String? phone;
  String? countryCode;
  String? email;
  String? otp;
  String? userType;
  String? preferenceId;

  Request(
      {this.password,
        this.name,
        this.deviceToken,
        this.deviceType,
        this.phone,
        this.countryCode,
        this.email,
        this.otp,
        this.userType,
        this.preferenceId});

  Request.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    name = json['name'];
    deviceToken = json['device_token'];
    deviceType = json['device_type'];
    phone = json['phone'];
    countryCode = json['country_code'];
    email = json['email'];
    otp = json['otp'];
    userType = json['user_type'];
    preferenceId = json['preference_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['name'] = this.name;
    data['device_token'] = this.deviceToken;
    data['device_type'] = this.deviceType;
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    data['email'] = this.email;
    data['otp'] = this.otp;
    data['user_type'] = this.userType;
    data['preference_id'] = this.preferenceId;
    return data;
  }
}