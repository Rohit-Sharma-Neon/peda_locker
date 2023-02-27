class ErrorResponse {
  int? errcode;
  String? errmsg;
  String? description;

  ErrorResponse({this.errcode, this.errmsg, this.description});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    errcode = json['errcode'];
    errmsg = json['errmsg'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errcode'] = this.errcode;
    data['errmsg'] = this.errmsg;
    data['description'] = this.description;
    return data;
  }
}