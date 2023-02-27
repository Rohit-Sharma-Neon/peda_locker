// class ProductDetailsResponse {
//   ProductDetailsResponse({
//       this.status,
//       this.message,
//       this.data,
//       });
//
//   ProductDetailsResponse.fromJson(dynamic json) {
//     status = json['status'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//   bool? status;
//   String? message;
//   Data? data;
//
// }
// class Data {
//   Data({
//       this.product,
//       this.cartCount,});
//
//   Data.fromJson(dynamic json) {
//     product = json['product'] != null ? Product.fromJson(json['product']) : null;
//     cartCount = json['cartCount'];
//   }
//   Product? product;
//   int? cartCount;
//
//
// }
//
// class Product {
//
//
//   Product.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     image = json['image'];
//     modelNumber = json['model_number'];
//     description = json['description'];
//     isFeatured = json['is_featured'];
//     price = json['price'];
//     subCategory = json['sub_category'] != null ? SubCategory1.fromJson(json['sub_category']) : null;
//     brand = json['brand'] != null ? Brand.fromJson(json['brand']) : null;
//     if (json['productImage'] != null) {
//       productImage = [];
//       json['productImage'].forEach((v) {
//         productImage?.add(ProductImage.fromJson(v));
//       });
//     }
//     if (json['variant'] != null) {
//       variant = [];
//       json['variant'].forEach((v) {
//         variant?.add(Variant.fromJson(v));
//       });
//     }
//     isFav = json['is_fav'];
//     cartCount = json['cartCount'];
//   }
//   int? id;
//   String? name;
//   String? image;
//   String? modelNumber;
//   String? description;
//   int? isFeatured;
//   String? price;
//   SubCategory1? subCategory;
//   Brand? brand;
//   List<ProductImage>? productImage;
//   List<Variant>? variant;
//   int? isFav;
//   int? cartCount;
//
//
// }
//
// class Variant {
//   Variant({
//       this.id,
//       this.name,
//       this.options,});
//
//   Variant.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     if (json['options'] != null) {
//       options = [];
//       json['options'].forEach((v) {
//         options?.add(Options1.fromJson(v));
//       });
//     }
//   }
//   num? id;
//   String? name;
//   List<Options1>? options;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     if (options != null) {
//       map['options'] = options?.map((v) => v.toJson()).toList();
//     }
//     return map;
//   }
//
// }
//
// class Options1 {
//   Options1({
//       this.attributeId,
//       this.attributeValueId,
//       this.qty,
//       this.name,
//       this.mainPrice,
//       this.variantPrice,
//       this.price,});
//
//   Options1.fromJson(dynamic json) {
//     attributeId = json['attribute_id'];
//     attributeValueId = json['attribute_value_id'];
//     qty = json['qty'];
//     name = json['name'];
//     mainPrice = json['main_price'];
//     variantPrice = json['variant_price'];
//     price = json['price'];
//   }
//   String? attributeId;
//   String? attributeValueId;
//   num? qty;
//   String? name;
//   String? mainPrice;
//   String? variantPrice;
//   String? price;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['attribute_id'] = attributeId;
//     map['attribute_value_id'] = attributeValueId;
//     map['qty'] = qty;
//     map['name'] = name;
//     map['main_price'] = mainPrice;
//     map['variant_price'] = variantPrice;
//     map['price'] = price;
//     return map;
//   }
//
// }
//
// class ProductImage {
//   ProductImage({
//       this.id,
//       this.productId,
//       this.imageUrl,
//       this.createdAt,
//       this.updatedAt,});
//
//   ProductImage.fromJson(dynamic json) {
//     id = json['id'];
//     productId = json['product_id'];
//     imageUrl = json['image_url'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//   num? id;
//   num? productId;
//   String? imageUrl;
//   String? createdAt;
//   String? updatedAt;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['product_id'] = productId;
//     map['image_url'] = imageUrl;
//     map['created_at'] = createdAt;
//     map['updated_at'] = updatedAt;
//     return map;
//   }
//
// }
//
// class Brand {
//   Brand({
//       this.id,
//       this.name,
//       this.image,});
//
//   Brand.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     image = json['image'];
//   }
//   num? id;
//   String? name;
//   String? image;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['image'] = image;
//     return map;
//   }
//
// }
//
// class SubCategory1 {
//   SubCategory1({
//       this.id,
//       this.name,
//       this.image,
//       this.category,});
//
//   SubCategory1.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     image = json['image'];
//     category = json['category'] != null ? Category.fromJson(json['category']) : null;
//   }
//   num? id;
//   String? name;
//   String? image;
//   Category? category;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['image'] = image;
//     if (category != null) {
//       map['category'] = category?.toJson();
//     }
//     return map;
//   }
//
// }
//
// class Category {
//   Category({
//       this.id,
//       this.name,
//       this.image,});
//
//   Category.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     image = json['image'];
//   }
//   num? id;
//   String? name;
//   String? image;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['image'] = image;
//     return map;
//   }
//
// }