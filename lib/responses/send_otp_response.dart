class SendOtpResponse {
  bool? status;
  String? message;
  dynamic data;
  dynamic request;

  SendOtpResponse({this.status, this.message, this.data, this.request});

  SendOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
   // request = json['request'];
  }

}

class Request {
  String? phone;
  String? countryCode;
  String? email;
  String? userType;

  Request({this.phone, this.countryCode, this.email, this.userType});

  Request.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    countryCode = json['country_code'];
    email = json['email'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    return data;
  }
}