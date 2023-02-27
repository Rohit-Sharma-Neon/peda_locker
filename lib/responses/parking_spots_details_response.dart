class ParkingSpotsDetailsResponse {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  ParkingSpotsDetailsResponse(
      {this.status, this.message, this.data, this.request});

  ParkingSpotsDetailsResponse.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  String? updatedAt;
  var avgRate;
  int? bikeCount;
  int? totalRate;
  int? containerCount;
  int? totalSpace;
  List<Amenity>? amenity;
  List<BannerBottom>? banner;
  String? distance;

  Data(
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
        this.createdAt,
        this.updatedAt,
        this.avgRate,
        this.bikeCount,
        this.totalRate,
        this.containerCount,
        this.totalSpace,
        this.amenity,
        this.banner,
        this.distance});

  Data.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    avgRate = json['avg_rate'];
    bikeCount = json['bike_count'];
    totalRate = json['total_rate'];
    containerCount = json['container_count'];
    totalSpace = json['total_space'];
    if (json['amenity'] != null) {
      amenity = <Amenity>[];
      json['amenity'].forEach((v) {
        amenity!.add(Amenity.fromJson(v));
      });
    }
    if (json['banner'] != null) {
      banner = <BannerBottom>[];
      json['banner'].forEach((v) {
        banner!.add(BannerBottom.fromJson(v));
      });
    }
    distance = json['distance'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['avg_rate'] = this.avgRate;
    data['bike_count'] = this.bikeCount;
    data['total_rate'] = this.totalRate;
    data['container_count'] = this.containerCount;
    data['total_space'] = this.totalSpace;
    if (this.amenity != null) {
      data['amenity'] = this.amenity!.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;
    return data;
  }
}

class Amenity {
  int? id;
  String? name;
  String? arName;
  String? logo;
  String? createdAt;
  String? updatedAt;
  String? containerParkingSportType;
  String? imageUrl;

  Amenity(
      {this.id,
        this.name,
        this.arName,
        this.logo,
        this.createdAt,
        this.updatedAt,
        this.containerParkingSportType,
        this.imageUrl});

  Amenity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    logo = json['logo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    containerParkingSportType = json['container_parking_sport_type'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ar_name'] = this.arName;
    data['logo'] = this.logo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['container_parking_sport_type'] = this.containerParkingSportType;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class BannerBottom {
  int? id;
  String? name;
  String? arName;
  String? image;
  String? url;

  BannerBottom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    image = json['image'];
  }
}

class Request {
  String? parkingSportId;
  String? lat;
  String? lang;

  Request({this.parkingSportId, this.lat, this.lang});

  Request.fromJson(Map<String, dynamic> json) {
    parkingSportId = json['parking_sport_id'];
    lat = json['lat'];
    lang = json['lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parking_sport_id'] = this.parkingSportId;
    data['lat'] = this.lat;
    data['lang'] = this.lang;
    return data;
  }
}
