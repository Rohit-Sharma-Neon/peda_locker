class OrderListingResponse {

  OrderListingResponse.fromJson(dynamic json) {
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
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
  Order? order;



}

class Order {


  Order.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataOrder.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    total = json['total'];
  }
  List<DataOrder>? data;
  num? currentPage;
  num? lastPage;
  num? total;


}

class DataOrder {

  DataOrder.fromJson(dynamic json) {
    id = json['id'];
    orderNo = json['order_no'];
    userId = json['user_id'];
    totalQty = json['total_qty'];
    totalAmount = json['total_amount'];
    cartAmount = json['cart_amount'];
    discountCode = json['discount_code'];
    discountPercent = json['discount_percent'];
    discountId = json['discount_id'];
    discountCodeAmount = json['discount_code_amount'];
    shippingCharges = json['shipping_charges'];
    km = json['km'];
    duration = json['duration'];
    baseDeliveryCharges = json['base_delivery_charges'];
    status = json['status'];
    cancelReason = json['cancel_reason'];
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    orderDate = json['order_date'];
    orderPdf = json['order_pdf'];
    if (json['order_details'] != null) {
      orderDetails = [];
      json['order_details'].forEach((v) {
        orderDetails?.add(OrderDetails.fromJson(v));
      });
    }
    orderAddress = json['order_address'] != null ? OrderAddress.fromJson(json['order_address']) : null;
  }
  num? id;
  String? orderNo;
  num? userId;
  num? totalQty;
  String? totalAmount;
  String? cartAmount;
  dynamic discountCode;
  dynamic discountPercent;
  dynamic discountId;
  dynamic discountCodeAmount;
  String? shippingCharges;
  dynamic km;
  dynamic duration;
  dynamic baseDeliveryCharges;
  num? status;
  dynamic cancelReason;
  String? paymentType;
  String? paymentStatus;
  String? orderDate;
  dynamic orderPdf;
  List<OrderDetails>? orderDetails;
  OrderAddress? orderAddress;


}

class OrderAddress {


  OrderAddress.fromJson(dynamic json) {
    id = json['id'];
    orderId = json['order_id'];
    address = json['address'];
    houseNumber = json['house_number'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    tag = json['tag'];
    otherTag = json['other_tag'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  num? orderId;
  String? address;
  String? houseNumber;
  String? landmark;
  String? latitude;
  String? longitude;
  String? tag;
  String? otherTag;
  String? createdAt;
  String? updatedAt;

}

class OrderDetails {

  OrderDetails.fromJson(dynamic json) {
    id = json['id'];
    orderId = json['order_id'];
    totalItemQty = json['total_item_qty'];
    totalAmount = json['total_amount'];
    productId = json['product_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }
  num? id;
  num? orderId;
  num? totalItemQty;
  String? totalAmount;
  num? productId;
  num? categoryId;
  dynamic subCategoryId;
  Product? product;


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
    if (json['variant'] != null) {
      variant = [];
      json['variant'].forEach((v) {
        variant?.add(Variant.fromJson(v));
      });
    }
    isFav = json['is_fav'];
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
  List<Variant>? variant;
  num? isFav;


}

class Variant {

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


}

class Brand {


  Brand.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
  num? id;
  String? name;
  String? image;


}

class Category {

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


}