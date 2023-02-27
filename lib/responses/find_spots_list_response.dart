class FindSpotsListResponse {
  bool? status;
  String? message;
  List<FindSpots>? data;
  FindSpotsListRequest? request;

  FindSpotsListResponse({this.status, this.message, this.data, this.request});

  FindSpotsListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FindSpots>[];
      json['data'].forEach((v) {
        data!.add(new FindSpots.fromJson(v));
      });
    }
    request =
        json['request'] != null ? new FindSpotsListRequest.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class FindSpots {
  int? id;
  var userId;
  String? bikeName;
  bool? isSelect = false;
  int? bikeTypeId;
  int? bikeSizeId;
  String? bikeValue;
  String? image;
  String? bike_image;
  String? ownerType;
  String? name;
  String? countryCode;
  String? phone;
  var array_counter;
  String? driverHeight;
  String? heightType;
  String? isStatus;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  String? available;
  List<DateAvailable>? availabileDate;
  List<DateAvailable>? unAvailabileDate;


  FindSpots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bike_image = json['bike_image'];
    bikeName = json['bike_name'];
    bikeTypeId = json['bike_type_id'];
    bikeSizeId = json['bike_size_id'];
    bikeValue = json['bike_value'];
    image = json['image'];
    array_counter = json['array_counter'];
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
    available = json['available'];
    if (json['availabileDate'] != null) {
      availabileDate = <DateAvailable>[];
      json['availabileDate'].forEach((v) {
        availabileDate!.add(new DateAvailable.fromJson(v));
      });
    }
    if (json['unAvailabileDate'] != null) {
      unAvailabileDate = <DateAvailable>[];
      json['unAvailabileDate'].forEach((v) {
        unAvailabileDate!.add(new DateAvailable.fromJson(v));
      });
    }
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
    data['available'] = this.available;
    return data;
  }
}

class DateAvailable{
  String? checkInDate;
  DateAvailable.fromJson(Map<String, dynamic> json) {
    checkInDate = json['check_in_date'];
  }
}

class FindSpotsListRequest {
  String? parkingSpotId;
  String? bikeId;
  String? checkInDate;
  String? checkOutDate;

  FindSpotsListRequest(
      {this.parkingSpotId, this.bikeId, this.checkInDate, this.checkOutDate});

  FindSpotsListRequest.fromJson(Map<String, dynamic> json) {
    parkingSpotId = json['parking_spot_id'];
    bikeId = json['bike_id'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parking_spot_id'] = this.parkingSpotId;
    data['bike_id'] = this.bikeId;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    return data;
  }
}
