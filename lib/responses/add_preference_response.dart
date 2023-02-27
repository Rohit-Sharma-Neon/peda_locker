class AddPreferenceResponse {
  bool? status;
  String? message;
  dynamic data;
  Request? request;

  AddPreferenceResponse({this.status, this.message, this.data, this.request});

  AddPreferenceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['data'] = this.data!.toJson();
    if (this.request != null) {
      data['request'] = this.request?.toJson();
    }
    return data;
  }
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}

class Request {
  String? preferenceId;

  Request({this.preferenceId});

  Request.fromJson(Map<String, dynamic> json) {
    preferenceId = json['preference_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['preference_id'] = this.preferenceId;
    return data;
  }
}
