class CancelModal {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  CancelModal({this.status, this.message, this.data, this.request});

  CancelModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
    request =
    json['request'] != null ?  Request.fromJson(json['request']) : null;
  }


}

class Data {
  int? id;
  String? orderId;
  dynamic serviceId;
  int? userId;
  int? parkingSpotId;
  String? containerId;
  String? addBikeId;
  String? checkInDate;
  String? checkIn;
  String? checkOutDate;
  String? checkOut;
  String? orderStatus;
  String? transactionId;
  String? cartId;
  dynamic rating;
  dynamic review;
  String? totalAmount;
  dynamic overStayCharges;
  dynamic cancellationCharges;
  dynamic couponId;
  dynamic refundAmount;
  String? lockerNo;
  dynamic previousOrderId;
  dynamic isAssginLock;
  String? createdAt;
  String? updatedAt;



  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    serviceId = json['service_id'];
    userId = json['user_id'];
    parkingSpotId = json['parking_spot_id'];
    containerId = json['container_id'];
    addBikeId = json['add_bike_id'];
    checkInDate = json['check_in_date'];
    checkIn = json['check_in'];
    checkOutDate = json['check_out_date'];
    checkOut = json['check_out'];
    orderStatus = json['order_status'];
    transactionId = json['transaction_id'];
    cartId = json['cartId'];
    rating = json['rating'];
    review = json['review'];
    totalAmount = json['total_amount'];
    overStayCharges = json['over_stay_charges'];
    cancellationCharges = json['cancellation_charges'];
    couponId = json['coupon_id'];
    refundAmount = json['refund_amount'];
    lockerNo = json['locker_no'];
    previousOrderId = json['previousOrderId'];
    isAssginLock = json['is_assgin_lock'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }


}

class Request {
  String? orderId;

  Request({this.orderId});

  Request.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['order_id'] = this.orderId;
    return data;
  }
}