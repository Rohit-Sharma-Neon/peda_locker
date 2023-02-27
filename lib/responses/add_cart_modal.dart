class AddCartModal {
  AddCartModal({
      this.status, 
      this.message, 
      this.data, 
      });

  AddCartModal.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;

  }
  bool? status;
  String? message;
  Data? data;

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

class Data {
  Data({
      this.id, 
      this.userId, 
      this.totalQty, 
      this.totalAmount, 
      this.cartAmount, 
      this.discountId, 
      this.discountAmount, 
      this.discountCode, 
      this.discountPercent, 
      this.shippingCharges, 
      this.km, 
      this.duration, 
      this.baseDeliveryCharges, 
      this.createdAt, 
      this.updatedAt, 
      this.cartDetails,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    totalQty = json['total_qty'];
    totalAmount = json['total_amount'];
    cartAmount = json['cart_amount'];
    discountId = json['discount_id'];
    discountAmount = json['discount_amount'];
    discountCode = json['discount_code'];
    discountPercent = json['discount_percent'];
    shippingCharges = json['shipping_charges'];
    km = json['km'];
    duration = json['duration'];
    baseDeliveryCharges = json['base_delivery_charges'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['cart_details'] != null) {
      cartDetails = [];
      json['cart_details'].forEach((v) {
        cartDetails?.add(CartDetails.fromJson(v));
      });
    }
  }
  var id;
  var userId;
  var totalQty;
  String? totalAmount;
  String? cartAmount;
  dynamic discountId;
  dynamic discountAmount;
  dynamic discountCode;
  dynamic discountPercent;
  String? shippingCharges;
  dynamic km;
  dynamic duration;
  dynamic baseDeliveryCharges;
  String? createdAt;
  String? updatedAt;
  List<CartDetails>? cartDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['total_qty'] = totalQty;
    map['total_amount'] = totalAmount;
    map['cart_amount'] = cartAmount;
    map['discount_id'] = discountId;
    map['discount_amount'] = discountAmount;
    map['discount_code'] = discountCode;
    map['discount_percent'] = discountPercent;
    map['shipping_charges'] = shippingCharges;
    map['km'] = km;
    map['duration'] = duration;
    map['base_delivery_charges'] = baseDeliveryCharges;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (cartDetails != null) {
      map['cart_details'] = cartDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class CartDetails {
  CartDetails({
      this.id, 
      this.cartId, 
      this.productId, 
      this.categoryId, 
      this.subCategoryId, 
      this.totalItemQty, 
      this.totalAmount, 
      this.createdAt, 
      this.updatedAt, 
      this.product,});

  CartDetails.fromJson(dynamic json) {
    id = json['id'];
    cartId = json['cart_id'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    totalItemQty = json['total_item_qty'];
    totalAmount = json['total_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }
  var id;
  var cartId;
  var productId;
  var categoryId;
  var subCategoryId;
  int? totalItemQty;
  String? totalAmount;
  String? createdAt;
  String? updatedAt;
  Product? product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cart_id'] = cartId;
    map['product_id'] = productId;
    map['category_id'] = categoryId;
    map['sub_category_id'] = subCategoryId;
    map['total_item_qty'] = totalItemQty;
    map['total_amount'] = totalAmount;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }

}

class Product {
  Product({
      this.id, 
      this.categoryId, 
      this.subCategoryId, 
      this.brandId, 
      this.supplierId, 
      this.modelNumber, 
      this.name, 
      this.arName, 
      this.description, 
      this.arDescription, 
      this.isFeatured, 
      this.image, 
      this.price, 
      this.qty, 
      this.isStatus, 
      this.attributeId, 
      this.createdAt, 
      this.updatedAt,});

  Product.fromJson(dynamic json) {
    id = json['id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    brandId = json['brand_id'];
    supplierId = json['supplier_id'];
    modelNumber = json['model_number'];
    name = json['name'];
    arName = json['ar_name'];
    description = json['description'];
    arDescription = json['ar_description'];
    isFeatured = json['is_featured'];
    image = json['image'];
    price = json['price'];
    qty = json['qty'];
    isStatus = json['is_status'];
    attributeId = json['attribute_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  var id;
  var categoryId;
  var subCategoryId;
  var brandId;
  var supplierId;
  String? modelNumber;
  String? name;
  String? arName;
  String? description;
  String? arDescription;
  var isFeatured;
  String? image;
  String? price;
  dynamic qty;
  var isStatus;
  dynamic attributeId;
  String? createdAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['sub_category_id'] = subCategoryId;
    map['brand_id'] = brandId;
    map['supplier_id'] = supplierId;
    map['model_number'] = modelNumber;
    map['name'] = name;
    map['ar_name'] = arName;
    map['description'] = description;
    map['ar_description'] = arDescription;
    map['is_featured'] = isFeatured;
    map['image'] = image;
    map['price'] = price;
    map['qty'] = qty;
    map['is_status'] = isStatus;
    map['attribute_id'] = attributeId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}