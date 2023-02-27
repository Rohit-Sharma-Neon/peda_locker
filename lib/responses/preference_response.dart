class PreferenceResponse {
  bool? status;
  String? message;
  List<Data>? data;
  List<String>? request;

  PreferenceResponse({this.status, this.message, this.data, this.request});

  PreferenceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
  String? image;
  String? description;
  String? arName;
  String? arDescription;
  String? isStatus;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  bool? isChecked;

  Data(
      {this.id,
        this.name,
        this.image,
        this.description,
        this.arName,
        this.arDescription,
        this.isStatus,
        this.createdAt,
        this.updatedAt,
        this.isChecked,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    arName = json['ar_name'];
    arDescription = json['ar_description'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    isChecked = json['is_checked'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['ar_name'] = this.arName;
    data['ar_description'] = this.arDescription;
    data['is_status'] = this.isStatus;
    data['is_checked'] = this.isChecked;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
