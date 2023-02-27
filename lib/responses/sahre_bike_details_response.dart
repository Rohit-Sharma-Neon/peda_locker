class ShareBikeDetailsResponse {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  ShareBikeDetailsResponse(
      {this.status, this.message, this.data, this.request});

  ShareBikeDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? shareBikeId;
  int? parkingSpotId;
  String? orderId;
  int? bikeId;
  String? shareType;
  var startDateTime;
  var endDateTime;
  String? countryCode;
  String? phone;
  String? name;
  String? shareStatus;
  String? lockerNo;
  String? createdAt;
  String? updatedAt;
  String? bikeName;
  String? bikeImage;
  String? imageUrl;
  List<BikeAccessories>? bikeAccessories;
  List<BikeParts>? bikeParts;
  ContainerDetails? containerDetails;
  String? distance;
  String? location;
  String? isLock;

  Data(
      {this.id,
        this.userId,
        this.shareBikeId,
        this.parkingSpotId,
        this.orderId,
        this.bikeId,
        this.shareType,
        this.startDateTime,
        this.endDateTime,
        this.countryCode,
        this.phone,
        this.name,
        this.shareStatus,
        this.lockerNo,
        this.createdAt,
        this.updatedAt,
        this.bikeName,
        this.bikeImage,
        this.imageUrl,
        this.bikeAccessories,
        this.bikeParts,
        this.containerDetails,
        this.distance,
        this.location,
        this.isLock});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shareBikeId = json['share_bike_id'];
    parkingSpotId = json['parking_spot_id'];
    orderId = json['order_id'];
    bikeId = json['bike_id'];
    shareType = json['share_type'];
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    countryCode = json['country_code'];
    phone = json['phone'];
    name = json['name'];
    shareStatus = json['share_status'];
    lockerNo = json['locker_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bikeName = json['bike_name'];
    bikeImage = json['bike_image'];
    imageUrl = json['image_url'];
    if (json['bike_accessories'] != null) {
      bikeAccessories = <BikeAccessories>[];
      json['bike_accessories'].forEach((v) {
        bikeAccessories!.add(new BikeAccessories.fromJson(v));
      });
    }
    if (json['bike_parts'] != null) {
      bikeParts = <BikeParts>[];
      json['bike_parts'].forEach((v) {
        bikeParts!.add(new BikeParts.fromJson(v));
      });
    }
    containerDetails = json['container_details'] != null
        ? new ContainerDetails.fromJson(json['container_details'])
        : null;
    distance = json['distance'];
    location = json['location'];
    isLock = json['is_lock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['share_bike_id'] = this.shareBikeId;
    data['parking_spot_id'] = this.parkingSpotId;
    data['order_id'] = this.orderId;
    data['bike_id'] = this.bikeId;
    data['share_type'] = this.shareType;
    data['start_date_time'] = this.startDateTime;
    data['end_date_time'] = this.endDateTime;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['share_status'] = this.shareStatus;
    data['locker_no'] = this.lockerNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['bike_name'] = this.bikeName;
    data['bike_image'] = this.bikeImage;
    data['image_url'] = this.imageUrl;
    if (this.bikeAccessories != null) {
      data['bike_accessories'] =
          this.bikeAccessories!.map((v) => v.toJson()).toList();
    }
    if (this.bikeParts != null) {
      data['bike_parts'] = this.bikeParts!.map((v) => v.toJson()).toList();
    }
    if (this.containerDetails != null) {
      data['container_details'] = this.containerDetails!.toJson();
    }
    data['distance'] = this.distance;
    data['location'] = this.location;
    data['is_lock'] = this.isLock;
    return data;
  }
}

class BikeAccessories {
  int? id;
  String? name;
  String? arName;
  var image;
  String? createdAt;
  String? updatedAt;

  BikeAccessories(
      {this.id,
        this.name,
        this.arName,
        this.image,
        this.createdAt,
        this.updatedAt});

  BikeAccessories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ar_name'] = this.arName;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class BikeParts {
  int? id;
  String? name;
  String? arName;
  String? image;
  String? createdAt;
  String? updatedAt;

  BikeParts(
      {this.id,
        this.name,
        this.arName,
        this.image,
        this.createdAt,
        this.updatedAt});

  BikeParts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ar_name'] = this.arName;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ContainerDetails {
  int? id;
  String? containerId;
  String? containerNo;
  int? parkingSpotId;
  var amenitiesId;
  var name;
  var arName;
  var location;
  var lat;
  var log;
  String? parkingOwnerName;
  String? arParkingOwnerName;
  String? parkingOwnerEmail;
  int? revenueId;
  int? markParkingSpotAsFeatured;
  String? descriptions;
  int? containerRaw;
  int? containerColumn;
  String? isStatus;
  var containerPrice;
  String? yearlyPrice;
  String? monthlyPrice;
  String? weeklyPrice;
  String? dailyPrice;
  String? size;
  String? width;
  String? priceAddOneSixHr;
  String? priceAddSevenTwentyforHr;
  String? createdAt;
  String? updatedAt;

  ContainerDetails(
      {this.id,
        this.containerId,
        this.containerNo,
        this.parkingSpotId,
        this.amenitiesId,
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
        this.descriptions,
        this.containerRaw,
        this.containerColumn,
        this.isStatus,
        this.containerPrice,
        this.yearlyPrice,
        this.monthlyPrice,
        this.weeklyPrice,
        this.dailyPrice,
        this.size,
        this.width,
        this.priceAddOneSixHr,
        this.priceAddSevenTwentyforHr,
        this.createdAt,
        this.updatedAt});

  ContainerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    containerId = json['container_id'];
    containerNo = json['container_no'];
    parkingSpotId = json['parking_spot_id'];
    amenitiesId = json['amenities_id'];
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
    descriptions = json['descriptions'];
    containerRaw = json['container_raw'];
    containerColumn = json['container_column'];
    isStatus = json['is_status'];
    containerPrice = json['container_price'];
    yearlyPrice = json['Yearly_price'];
    monthlyPrice = json['Monthly_price'];
    weeklyPrice = json['Weekly_price'];
    dailyPrice = json['Daily_price'];
    size = json['size'];
    width = json['width'];
    priceAddOneSixHr = json['price_add_one_six_hr'];
    priceAddSevenTwentyforHr = json['price_add_seven_twentyfor_hr'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['container_id'] = this.containerId;
    data['container_no'] = this.containerNo;
    data['parking_spot_id'] = this.parkingSpotId;
    data['amenities_id'] = this.amenitiesId;
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
    data['descriptions'] = this.descriptions;
    data['container_raw'] = this.containerRaw;
    data['container_column'] = this.containerColumn;
    data['is_status'] = this.isStatus;
    data['container_price'] = this.containerPrice;
    data['Yearly_price'] = this.yearlyPrice;
    data['Monthly_price'] = this.monthlyPrice;
    data['Weekly_price'] = this.weeklyPrice;
    data['Daily_price'] = this.dailyPrice;
    data['size'] = this.size;
    data['width'] = this.width;
    data['price_add_one_six_hr'] = this.priceAddOneSixHr;
    data['price_add_seven_twentyfor_hr'] = this.priceAddSevenTwentyforHr;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Request {
  String? shareId;
  String? lang;
  String? lat;

  Request({this.shareId, this.lang, this.lat});

  Request.fromJson(Map<String, dynamic> json) {
    shareId = json['shareId'];
    lang = json['lang'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shareId'] = this.shareId;
    data['lang'] = this.lang;
    data['lat'] = this.lat;
    return data;
  }
}
