class CheckSpotAvailabilityResponse {
  bool? status;
  String? message;
  List<CheckSpotAvailability>? data;
  Request? request;

  CheckSpotAvailabilityResponse({this.status, this.message, this.data, this.request});

  CheckSpotAvailabilityResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CheckSpotAvailability>[];
      json['data'].forEach((v) {
        data!.add(new CheckSpotAvailability.fromJson(v));
      });
    }
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.request != null) {
      data['request'] = this.request!.toJson();
    }
    return data;
  }
}

class CheckSpotAvailability {
  String? checkInDate;
  int? bookOrder;
  int? totalSpace;

  CheckSpotAvailability({this.checkInDate, this.bookOrder, this.totalSpace});

  CheckSpotAvailability.fromJson(Map<String, dynamic> json) {
    checkInDate = json['check_in_date'];
    bookOrder = json['book_order'];
    totalSpace = json['total_space'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['check_in_date'] = this.checkInDate;
    data['book_order'] = this.bookOrder;
    data['total_space'] = this.totalSpace;
    return data;
  }
}

class Request {
  String? parkingSpotId;

  Request({this.parkingSpotId});

  Request.fromJson(Map<String, dynamic> json) {
    parkingSpotId = json['parking_spot_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parking_spot_id'] = this.parkingSpotId;
    return data;
  }
}
