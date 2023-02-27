class HomeDataResponse {
  bool? status;
  String? message;

  Data? data;
  Request? request;

  HomeDataResponse({this.status, this.message, this.data, this.request});

  HomeDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    request = json['request'] != null ? new Request.fromJson(json['request']) : null;
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
  List<ParkingSportData>? parkingSport;
  List<HomeOrders>? order;
  int? notificationCount;

  Data({this.parkingSport, this.order,this.notificationCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['parkingSport'] != null) {
      parkingSport = <ParkingSportData>[];
      json['parkingSport'].forEach((v) {
        parkingSport!.add(ParkingSportData.fromJson(v));
      });
    }
    if (json['order'] != null) {
      order = <HomeOrders>[];
      json['order'].forEach((v) {
        order!.add(HomeOrders.fromJson(v));
      });
    }
    notificationCount = json['notificationCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parkingSport != null) {
      data['parkingSport'] = this.parkingSport!.map((v) => v.toJson()).toList();
    }
    if (this.order != null) {
      data['order'] = this.order!.map((v) => v.toJson()).toList();
    }
    data['notificationCount'] = this.notificationCount;
    return data;
  }
}

class ParkingSportData {
  int? id;
  String? name;
  String? arName;
  String? location;
  String? lat;
  String? log;
  int? containerCount;
  int? totalSpace;
  String? parkingOwnerName;
  String? arParkingOwnerName;
  String? parkingOwnerEmail;
  int? revenueId;
  var markParkingSpotAsFeatured;
  String? isStatus;
  String? descriptions;
  String? createdAt;
  var container_id;
  String? updatedAt;
  var distance;
  var avgRate;
  var totalRate;

  ParkingSportData(
      {this.id,
      this.name,
      this.arName,
      this.location,
      this.lat,
      this.log,
      this.containerCount,
      this.container_id,
      this.totalSpace,
      this.parkingOwnerName,
      this.arParkingOwnerName,
      this.parkingOwnerEmail,
      this.revenueId,
      this.markParkingSpotAsFeatured,
      this.isStatus,
      this.descriptions,
      this.createdAt,
      this.updatedAt,
      this.distance,
      this.avgRate,
      this.totalRate});

  ParkingSportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    container_id = json['container_id'];
    arName = json['ar_name'];
    location = json['location'];
    lat = json['lat'];
    log = json['log'];
    totalSpace = json['total_space'];
    containerCount = json['container_count'];
    parkingOwnerName = json['parking_owner_name'];
    arParkingOwnerName = json['ar_parking_owner_name'];
    parkingOwnerEmail = json['parking_owner_email'];
    revenueId = json['revenue_id'];
    markParkingSpotAsFeatured = json['mark_parking_spot_as_featured'];
    isStatus = json['is_status'];
    descriptions = json['descriptions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance'];
    avgRate = json['avg_rate'];
    totalRate = json['total_rate'];
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
    data['mark_parking_spot_as_featured'] = this.markParkingSpotAsFeatured;
    data['is_status'] = this.isStatus;
    data['descriptions'] = this.descriptions;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['distance'] = this.distance;
    data['avg_rate'] = this.avgRate;
    data['total_rate'] = this.totalRate;
    return data;
  }
}

class HomeOrders {
  int? id;
  var orderId;
  var serviceId;
  int? userId;
  int? parkingSpotId;
  var containerId;
  var addBikeId;
  String? checkInDate;
  String? check_in;
  String? check_out;
  String? extend_date_time;
  var container_id;
  var is_assgin_lock;
  String? checkOutDate;
  String? orderStatus;
  var transactionId;
  String? rating;
  var review;
  var totalAmount;
  String? createdAt;
  String? updatedAt;
  BikeData? bikeData;
  ParkingSportData? parkingSport;

  HomeOrders(
      {this.id,
      this.container_id,
      this.orderId,
      this.serviceId,
      this.userId,
      this.is_assgin_lock,
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
      this.createdAt,
      this.updatedAt,
      this.bikeData,
      this.parkingSport});

  HomeOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    serviceId = json['service_id'];
    container_id = json['container_id'];
    userId = json['user_id'];
    is_assgin_lock = json['is_assgin_lock'];
    parkingSpotId = json['parking_spot_id'];
    containerId = json['container_id'];
    addBikeId = json['add_bike_id'];
    checkInDate = json['check_in_date'];
    check_in = json['check_in'];
    check_out = json['check_out'];
    extend_date_time = json['extend_date_time'];
    checkOutDate = json['check_out_date'];
    orderStatus = json['order_status'];
    transactionId = json['transaction_id'];
    rating = json['rating'];
    review = json['review'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bikeData = json['bike_data'] != null
        ? new BikeData.fromJson(json['bike_data'])
        : null;
    parkingSport = json['parking_sport'] != null
        ? new ParkingSportData.fromJson(json['parking_sport'])
        : null;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.bikeData != null) {
      data['bike_data'] = this.bikeData!.toJson();
    }
    if (this.parkingSport != null) {
      data['parking_sport'] = this.parkingSport!.toJson();
    }
    return data;
  }
}

class BikeData {
  int? id;
  var userId;
  String? bikeName;
  int? bikeTypeId;
  int? bikeSizeId;
  String? bikeValue;
  String? image;
  String? bike_image;
  String? ownerType;
  String? name;
  String? countryCode;
  String? phone;
  String? driverHeight;
  String? heightType;
  String? isStatus;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  BikeData(
      {this.id,
      this.userId,
      this.bikeName,
      this.bikeTypeId,
      this.bike_image,
      this.bikeSizeId,
      this.bikeValue,
      this.image,
      this.ownerType,
      this.name,
      this.countryCode,
      this.phone,
      this.driverHeight,
      this.heightType,
      this.isStatus,
      this.createdAt,
      this.updatedAt,
      this.imageUrl});

  BikeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bikeName = json['bike_name'];
    bike_image = json['bike_image'];
    bikeTypeId = json['bike_type_id'];
    bikeSizeId = json['bike_size_id'];
    bikeValue = json['bike_value'];
    image = json['image'];
    ownerType = json['owner_type'];
    name = json['name'];
    countryCode = json['country_code'];
    phone = json['phone'];
    driverHeight = json['driver_height'];
    heightType = json['height_type'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
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
    data['owner_type'] = this.ownerType;
    data['name'] = this.name;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['driver_height'] = this.driverHeight;
    data['height_type'] = this.heightType;
    data['is_status'] = this.isStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
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
  int? revenueId;
  String? markParkingSpotAsFeatured;
  String? isStatus;
  String? descriptions;
  String? createdAt;
  String? updatedAt;
  String? distance;

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
      this.markParkingSpotAsFeatured,
      this.isStatus,
      this.descriptions,
      this.createdAt,
      this.updatedAt,
      this.distance});

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
    markParkingSpotAsFeatured = json['mark_parking_spot_as_featured'];
    isStatus = json['is_status'];
    descriptions = json['descriptions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance'];
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
    data['mark_parking_spot_as_featured'] = this.markParkingSpotAsFeatured;
    data['is_status'] = this.isStatus;
    data['descriptions'] = this.descriptions;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['distance'] = this.distance;
    return data;
  }
}

class Request {
  String? orderId;
  String? bikeId;
  String? shareType;
  String? countryCode;
  String? phone;
  String? name;
  String? startDateTime;
  String? endDateTime;
  String? parkingSpotId;
  String? lat;
  String? lang;

  Request(
      {this.orderId,
      this.bikeId,
      this.shareType,
      this.countryCode,
      this.phone,
      this.name,
      this.startDateTime,
      this.endDateTime,
      this.parkingSpotId,
      this.lat,
      this.lang});

  Request.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    bikeId = json['bike_id'];
    shareType = json['share_type'];
    countryCode = json['country_code'];
    phone = json['phone'];
    name = json['name'];
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    parkingSpotId = json['parking_spot_id'];
    lat = json['lat'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['bike_id'] = this.bikeId;
    data['share_type'] = this.shareType;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['start_date_time'] = this.startDateTime;
    data['end_date_time'] = this.endDateTime;
    data['parking_spot_id'] = this.parkingSpotId;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    return data;
  }
}
