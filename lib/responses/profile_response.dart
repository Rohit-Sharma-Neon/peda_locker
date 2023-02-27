class ProfileResponse {
  bool? status;
  String? message;
  dynamic data;
  dynamic request;

  ProfileResponse({this.status, this.message, this.data, this.request});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ProfileData.fromJson(json['data'])
        : null;
    request = json['request'];
  }

}

class ProfileData {

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
  String? accessToken;
  String? height;
  String? heightType;
  String? preferences_id;
  String? preferences_name;
  dynamic is_name_update = 0;



  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    countryCode = json['country_code'];
    phone = json['phone'];
    image = json['image'];
    dob = json['dob'];
    preferences_id = json['preferences_id'];
    preferences_name = json['preferences_name'];
    height = json['height'];
    heightType = json['height_type'];
    accessToken = json['access_token'];
    gender = json['gender'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    is_name_update = json['is_name_update'];
  }

}
