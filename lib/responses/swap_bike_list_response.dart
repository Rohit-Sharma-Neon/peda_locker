class SwapBikeListingResponse {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  SwapBikeListingResponse({this.status, this.message, this.data, this.request});

  SwapBikeListingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }


}

class Data {
  List<SwapBike>? swapBike;
  List<UserBike>? userBike;

  Data({this.swapBike, this.userBike});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['swap_bike'] != null) {
      swapBike = <SwapBike>[];
      json['swap_bike'].forEach((v) {
        swapBike!.add(new SwapBike.fromJson(v));
      });
    }
    if (json['user_bike'] != null) {
      userBike = <UserBike>[];
      json['user_bike'].forEach((v) {
        userBike!.add(new UserBike.fromJson(v));
      });
    }
  }

}

class SwapBike {
  int? id;
  int? bike_id;
  var addBikeId;
  bool isSelect = false;
  Bike? bike;

  SwapBike({this.id, this.addBikeId, this.bike});

  SwapBike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bike_id = json['bike_id'];
    addBikeId = json['add_bike_id'];
    bike = json['bike'] != null ? new Bike.fromJson(json['bike']) : null;
  }
}

class Bike {
  int? id;
  String? bikeName;
  String? bikeValue;
  String? image;
  String? bike_image;
  String? imageUrl;

  Bike({this.id, this.bikeName, this.bike_image, this.bikeValue, this.image, this.imageUrl});

  Bike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bikeName = json['bike_name'];
    bike_image = json['bike_image'];
    bikeValue = json['bike_value'];
    image = json['image'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bike_name'] = this.bikeName;
    data['bike_value'] = this.bikeValue;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
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
  String? checkInDate;
  String? checkOutDate;
  String? type;
  var id;

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
        this.lang,
        this.checkInDate,
        this.checkOutDate,
        this.type,
        this.id});

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
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    type = json['type'];
    id = json['id'];
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
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}


class UserBike {
  int? id;
  String? bikeName;
  bool isSelect = false;
  String? bikeValue;
  String? image;
  String? bike_image;
  String? imageUrl;

  UserBike({this.id, this.bikeName, this.bikeValue, this.image, this.imageUrl});

  UserBike.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bikeName = json['bike_name'];
    bike_image = json['bike_image'];
    bikeValue = json['bike_value'];
    image = json['image'];
    imageUrl = json['image_url'];
  }
}
