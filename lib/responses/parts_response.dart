class PartsResponse {
  bool? status;
  String? message;
  List<Data>? data;
  dynamic request;

  PartsResponse({this.status, this.message, this.data, this.request});

  PartsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? name;
  String? arName;
  String? image;
  String? createdAt;
  String? updatedAt;
  bool? isChecked;

  Data(
      {this.id,
        this.name,
        this.arName,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.isChecked = false});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arName = json['ar_name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isChecked = json['is_checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ar_name'] = this.arName;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_checked'] = this.isChecked;
    return data;
  }
}