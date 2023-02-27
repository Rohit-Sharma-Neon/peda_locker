class OrderListResponse {
  bool? status;
  String? message;
  String? cancellationCharges;
  List<OrdersData>? data;
  Request? request;

  OrderListResponse({this.status, this.message, this.data, this.request});

  OrderListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    cancellationCharges = json['cancellation_charges'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrdersData>[];
      json['data'].forEach((v) {
        data!.add(new OrdersData.fromJson(v));
      });
    }
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }


}

class OrdersData {
  int? id;
  String? orderId;
  var serviceId;
  int? userId;
  int? is_assgin_lock;
  int? parkingSpotId;
  String? containerId;
  String? addBikeId;
  String? checkInDate;
  String? checkIn;
  String? checkOutDate;
  String? extend_date_time;
  String? checkOut;
  String? orderStatus;
  String? transactionId;
  var rating;
  var review;
  String? totalAmount;
  var overStayCharges;
  String? cancellationCharges;
  var couponId;
  String? refundAmount;
  String? lockerNo;
  var previousOrderId;
  String? createdAt;
  String? updatedAt;
  List<Bike>? bike;
  String? imageUrl;
  ParkingSport? parkingSport;



  OrdersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    serviceId = json['service_id'];
    userId = json['user_id'];
    parkingSpotId = json['parking_spot_id'];
    is_assgin_lock = json['is_assgin_lock'];
    containerId = json['container_id'];
    addBikeId = json['add_bike_id'];
    checkInDate = json['check_in_date'];
    checkIn = json['check_in'];
    extend_date_time = json['extend_date_time'];
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
    if (json['bike'] != null) {
      bike = <Bike>[];
      json['bike'].forEach((v) {
        bike!.add(new Bike.fromJson(v));
      });
    }
    imageUrl = json['image_url'];
    parkingSport = json['parking_sport'] != null
        ? new ParkingSport.fromJson(json['parking_sport'])
        : null;
  }


}

class Bike {
  int? id;
  int? bikeId;
  int? is_assign;
  String? orderId;
  String? orderStatus;
  var orderAmount;
  String? containerId;
  String? lockerNo;
  String? tanNo;
  String? bikeSize;
  String? userHeight;
  String? isLock;
  String? createdAt;
  String? updatedAt;
  BikeInfo? bikeInfo;

  Bike(
      {this.id,
        this.bikeId,
        this.orderId,
        this.tanNo,
        this.orderStatus,
        this.orderAmount,
        this.containerId,
        this.is_assign,
        this.lockerNo,
        this.bikeSize,
        this.userHeight,
        this.isLock,
        this.createdAt,
        this.updatedAt,
        this.bikeInfo});

  Bike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bikeId = json['bike_id'];
    orderId = json['order_id'];
    is_assign = json['is_assign'];
    tanNo = json['tanNumber'];
    orderStatus = json['order_status'];
    orderAmount = json['order_amount'];
    containerId = json['container_id'];
    lockerNo = json['locker_no'];
    bikeSize = json['bike_size'];
    userHeight = json['user_height'];
    isLock = json['is_lock'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bikeInfo = json['bike_info'] != null
        ? new BikeInfo.fromJson(json['bike_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bike_id'] = this.bikeId;
    data['order_id'] = this.orderId;
    data['order_status'] = this.orderStatus;
    data['order_amount'] = this.orderAmount;
    data['container_id'] = this.containerId;
    data['locker_no'] = this.lockerNo;
    data['bike_size'] = this.bikeSize;
    data['user_height'] = this.userHeight;
    data['is_lock'] = this.isLock;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.bikeInfo != null) {
      data['bike_info'] = this.bikeInfo!.toJson();
    }
    return data;
  }
}

class BikeInfo {
  int? id;
  int? userId;
  String? bikeName;
  int? bikeTypeId;
  int? bikeSizeId;
  String? bikeValue;
  var image;
  String? bikeImage;
  var brandId;
  String? ownerType;
  String? name;
  var countryCode;
  String? phone;
  String? driverHeight;
  var heightType;
  var bikePartsId;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  BikeInfo(
      {this.id,
        this.userId,
        this.bikeName,
        this.bikeTypeId,
        this.bikeSizeId,
        this.bikeValue,
        this.image,
        this.bikeImage,
        this.brandId,
        this.ownerType,
        this.name,
        this.countryCode,
        this.phone,
        this.driverHeight,
        this.heightType,
        this.bikePartsId,
        this.isStatus,
        this.createdAt,
        this.updatedAt});

  BikeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bikeName = json['bike_name'];
    bikeTypeId = json['bike_type_id'];
    bikeSizeId = json['bike_size_id'];
    bikeValue = json['bike_value'];
    image = json['image'];
    bikeImage = json['bike_image'];
    brandId = json['brand_id'];
    ownerType = json['owner_type'];
    name = json['name'];
    countryCode = json['country_code'];
    phone = json['phone'];
    driverHeight = json['driver_height'];
    heightType = json['height_type'];
    bikePartsId = json['bike_parts_id'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bike_name'] = this.bikeName;
    data['bike_type_id'] = this.bikeTypeId;
    data['bike_size_id'] = this.bikeSizeId;
    data['bike_value'] = this.bikeValue;
    data['image'] = this.image;
    data['bike_image'] = this.bikeImage;
    data['brand_id'] = this.brandId;
    data['owner_type'] = this.ownerType;
    data['name'] = this.name;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['driver_height'] = this.driverHeight;
    data['height_type'] = this.heightType;
    data['bike_parts_id'] = this.bikePartsId;
    data['is_status'] = this.isStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ParkingSport {
  int? id;
  String? name;
  String? arName;
  String? location;
  String? lat;
  String? log;
  String? parkingOwnerName;
  String? arParkingOwnerName;
  String? parkingOwnerEmail;
  var revenueId;
  String? revenueVal;
  var revenueIdPerBookingEnterPercentage;
  var revenueIdCombinationOfBoth;
  String? revenueIdPerBookingEnterPercentageVal;
  String? markParkingSpotAsFeatured;
  String? isStatus;
  String? descriptions;
  String? parkingSportType;
  String? createdAt;
  String? updatedAt;

  ParkingSport(
      {this.id,
        this.name,
        this.arName,
        this.location,
        this.lat,
        this.log,
        this.parkingOwnerName,
        this.arParkingOwnerName,
        this.parkingOwnerEmail,
        this.revenueId,
        this.revenueVal,
        this.revenueIdPerBookingEnterPercentage,
        this.revenueIdCombinationOfBoth,
        this.revenueIdPerBookingEnterPercentageVal,
        this.markParkingSpotAsFeatured,
        this.isStatus,
        this.descriptions,
        this.parkingSportType,
        this.createdAt,
        this.updatedAt});

  ParkingSport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    location = json['location'];
    lat = json['lat'];
    log = json['log'];
    parkingOwnerName = json['parking_owner_name'];
    arParkingOwnerName = json['ar_parking_owner_name'];
    parkingOwnerEmail = json['parking_owner_email'];
    revenueId = json['revenue_id'];
    revenueVal = json['revenue_val'];
    revenueIdPerBookingEnterPercentage =
    json['revenue_id_per_booking_enter_percentage'];
    revenueIdCombinationOfBoth = json['revenue_id_combination_of_both'];
    revenueIdPerBookingEnterPercentageVal =
    json['revenue_id_per_booking_enter_percentage_val'];
    markParkingSpotAsFeatured = json['mark_parking_spot_as_featured'];
    isStatus = json['is_status'];
    descriptions = json['descriptions'];
    parkingSportType = json['parking_sport_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ar_name'] = this.arName;
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['log'] = this.log;
    data['parking_owner_name'] = this.parkingOwnerName;
    data['ar_parking_owner_name'] = this.arParkingOwnerName;
    data['parking_owner_email'] = this.parkingOwnerEmail;
    data['revenue_id'] = this.revenueId;
    data['revenue_val'] = this.revenueVal;
    data['revenue_id_per_booking_enter_percentage'] =
        this.revenueIdPerBookingEnterPercentage;
    data['revenue_id_combination_of_both'] = this.revenueIdCombinationOfBoth;
    data['revenue_id_per_booking_enter_percentage_val'] =
        this.revenueIdPerBookingEnterPercentageVal;
    data['mark_parking_spot_as_featured'] = this.markParkingSpotAsFeatured;
    data['is_status'] = this.isStatus;
    data['descriptions'] = this.descriptions;
    data['parking_sport_type'] = this.parkingSportType;
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
  String? type;

  Request(
      {this.parkingSpotId,
        this.bikeId,
        this.checkInDate,
        this.checkOutDate,
        this.type});

  Request.fromJson(Map<String, dynamic> json) {
    parkingSpotId = json['parking_spot_id'];
    bikeId = json['bike_id'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parking_spot_id'] = this.parkingSpotId;
    data['bike_id'] = this.bikeId;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['type'] = this.type;
    return data;
  }
}
