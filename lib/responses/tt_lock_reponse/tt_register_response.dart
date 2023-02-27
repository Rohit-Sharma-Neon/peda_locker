class RegisterResponse {
  int? errcode;
  String? errmsg;
  String? description;
  String? username;

  RegisterResponse({this.errcode, this.errmsg, this.description,this.username});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    errcode = json['errcode'];
    errmsg = json['errmsg'];
    description = json['description'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errcode'] = this.errcode;
    data['errmsg'] = this.errmsg;
    data['description'] = this.description;
    data['username'] = this.username;
    return data;
  }
}