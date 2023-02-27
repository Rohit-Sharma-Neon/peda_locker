// @dart=2.9
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:cycle_lock/providers/address_provider.dart';
import 'package:cycle_lock/providers/product_detail_provider.dart';
import 'package:cycle_lock/providers/bike_listing_provider.dart';
import 'package:cycle_lock/providers/notification_provider.dart';
import 'package:cycle_lock/providers/timer_provider.dart';
import 'package:cycle_lock/ui/onboarding/splash_screen.dart';
import 'package:cycle_lock/ui/widgets/bottom_nav_bar.dart';
import 'package:cycle_lock/utils/contextnavigation.dart';
import 'package:cycle_lock/utils/date_pick_custom.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import "package:easy_localization/easy_localization.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'providers/user_data_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

SharedPreferences spPreferences;
//FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
AndroidNotificationChannel channel;
NotificationProvider mainNotificationProvider;

/*Future<void> setup() async {
  await tz.initializeTimeZone();
  var detroit = tz.getLocation('America/Detroit');
  tz.setLocalLocation(detroit);
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  // Print TTLock Log
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  spPreferences = await SharedPreferences.getInstance();
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  channel = const AndroidNotificationChannel(
    'default_notification_channel_id', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("en", "US"),
        Locale("ar", "DZ"),
      ],
      path: "assets/appLanguage",
      fallbackLocale: const Locale("en", "US"),
      child: const MyApp(),
    ),
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setupFirebase();
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (mounted) {
      FlutterNativeSplash.remove();
    }

    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Allow Notifications'),
              content:
                  const Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: const Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
    AwesomeNotifications().initialize(null, // icon for your app notification
        [
          NotificationChannel(
              channelKey: 'key1',
              channelName: 'Proto Coders Point',
              channelDescription: "Notification example",
              defaultColor: const Color(0XFF9050DD),
              ledColor: Colors.white,
              playSound: true,
              enableLights: true,
              enableVibration: true)
        ]);
    super.initState();
  }

  setupFirebase() async {
    FirebaseMessaging.instance.getToken().then((String token) {
      assert(token != null);
      print("FCM token ==================> " + token);
      Platform.isAndroid
          ? spPreferences.setString(SpUtil.DEVICE_TYPE, "Android")
          : spPreferences.setString(SpUtil.DEVICE_TYPE, "IOS");

      spPreferences.setString(SpUtil.FCM_TOKEN, token.toString());
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;

      var type = message.data['type'];
      if (type.toString() == "5") {
        print("onMessage Data  ====>  " + message.data.toString());
        showImageNotification(message.data);
      } else {
        print("slkdjdhjdsgf title >>>>> ${notification.title}");
        print("slkdjdhjdsgf body >>>>> ${notification.body}");
        showLocalNotification(
            notification.title, notification.body, notification.hashCode);
      }
      // print("onMessage Type  ====>  " +
      //     message.data['type'].runtimeType.toString());
      // print("onMessage Campaign Id  ====>  " + message.data['campaign_id']);
      // print("onMessage Campaign Id  ====>  " +
      //     message.data['campaign_id'].runtimeType.toString());
      mainNotificationProvider.readIncrement();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      print("onMessage Data  ====>  " + message.data.toString().toString());

      var type = message.data['type'];
      if (type.toString() == "5") {
        showImageNotification(message.data);
      } else {
        showLocalNotification(
            notification.title, notification.body, notification.hashCode);
      }

      mainNotificationProvider.readIncrement();
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        RemoteNotification notification = message.notification;
        print("onMessage Data  ====>  " + message.data.toString().toString());

        var type = message.data['type'];
        if (type.toString() == "5") {
          showImageNotification(message.data);
        } else {
          showLocalNotification(
              notification.title, notification.body, notification.hashCode);
        }

        mainNotificationProvider.readIncrement();
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  showImageNotification(data) async {
    print("onMessage Data  ====>  " + data['image'].toString().toString());
    print("onMessage Data  ====>  " + data['body'].toString().toString());
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: data['title'].toString(),
          body: data['body'].toString(),
          bigPicture: data['image'].toString(),
          notificationLayout: NotificationLayout.BigPicture),
    );
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserDataProvider(),),
        ChangeNotifierProvider(create: (ctx) => AddressProvider(),),

        ChangeNotifierProvider(
          create: (ctx) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BikeListingProvider(),
        ),

        ChangeNotifierProvider(
          create: (ctx) => ProductDetailProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TimerProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Pedalocker',
        navigatorKey: NavigationService.navigatorKey,
        supportedLocales: context.supportedLocales,
       // localizationsDelegates: context.localizationDelegates,
        localizationsDelegates: [
          CountryLocalizations.delegate,
          EasyLocalization.of(context).delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: context.locale,
        useInheritedMediaQuery: true,
//        locale: DevicePreview.locale(context),
        debugShowCheckedModeBanner: false,
        builder: (context, widget) => ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget),
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.autoScale(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
          ],
          background: Container(color: Colors.white),
        ),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Dubai",
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          }),
        ),
        home: const SplashScreen(),
        // home: BottomNavBar(),
      ),
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  showLocalNotification(title, message, id) async {
    flutterLocalNotificationsPlugin.show(
      hashCode,
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelShowBadge: true,
          //largeIcon: FilePathAndroidBitmap(largeIconPath),
          icon: 'launch_background',
        ),
      ),
    );
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    RemoteNotification notification = message.notification;
    var type = message.data['type'];
    if (type.toString() == "5") {
      showImageNotification(message.data);
    } else {
      showLocalNotification(
          notification.title, notification.body, notification.hashCode);
    }
    // print("onMessage Type  ====>  " +
    //     message.data['type'].runtimeType.toString());
    // print("onMessage Campaign Id  ====>  " + message.data['campaign_id']);
    // print("onMessage Campaign Id  ====>  " +
    //     message.data['campaign_id'].runtimeType.toString());
    mainNotificationProvider.readIncrement();
    print("MessagingBackgroundHandler  ====>  " + message.data.toString());
    print("type MessagingBackgroundHandler ====>  " +
        message.data['type'].toString());
  }
}
