class CommonResponse {
  bool? status;
  String? message;
  String? isPayment;
  String? tanNumber;
  bool? is_location;


  CommonResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isPayment = json['is_payment'];
    tanNumber = json['tanNumber'];
    is_location = json['is_location'];
  }


}
