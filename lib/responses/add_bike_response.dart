class AddBikeResponse {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  AddBikeResponse({this.status, this.message, this.data, this.request});

  AddBikeResponse.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? bikeName;
  String? bikeTypeId;
  String? bikeSizeId;
  String? bikeValue;
  String? ownerType;
  String? name;
  String? bikeId;
  String? countryCode;
  String? phone;
  String? driverHeight;
  String? heightType;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data({this.image,this.bikeId, this.bikeName, this.bikeTypeId, this.bikeSizeId, this.bikeValue, this.ownerType, this.name, this.countryCode, this.phone, this.driverHeight, this.heightType, this.updatedAt, this.createdAt, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    bikeId = json['bike_id'];
    bikeName = json['bike_name'];
    bikeTypeId = json['bike_type_id'];
    bikeSizeId = json['bike_size_id'];
    bikeValue = json['bike_value'];
    ownerType = json['owner_type'];
    name = json['name'];
    countryCode = json['country_code'];
    phone = json['phone'];
    driverHeight = json['driver_height'];
    heightType = json['height_type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['bike_name'] = this.bikeName;
    data['bike_id'] = this.bikeId;
    data['bike_type_id'] = this.bikeTypeId;
    data['bike_size_id'] = this.bikeSizeId;
    data['bike_value'] = this.bikeValue;
    data['owner_type'] = this.ownerType;
    data['name'] = this.name;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['driver_height'] = this.driverHeight;
    data['height_type'] = this.heightType;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

class Request {
  String? bikeName;
  String? bikeTypeId;
  String? bikeValue;
  String? ownerType;
  String? name;
  String? countryCode;
  String? phone;
  String? driverHeight;
  String? heightType;
  String? accessoriesId;
  String? partId;
  String? bikeSizeId;
  dynamic image;

  Request({this.bikeName, this.bikeTypeId, this.bikeValue, this.ownerType, this.name, this.countryCode, this.phone, this.driverHeight, this.heightType, this.accessoriesId, this.partId, this.bikeSizeId, this.image});

  Request.fromJson(Map<String, dynamic> json) {
    bikeName = json['bike_name'];
    bikeTypeId = json['bike_type_id'];
    bikeValue = json['bike_value'];
    ownerType = json['owner_type'];
    name = json['name'];
    countryCode = json['country_code'];
    phone = json['phone'];
    driverHeight = json['driver_height'];
    heightType = json['height_type'];
    accessoriesId = json['accessories_id'];
    partId = json['part_id'];
    bikeSizeId = json['bike_size_id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bike_name'] = this.bikeName;
    data['bike_type_id'] = this.bikeTypeId;
    data['bike_value'] = this.bikeValue;
    data['owner_type'] = this.ownerType;
    data['name'] = this.name;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['driver_height'] = this.driverHeight;
    data['height_type'] = this.heightType;
    data['accessories_id'] = this.accessoriesId;
    data['part_id'] = this.partId;
    data['bike_size_id'] = this.bikeSizeId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}
