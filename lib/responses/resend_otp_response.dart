class ResendOtpResponse {
  bool? status;
  String? message;
  dynamic data;
  dynamic request;

  ResendOtpResponse({this.status, this.message, this.data, this.request});

  ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    request = json['request'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data;
    data['request'] = this.request;
    return data;
  }
}

class Request {
  String? phone;
  String? countryCode;
  String? userType;

  Request({this.phone, this.countryCode, this.userType});

  Request.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    countryCode = json['country_code'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    data['user_type'] = this.userType;
    return data;
  }
}