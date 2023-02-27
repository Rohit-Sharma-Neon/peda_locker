class TermsConditionsResponse {
  bool? status;
  String? message;
  Data? data;
  List<String>? request;

  TermsConditionsResponse({this.status, this.message, this.data, this.request});

  TermsConditionsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    request = json['request'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['request'] = this.request;
    return data;
  }
}

class Data {
  int? id;
  Null? slug;
  String? title;
  String? description;
  String? arTitle;
  String? arDescription;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.slug,
        this.title,
        this.description,
        this.arTitle,
        this.arDescription,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    description = json['description'];
    arTitle = json['ar_title'];
    arDescription = json['ar_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['title'] = this.title;
    data['description'] = this.description;
    data['ar_title'] = this.arTitle;
    data['ar_description'] = this.arDescription;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}