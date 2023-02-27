import 'package:cycle_lock/responses/data_modal.dart';

class AddressListModal {
  AddressListModal({
      this.status, 
      this.message, 
      this.data, 
  });

  AddressListModal.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataModal.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<DataModal>? data;


}

