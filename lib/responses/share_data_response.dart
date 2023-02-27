class ShareBikeListingResponse {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  ShareBikeListingResponse(
      {this.status, this.message, this.data, this.request});

  ShareBikeListingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
  }
}

class Data {
  List<ShareBike>? shareBike;

  Data({this.shareBike});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['share_bike'] != null) {
      shareBike = <ShareBike>[];
      json['share_bike'].forEach((v) {
        shareBike!.add(new ShareBike.fromJson(v));
      });
    }
  }
}

class ShareBike {
  int? id;
  String? orderId;
  String? locker_no;
  String? addBikeId;
  int? parkingSpotId;
  int? userId;
  Bike? bike;
  ParkingSport? parkingSport;
  List<Share>? shareBike;

  ShareBike(
      {this.id,
      this.addBikeId,
      this.locker_no,
      this.parkingSpotId,
      this.orderId,
      this.userId,
      this.bike,
      this.parkingSport,
      this.shareBike});

  ShareBike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addBikeId = json['add_bike_id'];
    locker_no = json['locker_no'];
    orderId = json['order_id'];
    parkingSpotId = json['parking_spot_id'];
    userId = json['user_id'];
    bike = json['bike'] != null ? new Bike.fromJson(json['bike']) : null;
    parkingSport = json['parking_sport'] != null
        ? new ParkingSport.fromJson(json['parking_sport'])
        : null;

    if (json['share_bike'] != null) {
      shareBike = <Share>[];
      json['share_bike'].forEach((v) {
        shareBike!.add(new Share.fromJson(v));
      });
    }
  }
}

class Bike {
  int? id;
  String? bikeName;
  String? bikeValue;
  String? image;
  String? bike_image;
  String? imageUrl;

  Bike({this.id,this.bike_image, this.bikeName, this.bikeValue, this.image, this.imageUrl});

  Bike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bike_image = json['bike_image'];
    bikeName = json['bike_name'];
    bikeValue = json['bike_value'];
    image = json['image'];
    imageUrl = json['image_url'];
  }
}

class ParkingSport {
  int? id;
  String? name;
  String? location;
  String? lat;
  String? log;
  String? parkingOwnerName;
  String? descriptions;

  ParkingSport(
      {this.id,
      this.name,
      this.location,
      this.lat,
      this.log,
      this.parkingOwnerName,
      this.descriptions});

  ParkingSport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    lat = json['lat'];
    log = json['log'];
    parkingOwnerName = json['parking_owner_name'];
    descriptions = json['descriptions'];
  }
}

class Share {
  int? id;
  String? shareType;
  String? startDateTime;
  String? endDateTime;
  String? countryCode;
  String? phone;
  String? lockerNo;
  String? name;
  String? shareStatus;

  Share(
      {this.id,
      this.shareType,
      this.startDateTime,
      this.endDateTime,
      this.countryCode,
      this.phone,
      this.name,
      this.shareStatus});

  Share.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lockerNo = json['locker_no'];
    shareType = json['share_type'];
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    countryCode = json['country_code'];
    phone = json['phone'];
    name = json['name'];
    shareStatus = json['share_status'];
  }
}

class Request {
  String? orderId;

  Request({this.orderId});

  Request.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    return data;
  }
}
