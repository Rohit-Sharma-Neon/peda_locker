class CreateOrderResponse {
  bool? status;
  String? message;
  // Data? data;
  // Request? request;

  CreateOrderResponse({this.status, this.message});

  CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    // request =
    // json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

}

class Data {
  int? id;
  String? orderId;
  String? serviceId;
  int? userId;
  var parkingSpotId;
  String? containerId;
  String? addBikeId;
  String? checkInDate;
  String? checkOutDate;
  String? orderStatus;
  String? transactionId;
  String? rating;
  String? review;
  String? totalAmount;
  String? overStayCharges;
  String? cancellationCharges;
  String? couponId;
  String? refundAmount;
  var lockerNo;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.orderId,
        this.serviceId,
        this.userId,
        this.parkingSpotId,
        this.containerId,
        this.addBikeId,
        this.checkInDate,
        this.checkOutDate,
        this.orderStatus,
        this.transactionId,
        this.rating,
        this.review,
        this.totalAmount,
        this.overStayCharges,
        this.cancellationCharges,
        this.couponId,
        this.refundAmount,
        this.lockerNo,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    serviceId = json['service_id'];
    userId = json['user_id'];
    parkingSpotId = json['parking_spot_id'];
    containerId = json['container_id'];
    addBikeId = json['add_bike_id'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    orderStatus = json['order_status'];
    transactionId = json['transaction_id'];
    rating = json['rating'];
    review = json['review'];
    totalAmount = json['total_amount'];
    overStayCharges = json['over_stay_charges'];
    cancellationCharges = json['cancellation_charges'];
    couponId = json['coupon_id'];
    refundAmount = json['refund_amount'];
    lockerNo = json['locker_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['service_id'] = this.serviceId;
    data['user_id'] = this.userId;
    data['parking_spot_id'] = this.parkingSpotId;
    data['container_id'] = this.containerId;
    data['add_bike_id'] = this.addBikeId;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['order_status'] = this.orderStatus;
    data['transaction_id'] = this.transactionId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['total_amount'] = this.totalAmount;
    data['over_stay_charges'] = this.overStayCharges;
    data['cancellation_charges'] = this.cancellationCharges;
    data['coupon_id'] = this.couponId;
    data['refund_amount'] = this.refundAmount;
    data['locker_no'] = this.lockerNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Request {
  String? parkingSpotId;
  String? bikeId;
  String? checkInDate;
  String? checkOutDate;
  String? transactionId;
  String? totalAmount;
  String? orderId;

  Request(
      {this.parkingSpotId,
        this.bikeId,
        this.checkInDate,
        this.checkOutDate,
        this.transactionId,
        this.totalAmount,
        this.orderId});

  Request.fromJson(Map<String, dynamic> json) {
    parkingSpotId = json['parking_spot_id'];
    bikeId = json['bike_id'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    transactionId = json['transaction_id'];
    totalAmount = json['total_amount'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parking_spot_id'] = this.parkingSpotId;
    data['bike_id'] = this.bikeId;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['transaction_id'] = this.transactionId;
    data['total_amount'] = this.totalAmount;
    data['order_id'] = this.orderId;
    return data;
  }
}
