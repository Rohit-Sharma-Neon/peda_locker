class ParkingSpotsListResponse {
  bool? status;
  String? message;
  List<Data>? data;

  ParkingSpotsListResponse({this.status, this.message, this.data});

  ParkingSpotsListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? mark_parking_spot_as_featured;
  String? arName;
  String? location;
  var container_id;
  String? lat;
  String? log;
  int? containerCount;
  int? totalSpace;
  String? parkingOwnerName;
  String? arParkingOwnerName;
  var total_rate;
  String? parkingOwnerEmail;
  int? revenueId;
  String? markParkingSpotAsFeatured;
  String? isStatus;
  var avg_rate;
  String? createdAt;
  String? updatedAt;
  String? distance;

  Data(
      {this.id,
      this.name,
      this.arName,
      this.mark_parking_spot_as_featured,
      this.location,
      this.lat,
      this.log,
        this.containerCount,
        this.totalSpace,
      this.parkingOwnerName,
      this.arParkingOwnerName,
      this.parkingOwnerEmail,
      this.avg_rate,
      this.revenueId,
      this.markParkingSpotAsFeatured,
      this.isStatus,
      this.total_rate,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avg_rate = json['avg_rate'];
    total_rate = json['total_rate'];
    distance = json['distance'];
    container_id = json['container_id'];
    arName = json['ar_name'];
    totalSpace = json['total_space'];
    containerCount = json['container_count'];
    location = json['location'];
    mark_parking_spot_as_featured = json['mark_parking_spot_as_featured'];
    lat = json['lat'];
    log = json['log'];
    parkingOwnerName = json['parking_owner_name'];
    arParkingOwnerName = json['ar_parking_owner_name'];
    parkingOwnerEmail = json['parking_owner_email'];
    revenueId = json['revenue_id'];
    markParkingSpotAsFeatured = json['mark_parking_spot_as_featured'];
    isStatus = json['is_status'];
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
    data['mark_parking_spot_as_featured'] = this.markParkingSpotAsFeatured;
    data['is_status'] = this.isStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
