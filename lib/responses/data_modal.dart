class DataModal {
  DataModal({
    this.id,
    this.userId,
    this.address,
    this.houseNumber,
    this.appartmentOffice,
    this.landmark,
    this.latitude,
    this.longitude,
    this.tag,
    this.otherTag,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  DataModal.fromJson(dynamic json) {
    id = json['id'];
    userId = json['userId'];
    address = json['address'];
    houseNumber = json['house_number'];
    appartmentOffice = json['appartment_office'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    tag = json['tag'];
    otherTag = json['other_tag'];
    isDefault = json['is_default'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  var id;
  String? userId;
  String? address;
  String? houseNumber;
  String? appartmentOffice;
  String? landmark;
  String? latitude;
  String? longitude;
  String? tag;
  String? otherTag;
  String? isDefault;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['userId'] = userId;
    map['address'] = address;
    map['house_number'] = houseNumber;
    map['appartment_office'] = appartmentOffice;
    map['landmark'] = landmark;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['tag'] = tag;
    map['other_tag'] = otherTag;
    map['is_default'] = isDefault;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }
}