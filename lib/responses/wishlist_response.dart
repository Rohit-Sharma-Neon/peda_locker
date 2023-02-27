class WishlistResponse {
  WishlistResponse({
      this.status, 
      this.message, 
      this.data,});

  WishlistResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<Data>? data;

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

class Data {
  Data({
      this.id, 
      this.name, 
      this.image, 
      this.modelNumber, 
      this.description, 
      this.isFeatured, 
      this.price, 
      this.subCategory, 
      this.brand, 
      this.productImage, 
      this.isFav,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    modelNumber = json['model_number'];
    description = json['description'];
    isFeatured = json['is_featured'];
    price = json['price'];
    subCategory = json['sub_category'] != null ? SubCategory4.fromJson(json['sub_category']) : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    productImage = json['productImage'];
    isFav = json['is_fav'];
  }
  num? id;
  String? name;
  String? image;
  String? modelNumber;
  String? description;
  num? isFeatured;
  String? price;
  SubCategory4? subCategory;
  Brand? brand;
  dynamic productImage;
  num? isFav;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['model_number'] = modelNumber;
    map['description'] = description;
    map['is_featured'] = isFeatured;
    map['price'] = price;
    if (subCategory != null) {
      map['sub_category'] = subCategory?.toJson();
    }
    if (brand != null) {
      map['brand'] = brand?.toJson();
    }
    map['productImage'] = productImage;
    map['is_fav'] = isFav;
    return map;
  }

}

class Brand {
  Brand({
      this.id, 
      this.name, 
      this.image,});

  Brand.fromJson(dynamic json) {
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

class SubCategory4 {
  SubCategory4({
      this.id, 
      this.name, 
      this.image, 
      this.category,});

  SubCategory4.fromJson(dynamic json) {
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