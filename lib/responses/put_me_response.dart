class NotifySpotsResponse {
  bool? status;
  String? message;
  Data? data;
  Request? request;

  NotifySpotsResponse({this.status, this.message, this.data, this.request});

  NotifySpotsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? parkingSpotId;
  int? orderCount;

  Data({this.id, this.parkingSpotId, this.orderCount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parkingSpotId = json['parking_spot_id'];
    orderCount = json['order_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parking_spot_id'] = this.parkingSpotId;
    data['order_count'] = this.orderCount;
    return data;
  }
}

class Request {
  String? parkingSpotId;
  String? bikeId;
  String? checkInDate;
  String? checkOutDate;
  String? transactionId;
  String? totalAmount;
  String? type;

  Request(
      {this.parkingSpotId,
        this.bikeId,
        this.checkInDate,
        this.checkOutDate,
        this.transactionId,
        this.totalAmount,
        this.type});

  Request.fromJson(Map<String, dynamic> json) {
    parkingSpotId = json['parking_spot_id'];
    bikeId = json['bike_id'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
    transactionId = json['transaction_id'];
    totalAmount = json['total_amount'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parking_spot_id'] = this.parkingSpotId;
    data['bike_id'] = this.bikeId;
    data['check_in_date'] = this.checkInDate;
    data['check_out_date'] = this.checkOutDate;
    data['transaction_id'] = this.transactionId;
    data['total_amount'] = this.totalAmount;
    data['type'] = this.type;
    return data;
  }
}
