class AllSubcategoryResponse {
  AllSubcategoryResponse({
      this.status, 
      this.message, 
      this.data, 
      });

  AllSubcategoryResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataSubCategory.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<DataSubCategory>? data;

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

class Request {
  Request({
      this.categoryId,});

  Request.fromJson(dynamic json) {
    categoryId = json['category_id'];
  }
  String? categoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category_id'] = categoryId;
    return map;
  }

}

class DataSubCategory {
  DataSubCategory({
      this.id, 
      this.name, 
      this.image, 
      this.category,});

  DataSubCategory.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
  }
  num? id;
  String? name;
  String? image;
  Category? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    return map;
  }

}

class Category {
  Category({
      this.id, 
      this.name, 
      this.image,});

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
  num? id;
  String? name;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    return map;
  }

}