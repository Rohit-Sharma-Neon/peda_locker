class BikeTypeResponse {
  bool? status;
  String? message;
  List<BikeTypeData>? data;
  List<String>? request;

  BikeTypeResponse({this.status, this.message, this.data, this.request});

  BikeTypeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BikeTypeData>[];
      json['data'].forEach((v) {
        data!.add(new BikeTypeData.fromJson(v));
      });
    }
    request = json['request'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['request'] = this.request;
    return data;
  }
}

class BikeTypeData {
  int? id;
  String? name;
  String? arName;
  String? image;
  String? isStatus;
  String? createdAt;
  String? updatedAt;

  BikeTypeData(
      {this.id,
        this.name,
        this.arName,
        this.image,
        this.isStatus,
        this.createdAt,
        this.updatedAt});

  BikeTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    image = json['image'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ar_name'] = this.arName;
    data['image'] = this.image;
    data['is_status'] = this.isStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}