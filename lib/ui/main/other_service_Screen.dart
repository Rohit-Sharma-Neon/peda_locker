
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/productModule/ui/dashboard_product.dart';
import 'package:cycle_lock/responses/service_response.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';


class OthersServiceScreen extends StatefulWidget {
  const OthersServiceScreen({Key? key}) : super(key: key);

  @override
  _OthersServiceScreenState createState() => _OthersServiceScreenState();
}

class _OthersServiceScreenState extends State<OthersServiceScreen> {
  Future<bool> onWillPop() {
    //showAlertDialog(context);
    return Future.value(false);
  }

  // showAlertDialog(BuildContext context) {
  //   Dialogs().confirmationDialog(context, message: "AreYouExit".tr(),
  //       onContinue: () {
  //     exit(0);
  //   });
  // }

  @override
  void initState() {
    otherServicesApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavBar(),
      body: Column(
        children: [
          /* OnBoardingHeader(
              heading: "selectOtherServices".tr(),
              isSkip: true,
              isBackNav: false,
              onSkip: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashBoardScreen()),
                    (route) => false);
              }),*/
          customAppbar(),
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
                          if(index == 0){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DashboardProduct()));
                          }else {
                            Dialogs().appRedirectDialog1(context);

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
    );
  }

  Apis apis = Apis();
  ServiceResponse data = ServiceResponse();
  bool isLoading = true;

  otherServicesApi() async {
    await apis.otherServicesApi().then((value) {
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

  customAppbar() {
    return SafeArea(
      child: Container(
          height: 70,
          width: double.infinity,
          color: lightGreyColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
              );
            },
            child:
            Row(mainAxisAlignment:MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  //SvgPicture.asset(backArrow, height: 30),
                  const Icon(Icons.arrow_back_ios_rounded, size: 28,color: Colors.white),
                  const SizedBox(width: 20),
                  Text("selectOtherServices".tr(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: ts22)),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DashBoardScreen()),
                            (route) => false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.home_outlined, size: 40,color:buttonColor),
                  ))
            ]),
          )),
    );
  }
  __launchWhatsapp() async {
    const url = "https://wa.me/?text=Hey buddy, try this super cool new app!";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

  }
}
