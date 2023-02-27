class LogoutResponse {
  bool? status;
  String? message;
  dynamic data;
  dynamic request;

  LogoutResponse({this.status, this.message, this.data, this.request});

  LogoutResponse.fromJson(Map<String, dynamic> json) {
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
