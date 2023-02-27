class LocationListModal {
  LocationListModal({
      this.status, 
      this.message, 
      this.data, 
      });

  LocationListModal.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(LocationData.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<LocationData>? data;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class LocationData {
  LocationData({
      this.id, 
      this.locationName, 
      this.address, 
      this.shippingPrice, 
      this.latitude, 
      this.longitude, 
      this.createdAt, 
      this.updatedAt,});

  LocationData.fromJson(dynamic json) {
    id = json['id'];
    locationName = json['location_name'];
    address = json['address'];
    shippingPrice = json['shipping_price'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? locationName;
  String? address;
  String? shippingPrice;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['location_name'] = locationName;
    map['address'] = address;
    map['shipping_price'] = shippingPrice;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}