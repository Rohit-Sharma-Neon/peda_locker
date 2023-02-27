class BikeBrandResponse {
  bool? status;
  String? message;
  List<BikeBrandData>? data;
  dynamic request;

  BikeBrandResponse({this.status, this.message, this.data, this.request});

  BikeBrandResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BikeBrandData>[];
      json['data'].forEach((v) {
        data!.add(BikeBrandData.fromJson(v));
      });
    }
    request = json['request'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;

    data['request'] = this.request;
    return data;
  }
}

class BikeBrandData {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  BikeBrandData({this.id, this.name ,this.createdAt, this.updatedAt});

  BikeBrandData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}