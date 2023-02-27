import 'dart:io';

import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/service_response.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/main/my_booking_main_screen.dart';
import 'package:cycle_lock/ui/main/parking_spots_screen.dart';
import 'package:cycle_lock/ui/onboarding/bike_detail_screen.dart';
import 'package:cycle_lock/ui/onboarding/components/header.dart';
import 'package:cycle_lock/ui/widgets/bottom_nav_bar.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/shared_preferences.dart';
import '../../utils/strings.dart';
import '../main/other_service_Screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  Future<bool> onWillPop() {
    showAlertDialog(context);
    return Future.value(false);
  }

  showAlertDialog(BuildContext context) {
    Dialogs().confirmationDialog(context, message: "AreYouExit".tr(),
        onContinue: () {
      exit(0);
    });
  }

  @override
  void initState() {
    serviceApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        // bottomNavigationBar: BottomNavBar(),
        body: Column(
          children: [
            OnBoardingHeader(
                heading: "selectServices".tr(),
                isSkip: true,
                isBackNav: false,
                onSkip: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashBoardScreen()),
                      (route) => false);
                }),
            Expanded(
              child: isLoading
                  ? Loader.load()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      shrinkWrap: true,
                      itemCount: data.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            spPreferences.setString(SpUtil.SERVICE_ID,
                                data.data?[index].id.toString() ?? "");
                            if (data.data?[index].id.toString() == "1") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ParkingSpotsScreen()));
                            }
                            if (data.data?[index].id.toString() == "2") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyBookingScreen(
                                          type: 1,
                                          isUnlock: false,
                                          isBarShow: true)));
                            }
                            if (data.data?[index].id.toString() == "3") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OthersServiceScreen()));
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                    (data.data?[index].imageUrl ?? "") +
                                        "/" +
                                        (data.data?[index].image ?? ""),
                                    height: 100,
                                    color: Colors.white),
                                const SizedBox(height: 20),
                                Text(
                                  data.data?[index].name ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: ts30,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Apis apis = Apis();
  ServiceResponse data = ServiceResponse();
  bool isLoading = true;

  serviceApi() async {
    await apis.servicesApi().then((value) {
      if (value?.status ?? false) {
        data = value!;
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
      setState(() {
        isLoading = false;
      });
    });
  }
}
