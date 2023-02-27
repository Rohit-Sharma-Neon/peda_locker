class CouponListResponse {
  bool? status;
  String? message;
  List<Coupon>? data;

  CouponListResponse({this.status, this.message, this.data});

  CouponListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Coupon>[];
      json['data'].forEach((v) {
        data!.add(new Coupon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Coupon {
  int? id;
  String? name;
  String? arName;
  String? discount;
  String? descriptions;
  String? date;
  String? endDate;
  String? userType;
  String? bikeType;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  Coupon(
      {this.id,
      this.name,
      this.arName,
      this.descriptions,
      this.discount,
      this.date,
      this.endDate,
      this.userType,
      this.bikeType,
      this.isStatus,
      this.createdAt,
      this.updatedAt});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    discount = json['discount'];
    date = json['date'];
    endDate = json['end_date'];
    descriptions = json['descriptions'];
    userType = json['user_type'];
    bikeType = json['bike_type'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
