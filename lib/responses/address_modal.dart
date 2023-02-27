import 'package:cycle_lock/responses/data_modal.dart';

class AddressModal {
  AddressModal({
      this.status, 
      this.message, 
      this.data, 
  });

  AddressModal.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataModal.fromJson(json['data']) : null;
   // request = json['request'] != null ? Request.fromJson(json['request']) : null;
  }
  bool? status;
  String? message;
  DataModal? data;
//  Request? request;



}



