import 'package:cycle_lock/responses/data_modal.dart';

class AllCategory {

  AllCategory.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    address = json['address'] != null ? DataModal.fromJson(json['address']) : null;
  }
  bool? status;
  String? message;
  List<Data>? data;
  DataModal? address;


}

class Data {
  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
  num? id;
  String? name;
  String? image;


}