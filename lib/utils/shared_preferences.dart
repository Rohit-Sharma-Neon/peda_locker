import 'dart:async';

import 'package:cycle_lock/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  static const String USER_ID = 'user_id';
  static const String USER_LANGUAGE = 'en';
  static const String ACCESS_TOKEN = 'access_token';
  static const String NOTIFICATION_COUNT = 'notification_count';
  static const String FCM_TOKEN = 'fcm_token';
  static const String DEVICE_TYPE = 'device_type';
  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String SERVICE_ID = 'service_id';
  static const String PREFERENCES_ID = 'preference_id';
  static const String PREFERENCES_NAMES = 'preference_names';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String MOBILE = 'mobile';
  static const String PROFILE_DATA = 'profile_data';
  static const String USER_LAT = 'user_lat';
  static const String USER_LANG = 'user_lang';
  static const String APP_VERSION = 'app_version';
  static const String REMEMBER_ME = 'remember_me';
  static const String SP_PHONE = 'sp_phone';
  static const String SP_PASSWORD = 'sp_password';
  static const String TT_USERNAME = 'tt_username';
  static const String TT_PASSWORD = 'tt_password';
  static const String IS_GUEST = 'is_guest';

  clearUserData() {
    spPreferences.remove(USER_ID);
    spPreferences.remove(IS_LOGGED_IN);
    spPreferences.remove(ACCESS_TOKEN);
    spPreferences.remove(SERVICE_ID);
    spPreferences.remove(PREFERENCES_ID);
    spPreferences.remove(PROFILE_DATA);
    spPreferences.remove(APP_VERSION);
    spPreferences.remove(TT_USERNAME);
    spPreferences.remove(TT_PASSWORD);
  }
}
