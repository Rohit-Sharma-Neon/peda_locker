class BikeSizeResponse {
  bool? status;
  String? message;
  List<BikeSizeData>? data;
  dynamic request;

  BikeSizeResponse({this.status, this.message, this.data, this.request});

  BikeSizeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BikeSizeData>[];
      json['data'].forEach((v) {
        data!.add(BikeSizeData.fromJson(v));
      });
    }
    request = json['request'];
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

class BikeSizeData {
  int? id;
  String? size;
  String? sizeType;
  String? createdAt;
  String? updatedAt;

  BikeSizeData({this.id, this.size, this.sizeType, this.createdAt, this.updatedAt});

  BikeSizeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
    sizeType = json['size_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> BikeSizeData = new Map<String, dynamic>();
    BikeSizeData['id'] = this.id;
    BikeSizeData['size'] = this.size;
    BikeSizeData['size_type'] = this.sizeType;
    BikeSizeData['created_at'] = this.createdAt;
    BikeSizeData['updated_at'] = this.updatedAt;
    return BikeSizeData;
  }
}