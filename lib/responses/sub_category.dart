class SubCategory {


  SubCategory.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  Data? data;

}



class Data {
  Data({
      this.subCategory, 
      this.cartCount, 
      this.notificationCount,});

  Data.fromJson(dynamic json) {
    if (json['sub_category'] != null) {
      subCategory = [];
      json['sub_category'].forEach((v) {
        subCategory?.add(SubCategory2.fromJson(v));
      });
    }
    cartCount = json['cart_count'];
    notificationCount = json['notification_count'];
  }
  List<SubCategory2>? subCategory;
  num? cartCount;
  num? notificationCount;


}

class SubCategory2 {


  SubCategory2.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  num? id;
  String? name;
  String? image;
  Category? category;


}

class Category {

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
  num? id;
  String? name;
  String? image;

}