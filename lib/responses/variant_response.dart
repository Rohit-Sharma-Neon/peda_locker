// class VariantResponse {
//   VariantResponse({
//       this.status,
//       this.message,
//       this.data,});
//
//   VariantResponse.fromJson(dynamic json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = [];
//       json['data'].forEach((v) {
//         data?.add(Datas.fromJson(v));
//       });
//     }
//   }
//   bool? status;
//   String? message;
//   List<Datas>? data;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['status'] = status;
//     map['message'] = message;
//     if (data != null) {
//       map['data'] = data?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
// class Datas {
//   Datas({
//       this.id,
//       this.title,});
//
//   Datas.fromJson(dynamic json) {
//     id = json['id'];
//     title = json['title'];
//   }
//   num? id;
//   String? title;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['title'] = title;
//     return map;
//   }
//
// }