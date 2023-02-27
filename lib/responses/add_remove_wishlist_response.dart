class AddRemoveWishlistResponse {
  AddRemoveWishlistResponse({
      this.status, 
      this.message, 
      this.data,});

  AddRemoveWishlistResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
  bool? status;
  String? message;
  dynamic data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    return map;
  }

}
