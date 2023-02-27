class VariantsResponse {
  VariantsResponse({
      this.status, 
      this.message, 
      this.data, 
    });

  VariantsResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Datas.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<Datas>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Datas {
  Datas({
      this.variantName,});

  Datas.fromJson(dynamic json) {
    variantName = json['variant_name'];
  }
  String? variantName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['variant_name'] = variantName;
    return map;
  }

}