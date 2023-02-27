class ServiceResponse {
  bool? status;
  String? message;
  List<Data>? data;
  List<String>? request;

  ServiceResponse({this.status, this.message, this.data, this.request});

  ServiceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  String? name;
  String? arName;
  String? image;
  var isStatus;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  Data(
      {this.id,
        this.name,
        this.arName,
        this.image,
        this.isStatus,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    image = json['image'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
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
    data['image_url'] = this.imageUrl;
    return data;
  }
}