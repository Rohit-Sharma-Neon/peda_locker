import 'dart:convert';
import 'dart:io';

import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/webapi_constaint.dart';
import 'package:cycle_lock/responses/accessories_response.dart';
import 'package:cycle_lock/responses/add_bike_response.dart';
import 'package:cycle_lock/responses/address_list_modal.dart';
import 'package:cycle_lock/responses/address_modal.dart';
import 'package:cycle_lock/responses/all_category.dart';
import 'package:cycle_lock/responses/bike_size_response.dart';
import 'package:cycle_lock/responses/bike_type_response.dart';
import 'package:cycle_lock/responses/cancel_modal.dart';
import 'package:cycle_lock/responses/charge_modal.dart';
import 'package:cycle_lock/responses/data_modal.dart';
import 'package:cycle_lock/responses/loction_list_modal.dart';
import 'package:cycle_lock/responses/login_response.dart';
import 'package:cycle_lock/responses/logout_response.dart';
import 'package:cycle_lock/responses/next_availitity.dart';
import 'package:cycle_lock/responses/order_details_modal.dart';
import 'package:cycle_lock/responses/order_list_response.dart';
import 'package:cycle_lock/responses/parts_response.dart';
import 'package:cycle_lock/responses/privacy_policy_response.dart';
import 'package:cycle_lock/responses/product_category.dart';
import 'package:cycle_lock/responses/resend_otp_response.dart';
import 'package:cycle_lock/responses/reset_password_response.dart';
import 'package:cycle_lock/responses/send_otp_response.dart';
import 'package:cycle_lock/responses/service_response.dart';
import 'package:cycle_lock/responses/terms_conditions_response.dart';
import 'package:cycle_lock/responses/verify_otp_response.dart';
import 'package:cycle_lock/responses/wishlist_response.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../responses/add_cart_modal.dart';
import '../responses/add_preference_response.dart';
import '../responses/add_remove_wishlist_response.dart';
import '../responses/added_bike_list_response.dart';
import '../responses/all_subcategory_response.dart';
import '../responses/apply_coupon_response.dart';
import '../responses/bike_brand_response.dart';
import '../responses/cart_list_response.dart';
import '../responses/chec_spo_availability_response.dart';
import '../responses/comman_response.dart';
import '../responses/coupon_list.dart';
import '../responses/create_order_response.dart';
import '../responses/find_spots_list_response.dart';
import '../responses/home_page_response.dart';
import '../responses/how_it_works_response.dart';
import '../responses/notification_list_response.dart';
import '../responses/orders_list_response.dart';
import '../responses/parking_list_response.dart';
import '../responses/parking_spots_details_response.dart';
import '../responses/preference_response.dart';
import '../responses/product_detail_modal.dart';
import '../responses/product_details_response.dart';
import '../responses/product_list.dart';
import '../responses/profile_response.dart';
import '../responses/put_me_response.dart';
import '../responses/sahre_bike_details_response.dart';
import '../responses/share_data_response.dart';
import '../responses/sub_category.dart';
import '../responses/swap_bike_list_response.dart';
import '../responses/variant_response.dart';
import '../responses/variants_response.dart';
import '../utils/logger.dart';

class Apis {
  Dio _dio = Dio();
  //static const String BASE_URL = "http://3.20.147.34/pedalocker/api";
  static const String BASE_URL = "https://pedalocker.com/admin/api";
  //static const String BASE_URL = "http://23.23.192.118/admin/api";
  String token = "";
  String authUsername = 'pedalocker';
  String authPassword = 'pedalocker@123';

  Apis() {
    token = spPreferences.getString(SpUtil.ACCESS_TOKEN) ?? "";
    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      headers: {"token": token, "Authorization": "Bearer $token"},
      receiveTimeout: 30000,
      connectTimeout: 30000,
      contentType: 'application/json',
      responseType: ResponseType.plain,
      followRedirects: false,
      validateStatus: (status) {
        return status! <= 500;
      },
    );
    Logger.msg("var " + token);
    Logger.msg(token.toString());
    _dio = Dio(options);
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        responseHeader: false,
        requestHeader: true,
        logPrint: (object) => Logger.msg(object.toString()),
        request: false,
      ),
      /*RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: Dio(),
          connectivity: Connectivity(),
        ),
      ),*/
    );
  }

  Future<LoginResponse?> loginApi(
      {required String countryCode,
      required String phone,
      required String password}) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.loginConstant,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ??
                      spPreferences.getString(SpUtil.USER_LANGUAGE) ??
                      "en",
              'authorization': basicAuth
            }),
            data: {
              "phone": phone,
              "country_code": countryCode,
              //"password": password,
              "device_token": spPreferences.getString(SpUtil.FCM_TOKEN),
              "device_type": spPreferences.getString(SpUtil.DEVICE_TYPE)
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return LoginResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<SendOtpResponse?> sendOtpApi(
      {required String countryCode,
      required String phone,
      String? email,
      required String userType}) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.sendOtpConstant);
        if (email!.isNotEmpty) {
          try {
            Response response = await _dio.post(WebAPIConstant.sendOtpConstant,
                options: Options(headers: <String, String>{
                  "Content-Type": "application/json",
                  "Accept-Language":
                      spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                  'authorization': basicAuth
                }),
                data: {
                  "phone": phone,
                  "country_code": countryCode,
                  "email": email,
                  "user_type": userType
                });
            Logger.msg("data : ${response.data}");
            final Map<String, dynamic> data = json.decode(response.data);

            return SendOtpResponse.fromJson(data);
          } catch (error, stacktrace) {
            Logger.msg("Exception occured: $error stackTrace: $stacktrace");
            return null;
          }
        } else {
          try {
            Response response = await _dio.post(WebAPIConstant.sendOtpConstant,
                options: Options(headers: <String, String>{
                  "Content-Type": "application/json",
                  "Accept-Language":
                      spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                  'authorization': basicAuth
                }),
                data: {
                  "phone": phone,
                  "country_code": countryCode,
                  "user_type": userType
                });
            Logger.msg("data : ${response.data}");
            final Map<String, dynamic> data = json.decode(response.data);

            return SendOtpResponse.fromJson(data);
          } catch (error, stacktrace) {
            Logger.msg("Exception occured: $error stackTrace: $stacktrace");
            return null;
          }
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<VerifyOtpResponse?> verifyOtpApi(
      {required String countryCode,
      required String phone,
      required String email,
      required String userType,
      required String password,
      required String name,
      required String otp,
      required String preferences}) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.verifyOtpConstant);
        try {
          Response response = await _dio.post(
            WebAPIConstant.verifyOtpConstant,
            options: Options(headers: <String, dynamic>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'authorization': basicAuth
            }),
            data: {
              "password": password,
              "name": name,
              "phone": phone,
              "user_id": spPreferences.getString(SpUtil.USER_ID),
              "country_code": countryCode,
              "email": email,
              "otp": otp,
              "user_type": userType,
              "preference_id": preferences,
              "device_token": spPreferences.getString(SpUtil.FCM_TOKEN),
              "device_type": spPreferences.getString(SpUtil.DEVICE_TYPE)
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return VerifyOtpResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<PreferenceResponse?> preferenceApi() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.preference);
        try {
          Response response = await _dio.get(
            WebAPIConstant.preference,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'authorization': basicAuth
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return PreferenceResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> changePasswordApi(
      {required String oldPass,
      required String newPass,
      required String confPass}) async {
    Logger.msg("token from change pass" + token);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.changePassword);
        try {
          Response response = await _dio.post(
            WebAPIConstant.changePassword,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "old_password": oldPass,
              "new_password": newPass,
              "conf_password": confPass
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);
          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<HomeDataResponse?> homePageDataApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            (spPreferences.getBool(SpUtil.IS_GUEST) ?? false)
                ? WebAPIConstant.homepageGuestData
                : WebAPIConstant.homepageData,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "lat": spPreferences.getString(SpUtil.USER_LAT) ?? "0",
              "lang": spPreferences.getString(SpUtil.USER_LANG) ?? "0",
              "preference_id": spPreferences.getString(SpUtil.PREFERENCES_ID),
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return HomeDataResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ShareBikeListingResponse?> getShareDataApi(order_id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.shareBikeListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"order_id": order_id},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ShareBikeListingResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> shareBikeAddApi(
      order_id,
      bike_id,
      share_type,
      country_code,
      phone,
      name,
      start_date_time,
      end_date_time,
      parking_spot_id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.shareBikeAdd,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "order_id": order_id,
              "bike_id": bike_id,
              "share_type": share_type,
              "country_code": country_code,
              "phone": phone,
              "name": name,
              "start_date_time": start_date_time,
              "end_date_time": end_date_time,
              "parking_spot_id": parking_spot_id
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> shareBikeRevokeApi(id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.shareBikeRevoke,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"id": id},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<OrderListResponse?> orderListApi(type) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"type": type},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return OrderListResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ChargeModal?> orderCancelCharges(order_id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderCancelCharges,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"order_id": order_id},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ChargeModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> orderRatingApi(order_id, rating, review) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderRating,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "order_id": order_id,
              "rating": rating,
              "review": review,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> orderSwapApi(id, bike_id, swap_bike_id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.swapBike,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "order_id": id,
              "bike_id": bike_id,
              "swap_bike_id": swap_bike_id
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<SwapBikeListingResponse?> orderSwapListApi(id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.swapBikeListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"id": id},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return SwapBikeListingResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CancelModal?> orderCancelApi(order_id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderCancel,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"order_id": order_id},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CancelModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> orderUnlockApi(
      order_id, bike_id, order_details_id, is_lock) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderUnlock,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "order_id": order_id,
              "bike_id": bike_id,
              "order_details_id": order_details_id,
              "is_lock": is_lock,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> orderCompleteApi(order_id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderComplete,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"order_id": order_id},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> shareOrderUnlockApi(
      order_id, bike_id, share_id, is_lock) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.shareOrderUnlock,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "order_id": order_id,
              "share_id": share_id,
              "bike_id": bike_id,
              "is_lock": is_lock,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> orderExtendApi(order_id, check_out_date) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderExtend,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"order_id": order_id, "check_out_date": check_out_date},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ParkingSpotsListResponse?> parkingSportListApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.parkingSportListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "lat": spPreferences.getString(SpUtil.USER_LAT),
              "lang": spPreferences.getString(SpUtil.USER_LANG),
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ParkingSpotsListResponse.fromJson(data);

        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddedBikesListListResponse?> addBikeListingApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.get(
            WebAPIConstant.addBikeListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddedBikesListListResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }
  Future<AddedBikesListListResponse?> addedBikeListingApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.get(
            WebAPIConstant.addedBikeListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddedBikesListListResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }


  Future<AllCategory?> addAllCategoryApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.allcatgeoryList,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
              spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AllCategory.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ProductCategory?> addCategoryApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.catgeoryList,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
              spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ProductCategory.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<SubCategory?> subCategoryApi(String? categoryId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.subcategory,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
              spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "category_id" : categoryId
            }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return SubCategory.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AllSubcategoryResponse?> AllSubCategoryApi(String? categoryId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.allsubcategoryUrl,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "category_id" : categoryId
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AllSubcategoryResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddRemoveWishlistResponse?> addremovewishlistApi(String? productId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.addremovewishlistUrl,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "product_id" : productId
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddRemoveWishlistResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }


  Future<LocationListModal?> listLocationApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.loctionList,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {}
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return LocationListModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> addToCartApi(String? productId,int? qty,String? addressId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.addCartRemove,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "product_id" : productId,
                "qty" : qty,
                "address_id" : addressId
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }



  Future<CommonResponse?> checkOutApi(String? cartId,String? refNo,String?transactionNo,String? addressId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.checkOutUrl,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "cart_id" : cartId,
                "ref_no" : refNo,
                "address_id" : addressId,
                "transaction_no" : transactionNo
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }


  Future<CommonResponse?> clearCartApi(int? cartDetailId,int? cartId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.clearCart,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "cart_detail_id" : cartDetailId,
                "cart_id" : cartId,
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }





  Future<CommonResponse?> applyRemoveCouponApi(String? discountCode,int? cartId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.applyRemoveCuppon,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "discount_code" : discountCode,
                "cart_id" : cartId,
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddCartModal?> getCartApi(String? addressId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.getCart,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "address_id" : addressId
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddCartModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }



  Future<ProductList?> productlstApi(categoryId,subcategoryId,page,limit,sortAlpha,sortprice,price,varient,search) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.producturl,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
              spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "category_id" : categoryId,
              "sub_category_id" : subcategoryId,
              "limit" : limit,
              "page" : page,
              "sortAlpha" : sortAlpha,
              "sortPrice" : sortprice,
              "price" : price,
              "variant":varient,
              "search":search
            }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ProductList.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }


  Future<OrderListingResponse?> orderListingApi(page,limit,type) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.orderListingUrl,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "limit" : limit,
                "page" : page,
                "type" : type,
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return OrderListingResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> reOrderApi(orderId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.reOrder,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "order_id" : orderId,
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }


  Future<OrderDetailsModal?> orderDetailsApi(orderId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.orderDetails,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "order_id" : orderId,
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return OrderDetailsModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> orderRatingReviewApi(orderId,review,rating) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.orderReview,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "order_id" : orderId,
                "review": review,
                "rating": rating
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> orderCancelledApi(orderId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.orderCancelled,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "order_id" : orderId,
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }



  Future<VariantsResponse?> variantApi(categoryId,subcategoryId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.varianturl,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "category_id" : categoryId,
                "sub_category_id" : subcategoryId,

              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return VariantsResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ProductDetailModal?> productdetailsApi(product_id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.productdetailsurl,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),
              data: {
                "product_id" : product_id,
              }
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ProductDetailModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }
  Future<WishlistResponse?> wishlistApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
              WebAPIConstant.wishlistUrl,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'Authorization': 'Bearer $token',
              }),

          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return WishlistResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }


  Future<CommonResponse?> deleteBikeApi(bikeId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.deleteBike,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"bike_id": bikeId},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CreateOrderResponse?> orderCreateApi(
    String type,
    String arrayCounters,
    String parking_spot_id,
    String bike_id,
    String check_in_date,
    String check_out_date,
    String transaction_id,
    String total_amount,
    String orderId,
      String paymentResponse,
  ) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderCreate,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "parking_spot_id": parking_spot_id,
              "bike_id": bike_id,
              "check_in_date": check_in_date,
              "check_out_date": check_out_date,
              "transaction_id": transaction_id,
              "total_amount": total_amount,
              "type": type,
              "locker_no": arrayCounters,
              "order_id": orderId,
              "paymentResponse": paymentResponse,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CreateOrderResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> orderEditApi(

    String orderId,
    String bike_id,
    String check_in_date,
    String check_out_date,

  ) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderEdit,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "bike_id": bike_id,
              "check_in_date": check_in_date,
              "check_out_date": check_out_date,
              "order_id": orderId,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CartListResponse?> cartListApi(
      String parking_spot_id,
      String locker_no,
      String bike_id,
      String check_in_date,
      String check_out_date,
      String type,
      var couponId,
      var orrder_id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.cartList,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "parking_spot_id": parking_spot_id,
              "bike_id": bike_id,
              "locker_no": locker_no,
              "check_in_date": check_in_date,
              "check_out_date": check_out_date,
              "coupon_id": couponId ?? "",
              "order_id": orrder_id,
              "type": type,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CartListResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CheckSpotAvailabilityResponse?> checkSpotAvailabilityApi(
      String spotId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderAvailability,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "parking_spot_id": spotId,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CheckSpotAvailabilityResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<FindSpotsListResponse?> getFindSpot(
    String spotId,
    String bike_id,
    String check_in_date,
    String check_out_date,
  ) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.orderBikeAvailability,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {
              "parking_spot_id": spotId,
              "bike_id": bike_id,
              "check_in_date": check_in_date,
              "check_out_date": check_out_date,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return FindSpotsListResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<NotificationListResponse?> notificationListingApi() async {
    try {
      token = spPreferences.getString(SpUtil.ACCESS_TOKEN) ?? "";
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.get(
            WebAPIConstant.notificationListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return NotificationListResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> notificationReadApi(String notificationId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.notificationsStatusUpdate,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"notification_id": notificationId},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> notificationUnReadApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.get(
            WebAPIConstant.notificationsUnRead,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> notificationDeleteApi(String notificationId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.notificationsDelete,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
            data: {"notification_id": notificationId},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ParkingSpotsDetailsResponse?> parkingSportDetailsApi(
      String soptId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            (spPreferences.getBool(SpUtil.IS_GUEST) ?? false)
                ? WebAPIConstant.parkingSportGuestDetails
                : WebAPIConstant.parkingSportDetails,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
              'language': spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
            data: {
              "parking_sport_id": soptId,
              "lat": spPreferences.getString(SpUtil.USER_LAT),
              "lang": spPreferences.getString(SpUtil.USER_LANG),
            },
          );
          // Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ParkingSpotsDetailsResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<NotifySpotsResponse?> putMeNotifyApi(String parking_spot_id,
      String bike_id, String check_in_date, String check_out_date) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.putMeNotify,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
            data: {
              "parking_spot_id": parking_spot_id,
              "bike_id": bike_id,
              "check_in_date": check_in_date,
              "check_out_date": check_out_date
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return NotifySpotsResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<NextAvailability?> nextDateAvailability(String parking_spot_id, String check_in_date) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.nextAvailability,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "Accept-Language": spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
            data: {
              "parking_spot_id": parking_spot_id,
              "check_in_date": check_in_date,
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return NextAvailability.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CouponListResponse?> couponListApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.get(
            WebAPIConstant.couponList,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CouponListResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ShareBikeDetailsResponse?> shareDetailsApi(shareId, context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.shareDetails,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
            data: {
              "shareId": shareId,
              "lat": spPreferences.getString(SpUtil.USER_LAT) ?? "0",
              "lang": spPreferences.getString(SpUtil.USER_LANG) ?? "0",
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ShareBikeDetailsResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      //Dialogs().internetConnetctionDialog(context);
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ApplyCouponResponse?> applyCouponApi(name) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.applyCoupon,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
            data: {"name": name},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ApplyCouponResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<CommonResponse?> sendFeedbackApi(message) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.sendFeedback,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
            data: {"message": message},
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<LogoutResponse?> logoutApi() async {
    Logger.msg("token from logout" + token);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.logout);
        try {
          Response response = await _dio.get(
            WebAPIConstant.logout,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return LogoutResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ProfileResponse?> getProfileApis() async {
    try {
      token = spPreferences.getString(SpUtil.ACCESS_TOKEN) ?? "";
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.get(
            WebAPIConstant.getProfile,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
          );
          Logger.msg("token : ${token}");
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ProfileResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<TermsConditionsResponse?> termsConditionsApi() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    Logger.msg("token from terms" + token);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.termsConditions);
        try {
          Response response = await _dio.get(
            WebAPIConstant.termsConditions,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'authorization': basicAuth
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return TermsConditionsResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<HowItWorksResponse?> howItWorksApi() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    Logger.msg("token from terms" + token);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.termsConditions);
        try {
          Response response = await _dio.get(
            WebAPIConstant.howItWorks,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'authorization': basicAuth
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return HowItWorksResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<PrivacyPolicyResponse?> privacyPolicyApi() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    Logger.msg("token from terms" + token);
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.privacyPolicy);
        try {
          Response response = await _dio.get(
            WebAPIConstant.privacyPolicy,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'authorization': basicAuth
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return PrivacyPolicyResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AccessoriesResponse?> accessoriesApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.accessoriesListing);
        try {
          Response response = await _dio.get(
            WebAPIConstant.accessoriesListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AccessoriesResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<PartsResponse?> partsApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.partsListing);
        try {
          Response response = await _dio.get(
            WebAPIConstant.partsListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token'
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return PartsResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<BikeSizeResponse?> bikeSizeApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.bikeSizeListing);
        try {
          Response response = await _dio.get(
            WebAPIConstant.bikeSizeListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token'
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return BikeSizeResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<BikeBrandResponse?> bikeBrandApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.bikeBrandListing);
        try {
          Response response = await _dio.get(
            WebAPIConstant.bikeBrandListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token'
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return BikeBrandResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<BikeTypeResponse?> bikeTypeApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.bikeTypeListing);
        try {
          Response response = await _dio.get(
            WebAPIConstant.bikeTypeListing,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token'
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return BikeTypeResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddBikeResponse?> addBikeApi(
      {required String bikeName,
      required int bikeTypeId,
      required String bikeValue,
      required String ownerType,
      required String name,
      required String countryCode,
      required String phone,
      required String driverHeight,
      required String heightType,
      required String accessoriesId,
      required String partId,
      required int bikeSizeId,
      required String brand_id,
      required String? model,
      required String? brand,
      required var image,
      required var bike_image}) async {
    var formData = FormData.fromMap({
      'bike_name': bikeName,
      'brand_id': brand_id,
      'bike_type_id': bikeTypeId,
      'brand': brand,
      'bike_value': bikeValue,
      'owner_type': ownerType,
      'name': name,
      'model': model,
      'country_code': countryCode,
      'phone': phone,
      'driver_height': driverHeight,
      'height_type': heightType,
      'accessories_id': accessoriesId,
      'part_id': partId,
      'bike_size_id': bikeSizeId,
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.path)
          : "",
      'bike_image': bike_image != null
          ? await MultipartFile.fromFile(bike_image.path,
              filename: bike_image.path)
          : ""
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.addBike);
        try {
          Response response = await _dio.post(
            WebAPIConstant.addBike,
            options: Options(headers: <String, String>{
              "Accept": "application/json",
              'Authorization': 'Bearer $token'
            }),
            data: formData,
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddBikeResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddBikeResponse?> addAccessoriesApi({
    required String accessoriesId,
    required String description,
    required String model,
    required String brand,
    required String year,
    required var image,
    required String value,
  }) async {
    var formData = FormData.fromMap({
      'accessories_id': accessoriesId,
      'description': description,
      'model': model,
      'brand': brand,
      'bike_value': value,
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.path)
          : "",
      'year': year,
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.addBike);
        try {
          Response response = await _dio.post(
            WebAPIConstant.addAccessories,
            options: Options(headers: <String, String>{
              "Accept": "application/json",
              'Authorization': 'Bearer $token'
            }),
            data: formData,
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddBikeResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }
  Future<AddBikeResponse?> addPartsApi({
    required String partId,
    required String description,
    required String model,
    required String brand,
    required String year,
    required var image,
    required String value,
  }) async {
    var formData = FormData.fromMap({
      'part_id': partId,
      'description': description,
      'model': model,
      'brand': brand,
      'bike_value': value,
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.path)
          : "",
      'year': year,
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.addBike);
        try {
          Response response = await _dio.post(
            WebAPIConstant.addParts,
            options: Options(headers: <String, String>{
              "Accept": "application/json",
              'Authorization': 'Bearer $token'
            }),
            data: formData,
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddBikeResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddBikeResponse?> updateBikeApi(
      {required String bikeName,
      required String bikeTypeId,
      required String bikeValue,
      required String ownerType,
      required String name,
      required String bikeId,
      required String countryCode,
      required String phone,
      required String brand,
      required String driverHeight,
      required String heightType,
      required String accessoriesId,
      required String partId,
      required String? model,
      required String brand_id,
      required String bikeSizeId,
      required var image,
      required var bike_image}) async {
    var formData = FormData.fromMap({
      'bike_name': bikeName,
      'brand_id': brand_id,
      'bike_type_id': bikeTypeId,
      'bike_value': bikeValue,
      'owner_type': ownerType,
      'name': name,
      'bike_id': bikeId,
      'model': model,
      'country_code': countryCode,
      'phone': phone,
      'driver_height': driverHeight,
      'height_type': heightType,
      'accessories_id': accessoriesId,
      'part_id': partId,
      'brand': brand,
      'bike_size_id': bikeSizeId,
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.path)
          : "",
      'bike_image': bike_image != null
          ? await MultipartFile.fromFile(bike_image.path,
              filename: bike_image.path)
          : ""
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.editBike);
        try {
          Response response = await _dio.post(
            WebAPIConstant.editBike,
            options: Options(headers: <String, String>{
              "Accept": "application/json",
              'Authorization': 'Bearer $token'
            }),
            data: formData,
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddBikeResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddBikeResponse?> updateAccessoriesApi({
    required String accessoriesId,
    required String bikeId,
    required String description,
    required String model,
    required String brand,
    required String year,
    required var image,
    required String value,
  }) async {
    var formData = FormData.fromMap({
      'accessories_id': accessoriesId,
      'bike_id': bikeId,
      'description': description,
      'model': model,
      'brand': brand,
      'bike_value': value,
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.path)
          : "",
      'year': year,
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.editAccessories);
        try {
          Response response = await _dio.post(
            WebAPIConstant.editAccessories,
            options: Options(headers: <String, String>{
              "Accept": "application/json",
              'Authorization': 'Bearer $token'
            }),
            data: formData,
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddBikeResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }
  Future<AddBikeResponse?> updatePartsApi({
    required String bikeId,
    required String partId,
    required String description,
    required String model,
    required String brand,
    required String year,
    required var image,
    required String value,
  }) async {
    var formData = FormData.fromMap({
      'bike_id': bikeId,
      'part_id': partId,
      'description': description,
      'model': model,
      'brand': brand,
      'bike_value': value,
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.path)
          : "",
      'year': year,
    });
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.editAccessories);
        try {
          Response response = await _dio.post(
            WebAPIConstant.editParts,
            options: Options(headers: <String, String>{
              "Accept": "application/json",
              'Authorization': 'Bearer $token'
            }),
            data: formData,
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddBikeResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ProfileResponse?> updateProfileApi(
      {required String dob,
      required String gender,
      required String name,
      required String height,
      required String heightType,
      required String email,
      required String image}) async {
    var formData = FormData.fromMap({
      'dob': dob,
      'gender': gender,
      'name': name,
      'email': email,
      'height': height,
      'height_type': heightType,
      'image': image.isEmpty
          ? ""
          : await MultipartFile.fromFile(image, filename: image)
    });
    print("formData >>>>>>  ${image}");
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.updateProfile,
            options: Options(headers: <String, String>{
              'Authorization': 'Bearer $token',
            }),
            data: formData,
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ProfileResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ResetPasswordResponse?> resetPasswordApi(
      {required String newPassword,
      required String confirmPassword,
      required String phone,
      required String countryCode}) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Logger.msg(BASE_URL + WebAPIConstant.resetPass);
        try {
          Response response = await _dio.post(WebAPIConstant.resetPass,
              options: Options(headers: <String, String>{
                "Content-Type": "application/json",
                "Accept-Language":
                    spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
                'authorization': basicAuth
              }),
              data: {
                "new_password": confirmPassword,
                "conf_password": confirmPassword,
                "phone": phone,
                "country_code": countryCode
              });
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ResetPasswordResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ResendOtpResponse?> resendOtpApi(
      {required String countryCode,
      required String phone,
      required String userType}) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$authUsername:$authPassword'));
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.resendOtp,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'authorization': basicAuth
            }),
            data: {
              "phone": phone,
              "country_code": countryCode,
              "user_type": userType,
              "user_id": spPreferences.getString(SpUtil.USER_ID)
            },
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ResendOtpResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ServiceResponse?> servicesApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.services,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language": spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ServiceResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<ServiceResponse?> otherServicesApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.othersServices,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return ServiceResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddPreferenceResponse?> addPreference(String preferenceIds) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.addPreferences,
            data: {
              "preference_id": preferenceIds,
            },
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language":
                  spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddPreferenceResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }


Future<CommonResponse?> changeLanguage() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.changeLanguage,
            data: {
              "language": spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
            },
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language": spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return CommonResponse.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddressModal?> addUpdateAddressApi(addressId, body) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            addressId == "" ? WebAPIConstant.addAddress : WebAPIConstant.updateAddress,
            data: body,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language": spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddressModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddressListModal?> getAddressApi(body) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            WebAPIConstant.getAddress,
            data: body,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language": spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddressListModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<AddressModal?> commonApi(apiName, body) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          Response response = await _dio.post(
            apiName,
            data: body,
            options: Options(headers: <String, String>{
              "Content-Type": "application/json",
              "Accept-Language": spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en",
              'Authorization': 'Bearer $token',
            }),
          );
          Logger.msg("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return AddressModal.fromJson(data);
        } catch (error, stacktrace) {
          Logger.msg("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      Logger.msg('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }
}
