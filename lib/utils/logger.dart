import 'dart:convert';
import 'dart:developer' as developer;

// Logger for the application
mixin Logger {
  void log(Object object, [StackTrace? s]) {
    try {
      if (s != null) {
        Log.er("${this.runtimeType}", object, s);
      } else {
        Log.e("${this.runtimeType}", object);
      }
    } catch (e, s) {
      logger("AppLogHelper", e);
      logger("AppLogHelper", s);
    }
  }

  static void logger(String tag, Object object, [StackTrace? s]) {
    if (s != null) {
      Log.er("$tag", object, s);
    } else {
      Log.e("$tag", object);
    }
  }

  static void msg(String msg) {
    developer.log(msg, name: 'mobile controller');
  }

  static void printObject(Object object) {
    developer.log('', name: 'mobile controller', error: jsonEncode(msg));
  }

  static void msgWithTag(String msg, String tag) {
    developer.log(msg, name: tag);
  }
}

class Log {
  static e(String tag, Object msg) {
    developer.log('', name: 'mobile controller', error: jsonEncode(msg));
  }

  static er(String tag, Object msg, Object obj) {
    developer.log(jsonEncode(msg), name: tag, error: jsonEncode(obj));
  }

  static err(String tag, String msg, Object obj) {
    developer.log(jsonEncode(msg), name: tag, error: jsonEncode(obj));
  }
}
