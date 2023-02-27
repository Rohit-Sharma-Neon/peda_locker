class HowItWorksResponse {
  bool? status;
  String? message;
  List<Data>? data;

  HowItWorksResponse({this.status, this.message, this.data});

  HowItWorksResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? name;
  bool isShow=false;
  String? video;
  String? image;
  String? description;
  String? isStatus;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  Data(
      {this.id,
        this.name,
        this.video,
        this.image,
        this.description,
        this.isStatus,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    video = json['video'];
    image = json['image'];
    description = json['description'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['video'] = this.video;
    data['image'] = this.image;
    data['description'] = this.description;
    data['is_status'] = this.isStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
