class NextAvailability {
  bool? status;
  String? message;
  dynamic data;
  Request? request;

  NextAvailability({this.status, this.message, this.data, this.request});

  NextAvailability.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    request = json['request'] != null ? Request.fromJson(json['request']) : null;
  }
}



class Request {
  String? parkingSpotId;
  String? checkInDate;

  Request(
      {this.parkingSpotId,
        this.checkInDate,});

  Request.fromJson(Map<String, dynamic> json) {
    parkingSpotId = json['parking_spot_id'];
    checkInDate = json['check_in_date'];
  }
}
