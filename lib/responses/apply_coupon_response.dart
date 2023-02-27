class ApplyCouponResponse {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  ApplyCouponResponse({this.status, this.message, this.data, this.request});

  ApplyCouponResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
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
  int? id;

  Data({this.id});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Request {
  String? checkOutDate;
  String? orderId;
  String? name;
  String? couponId;

  Request({this.checkOutDate, this.orderId, this.name, this.couponId});

  Request.fromJson(Map<String, dynamic> json) {
    checkOutDate = json['check_out_date'];
    orderId = json['order_id'];
    name = json['name'];
    couponId = json['coupon_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['check_out_date'] = this.checkOutDate;
    data['order_id'] = this.orderId;
    data['name'] = this.name;
    data['coupon_id'] = this.couponId;
    return data;
  }
}
