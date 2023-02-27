class GetProfileResponse {
  bool? status;
  String? message;
  Data? data;
  List<String>? request;

  GetProfileResponse({this.status, this.message, this.data, this.request});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    request = json['request'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['request'] = this.request;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? countryCode;
  String? phone;
  String? image;
  String? dob;
  String? gender;
  String? deviceType;
  String? deviceToken;
  String? isStatus;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  Data(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.countryCode,
      this.phone,
      this.image,
      this.dob,
      this.gender,
      this.deviceType,
      this.deviceToken,
      this.isStatus,
      this.createdAt,
      this.updatedAt,
      this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    countryCode = json['country_code'];
    phone = json['phone'];
    image = json['image'];
    dob = json['dob'];
    gender = json['gender'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['device_type'] = this.deviceType;
    data['device_token'] = this.deviceToken;
    data['is_status'] = this.isStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
