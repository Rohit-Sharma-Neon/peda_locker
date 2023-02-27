class ChargeModal {
  bool? status;
  String? message;
  Data? data;




  ChargeModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;

  }


}

class Data {

  dynamic cancellationCharges;
  dynamic refundAmount;




  Data.fromJson(Map<String, dynamic> json) {
    cancellationCharges = json['cancellation_charges'];
    refundAmount = json['refund_amount'];

  }


}

