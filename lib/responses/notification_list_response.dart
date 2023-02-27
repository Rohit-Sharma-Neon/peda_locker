class NotificationListResponse {
  bool? status;
  String? message;
  List<NotificationData>? data;

  NotificationListResponse(
      {this.status, this.message, this.data});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }

  }

}

class NotificationData {
  int? id;
  int? userId;
  String? orderId;
  String? title;
  String? message;
  var arTitle;
  var arMessage;
  String? isStatus;
  var image;
  var hyperlink;
  var preferenceId;
  var preferenceName;
  String? btnType;
  String? type;
  String? createdAt;
  String? updatedAt;
  OrderInfo? orderInfo;

  NotificationData(
      {this.id,
        this.userId,
        this.orderId,
        this.title,
        this.message,
        this.arTitle,
        this.arMessage,
        this.isStatus,
        this.image,
        this.hyperlink,
        this.preferenceId,
        this.preferenceName,
        this.btnType,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.orderInfo});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    title = json['title'];
    message = json['message'];
    arTitle = json['ar_title'];
    arMessage = json['ar_message'];
    isStatus = json['is_status'];
    image = json['image'];
    hyperlink = json['hyperlink'];
    preferenceId = json['preference_id'];
    preferenceName = json['preference_name'];
    btnType = json['btnType'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderInfo = json['order_info'] != null
        ? new OrderInfo.fromJson(json['order_info'])
        : null;
  }


}

class OrderInfo {
  int? id;
  String? orderId;
  var serviceId;
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
  var rating;
  var review;
  String? totalAmount;
  var overStayCharges;
  var cancellationCharges;
  var couponId;
  var refundAmount;
  String? lockerNo;
  var previousOrderId;
  String? createdAt;
  String? updatedAt;

  OrderInfo(
      {this.id,
        this.orderId,
        this.serviceId,
        this.userId,
        this.parkingSpotId,
        this.containerId,
        this.addBikeId,
        this.checkInDate,
        this.checkIn,
        this.checkOutDate,
        this.checkOut,
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
        this.previousOrderId,
        this.createdAt,
        this.updatedAt});

  OrderInfo.fromJson(Map<String, dynamic> json) {
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
    rating = json['rating'];
    review = json['review'];
    totalAmount = json['total_amount'];
    overStayCharges = json['over_stay_charges'];
    cancellationCharges = json['cancellation_charges'];
    couponId = json['coupon_id'];
    refundAmount = json['refund_amount'];
    lockerNo = json['locker_no'];
    previousOrderId = json['previousOrderId'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }


}
