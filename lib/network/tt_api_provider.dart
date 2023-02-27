import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/webapi_constaint.dart';
import 'package:cycle_lock/responses/accessories_response.dart';
import 'package:cycle_lock/responses/add_bike_response.dart';
import 'package:cycle_lock/responses/bike_size_response.dart';
import 'package:cycle_lock/responses/bike_type_response.dart';
import 'package:cycle_lock/responses/change_password_response.dart';
import 'package:cycle_lock/responses/login_response.dart';
import 'package:cycle_lock/responses/logout_response.dart';
import 'package:cycle_lock/responses/parts_response.dart';
import 'package:cycle_lock/responses/privacy_policy_response.dart';
import 'package:cycle_lock/responses/resend_otp_response.dart';
import 'package:cycle_lock/responses/reset_password_response.dart';
import 'package:cycle_lock/responses/send_otp_response.dart';
import 'package:cycle_lock/responses/service_response.dart';
import 'package:cycle_lock/responses/terms_conditions_response.dart';
import 'package:cycle_lock/responses/tt_lock_reponse/tt_register_response.dart';
import 'package:cycle_lock/responses/update_profile_response.dart';
import 'package:cycle_lock/responses/verify_otp_response.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../responses/added_bike_list_response.dart';
import '../responses/chec_spo_availability_response.dart';
import '../responses/comman_response.dart';
import '../responses/find_spots_list_response.dart';
import '../responses/get_profile_response.dart';
import '../responses/home_page_response.dart';
import '../responses/notification_list_response.dart';
import '../responses/orders_list_response.dart';
import '../responses/parking_list_response.dart';
import '../responses/parking_spots_details_response.dart';
import '../responses/preference_response.dart';
import '../responses/profile_response.dart';
import '../responses/share_data_response.dart';
import '../responses/swap_bike_list_response.dart';

class TTApis {
  Dio _dio = Dio();
  static const String BASE_URL = "https://api.ttlock.com/";
  String token = "";
  String clientId = 'cb612ad2df7e4b988cf11de74f948143';
  String clientSecret = '855cd9bd67580069bb701e6a71c0fd6c';

  TTApis() {
    _dio.options.contentType = Headers.formUrlEncodedContentType;
    token = spPreferences.getString(SpUtil.ACCESS_TOKEN) ?? "";
    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      headers: {"token": token, "Authorization": "Bearer $token"},
      receiveTimeout: 30000,
      connectTimeout: 30000,
      contentType: Headers.formUrlEncodedContentType,
      followRedirects: false,
      validateStatus: (status) {
        return status! <= 500;
      },
    );
    print("var " + token);
    print(token.toString());
    _dio = Dio(options);
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestBody: true,
        responseHeader: false,
        requestHeader: true,
        logPrint: (object) => print(object.toString()),
        request: false,
      ),
    );
  }

  Future<RegisterResponse?> registerApi({required String userName,required String password,required String date}) async {
    var md5 = crypto.md5;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print(BASE_URL + WebAPIConstant.ttRegister);
        try {
          Response response = await _dio.post(
            WebAPIConstant.ttRegister,
            options: Options(headers: <String, String>{
              "Content-Type": "application/x-www-form-urlencoded",
            }),
            data: {
              'clientId': clientId,
              'clientSecret': clientSecret,
              'username': md5.convert(utf8.encode(userName)).toString(),
              'password': md5.convert(utf8.encode(password)).toString(),
              'date': md5.convert(utf8.encode(date)).toString(),
            },
          );
          print("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);

          return RegisterResponse.fromJson(data);
        } catch (error, stacktrace) {
          print("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }

  Future<RegisterResponse?> authTokenApi({required String userName,required String password,required String date}) async {
    var md5 = crypto.md5;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print(BASE_URL + WebAPIConstant.ttRegister);
        try {
          Response response = await _dio.post(
            WebAPIConstant.ttRegister,
            options: Options(headers: <String, String>{
              "Content-Type": "application/x-www-form-urlencoded",
            }),
            data: {
              'clientId': clientId,
              'clientSecret': clientSecret,
              'username': md5.convert(utf8.encode(userName)).toString(),
              'password': md5.convert(utf8.encode(password)).toString(),
              'date': md5.convert(utf8.encode(date)).toString(),
            },
          );
          print("data : ${response.data}");
          final Map<String, dynamic> data = json.decode(response.data);
          return RegisterResponse.fromJson(data);
        } catch (error, stacktrace) {
          print("Exception occured: $error stackTrace: $stacktrace");
          return null;
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      Fluttertoast.showToast(msg: "No Internet Connection!!");
    }
    return null;
  }
}
