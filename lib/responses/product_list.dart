class ProductList {
  ProductList({
      this.status, 
      this.message, 
      this.data, 
      });

  ProductList.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataProduct.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  DataProduct? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}


class DataProduct {
  DataProduct({
      this.product, 
      this.cartCount,});

  DataProduct.fromJson(dynamic json) {
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    cartCount = json['cart_count'];
  }
  Product? product;
  num? cartCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (product != null) {
      map['product'] = product?.toJson();
    }
    map['cart_count'] = cartCount;
    return map;
  }

}

class Product {
  Product({
      this.data, 
      this.currentPage, 
      this.lastPage, 
      this.total,});

  Product.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data2.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
  }
  List<Data2>? data;
  num? currentPage;
  num? lastPage;
  num? total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['current_page'] = currentPage;
    map['last_page'] = lastPage;
    map['total'] = total;
    return map;
  }

}

class Data2 {
  Data2({
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

  Data2.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    modelNumber = json['model_number'];
    description = json['description'];
    isFeatured = json['is_featured'];
    price = json['price'];
    subCategory = json['sub_category'] != null ? SubCategory3.fromJson(json['sub_category']) : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    isFav = json['is_fav'];
  }
  num? id;
  String? name;
  String? image;
  String? modelNumber;
  String? description;
  num? isFeatured;
  String? price;
  SubCategory3? subCategory;
  Brand? brand;
  List<dynamic>? productImage;
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
    if (productImage != null) {
      map['productImage'] = productImage?.map((v) => v.toJson()).toList();
    }
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

class SubCategory3 {
  SubCategory3({
      this.id, 
      this.name, 
      this.image, 
      this.category,});

  SubCategory3.fromJson(dynamic json) {
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