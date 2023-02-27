import 'package:cycle_lock/responses/data_modal.dart';

class ProductCategory {

  ProductCategory.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;

  }
  bool? status;
  String? message;
  Data? data;


}

class Data {


  Data.fromJson(dynamic json) {
    if (json['category'] != null) {
      category = [];
      json['category'].forEach((v) {
        category?.add(Category.fromJson(v));
      });
    }
    address = json['address'] != null ? DataModal.fromJson(json['address']) : null;
    cartCount = json['cart_count'];
    notificationCount = json['notification_count'];
  }
  List<Category>? category;
  DataModal? address;
  num? cartCount;
  num? notificationCount;


}


class Category {


  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    subcategoryCount = json['subcategory_count'];
    productCount = json['product_count'];
    subcategory_count = json['subcategory_count'];
  }
  num? id;
  String? name;
  String? image;
  num? subcategoryCount;
  var productCount;
  var subcategory_count;




}