class ProductDetailModal {


  ProductDetailModal.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;

  }
  bool? status;
  String? message;
  Data? data;

}


class Data {


  Data.fromJson(dynamic json) {
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    cartCount = json['cart_count'];
    if (json['similar_product'] != null) {
      similarProduct = [];
      json['similar_product'].forEach((v) {
        similarProduct?.add(SimilarProduct.fromJson(v));
      });
    }
  }
  Product? product;
  int? cartCount;
  List<SimilarProduct>? similarProduct;


}

class SimilarProduct {

  SimilarProduct.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    modelNumber = json['model_number'];
    description = json['description'];
    isFeatured = json['is_featured'];
    price = json['price'];
    qty = json['qty'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    if (json['productImage'] != null) {
      productImage = [];
      json['productImage'].forEach((v) {
        productImage?.add(ProductImage.fromJson(v));
      });
    }
    if (json['variant'] != null) {
      variant = [];
      json['variant'].forEach((v) {
        variant?.add(Variant.fromJson(v));
      });
    }
    isFav = json['is_fav'];
    cartCount = json['cartCount'];
  }
  num? id;
  String? name;
  String? image;
  String? modelNumber;
  String? description;
  num? isFeatured;
  String? price;
  String? qty;
  Category? category;
  Brand? brand;
  List<ProductImage>? productImage;
  List<Variant>? variant;
  num? isFav;
  num? cartCount;


}

class ProductImage {
  ProductImage({
       this.id,
       this.productId,
       this.image,
       this.createdAt,
       this.updatedAt,});

  ProductImage.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    image = json['image_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  num? productId;
  String? image;
  String? createdAt;
  String? updatedAt;

}

class Variant {
  Variant({
      this.id, 
      this.productId, 
      this.variantName, 
      this.variantNameAr, 
      this.variantValue, 
      this.variantValueAr, 
      this.createdAt, 
      this.updatedAt,});

  Variant.fromJson(dynamic json) {
    id = json['id'];
    productId = json['product_id'];
    variantName = json['variant_name'];
    variantNameAr = json['variant_name_ar'];
    variantValue = json['variant_value'];
    variantValueAr = json['variant_value_ar'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  num? productId;
  String? variantName;
  String? variantNameAr;
  String? variantValue;
  String? variantValueAr;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['product_id'] = productId;
    map['variant_name'] = variantName;
    map['variant_name_ar'] = variantNameAr;
    map['variant_value'] = variantValue;
    map['variant_value_ar'] = variantValueAr;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
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

class Category {
  Category({
      this.id, 
      this.name, 
      this.image, 
      this.subcategoryCount, 
      this.productCount,});

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    subcategoryCount = json['subcategory_count'];
    productCount = json['product_count'];
  }
  num? id;
  String? name;
  String? image;
  num? subcategoryCount;
  num? productCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['subcategory_count'] = subcategoryCount;
    map['product_count'] = productCount;
    return map;
  }

}

class Product {


  Product.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    modelNumber = json['model_number'];
    description = json['description'];
    isFeatured = json['is_featured'];
    price = json['price'];
    qty = json['qty'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
    if (json['productImage'] != null) {
      productImage = [];
      json['productImage'].forEach((v) {
        productImage?.add(ProductImage.fromJson(v));
      });
    }
    if (json['variant'] != null) {
      variant = [];
      json['variant'].forEach((v) {
        variant?.add(Variant.fromJson(v));
      });
    }
    isFav = json['is_fav'];
    cartCount = json['cartCount'];
  }
  num? id;
  String? name;
  String? image;
  String? modelNumber;
  String? description;
  num? isFeatured;
  String? price;
  String? qty;
  Category? category;
  Brand? brand;
  List<ProductImage>? productImage;
  List<Variant>? variant;
  num? isFav;
  num? cartCount;

}

