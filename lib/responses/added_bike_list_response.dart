class AddedBikesListListResponse {
  bool? status;
  String? message;
  List<BikeData>? data;

  AddedBikesListListResponse({this.status, this.message, this.data});

  AddedBikesListListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BikeData>[];
      json['data'].forEach((v) {
        data!.add(new BikeData.fromJson(v));
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

class BikeData {
  int? id;
  bool isSelect = false;
  String? parts;
  String? brand;
  String? year;
  String? description;
  String? model;
  String? bikeName;
  String? array_counter;
  String? accessories;
  var brand_id;
  int? bikeTypeId;
  int? bikeSizeId;
  int? type;
  String? bikeValue;
  String? image;
  String? bike_image;
  String? image_url;
  String? ownerType;
  String? name;
  String? bike_name;
  String? countryCode;
  String? phone;
  String? driverHeight;
  String? heightType;
  String? isStatus;
  String? createdAt;
  String? updatedAt;
  String? partsId;
  String? accessoriesId;

  BikeData(
      {this.id,
      this.bikeName,
      this.accessories,
      this.parts,
      this.brand_id,
      this.bikeTypeId,
      this.bikeSizeId,
      this.bikeValue,
      this.bike_image,
      this.image_url,
      this.image,
        this.partsId,
        this.accessoriesId,
      this.bike_name,
      this.ownerType,
      this.name,
      this.countryCode,
      this.phone,
      this.array_counter,
      this.driverHeight,
      this.heightType,
      this.isStatus,
      this.createdAt,
      this.updatedAt});

  BikeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bikeName = json['bike_name'];
    array_counter = json['array_counter'];
    parts = json['parts'];
    brand_id = json['brand_id'];
    type = json['type'];
    year = json['year'];
    accessories = json['accessories'];
    bike_image = json['bike_image'];
    bikeTypeId = json['bike_type_id'];
    bikeSizeId = json['bike_size_id'];
    bikeValue = json['bike_value'];
    image_url = json['image_url'];
    bike_name = json['bike_name'];
    image = json['image'];
    partsId = json['parts_id'];
    accessoriesId = json['accessories_id'];
    ownerType = json['owner_type'];
    name = json['name'];
    countryCode = json['country_code'];
    phone = json['phone'];
    driverHeight = json['driver_height'];
    model = json['model'];
    brand = json['brand'];
    description = json['description'];
    heightType = json['height_type'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parts_id'] = this.partsId;
    data['accessories_id'] = this.accessoriesId;
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
    return data;
  }
}
