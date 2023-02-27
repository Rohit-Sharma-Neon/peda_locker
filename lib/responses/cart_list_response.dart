class CartListResponse {
  bool? status;
  String? message;
  List<Cart>? data;
  Request? request;
  var baseAmount;
  var discountAmount;
  var coupon_code;
  var extraCharge;
  var extra_charge;
  var totalAmount;

  CartListResponse(
      {this.status,
      this.message,
      this.data,
      this.coupon_code,
      this.extra_charge,
      this.extraCharge,
      this.request,
      this.baseAmount,
      this.discountAmount,
      this.totalAmount});

  CartListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Cart>[];
      json['data'].forEach((v) {
        data!.add(new Cart.fromJson(v));
      });
    }
    request =
        json['request'] != null ? new Request.fromJson(json['request']) : null;
    baseAmount = json['base_amount'];
    coupon_code = json['coupon_code'];
    extra_charge = json['extra_charge'];
    discountAmount = json['discount_amount'];
    extraCharge = json['extraCharge'];
    totalAmount = json['total_amount'];
  }
}

class Cart {
  int? id;
  int? userId;
  String? bikeName;
  int? bikeTypeId;
  int? bikeSizeId;
  String? bikeValue;
  var image;
  String? bikeImage;
  var brandId;
  String? ownerType;
  String? name;
  var countryCode;
  String? phone;
  String? driverHeight;
  var heightType;
  var bikePartsId;
  String? isStatus;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  var charge;
  var locker_no;
  String? checkInDate;
  String? checkOutDate;

  Cart(
      {this.id,
      this.userId,
      this.bikeName,
      this.bikeTypeId,
      this.bikeSizeId,
      this.bikeValue,
      this.image,
      this.bikeImage,
      this.locker_no,
      this.brandId,
      this.ownerType,
      this.name,
      this.countryCode,
      this.phone,
      this.driverHeight,
      this.heightType,
      this.bikePartsId,
      this.isStatus,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      this.charge,
      this.checkInDate,
      this.checkOutDate});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    locker_no = json['locker_no'];
    bikeName = json['bike_name'];
    bikeTypeId = json['bike_type_id'];
    bikeSizeId = json['bike_size_id'];
    bikeValue = json['bike_value'];
    image = json['image'];
    bikeImage = json['bike_image'];
    brandId = json['brand_id'];
    ownerType = json['owner_type'];
    name = json['name'];
    countryCode = json['country_code'];
    phone = json['phone'];
    driverHeight = json['driver_height'];
    heightType = json['height_type'];
    bikePartsId = json['bike_parts_id'];
    isStatus = json['is_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    charge = json['charge'];
    checkInDate = json['check_in_date'];
    checkOutDate = json['check_out_date'];
  }
}

class Request {
  String? checkOutDate;
  String? checkInDate;
  String? parkingSpotId;
  String? bikeId;

  Request(
      {this.checkOutDate, this.checkInDate, this.parkingSpotId, this.bikeId});

  Request.fromJson(Map<String, dynamic> json) {
    checkOutDate = json['check_out_date'];
    checkInDate = json['check_in_date'];
    parkingSpotId = json['parking_spot_id'];
    bikeId = json['bike_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['check_out_date'] = this.checkOutDate;
    data['check_in_date'] = this.checkInDate;
    data['parking_spot_id'] = this.parkingSpotId;
    data['bike_id'] = this.bikeId;
    return data;
  }
}
