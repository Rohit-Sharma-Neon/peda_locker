import 'dart:async';

import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/main/delete.dart';
import 'package:cycle_lock/ui/onboarding/preference_screen.dart';
import 'package:cycle_lock/ui/onboarding/register_screen.dart';
import 'package:cycle_lock/ui/onboarding/service_Screen.dart';
import 'package:cycle_lock/ui/onboarding/tutorial_screen.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../providers/notification_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../utils/images.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLogin = false;
  late NotificationProvider notificationProvider;

  @override
  void initState() {
    super.initState();
    notificationApi();
    getSession();
    navigate();
    getAppVersion();
  }

  notificationApi() {
    if (spPreferences.getBool(SpUtil.IS_LOGGED_IN) ?? false) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        mainNotificationProvider =
            Provider.of<NotificationProvider>(context, listen: false);
        notificationProvider =
            Provider.of<NotificationProvider>(context, listen: false);
        //notificationProvider.notificationListingApi(context, true);
      });
    }
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    spPreferences.setString(SpUtil.APP_VERSION, /*packageInfo.version*/"1.0.3");
  }

  getSession() async {
    isLogin = spPreferences.getBool(SpUtil.IS_LOGGED_IN) ?? false;
  }

  navigate() {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                isLogin ? const ServiceScreen() : const TutorialScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDark2,
      body: Column(
        children: [
          const Spacer(
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Image.asset(icSplashPedaLogo),
          ),
          const Spacer(
            flex: 1,
          ),
          Image.asset(imgBicycle),
        ],
      ),
    );
  }
}
