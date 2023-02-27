import 'dart:io';

import 'package:cycle_lock/ui/onboarding/tutorial_screen.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cycle_lock/ui/widgets/primary_button.dart';
import 'package:cycle_lock/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/onboarding/bike_detail_screen.dart';
import 'images.dart';
class Dialogs {
  errorDialog(BuildContext context,
      {required String title, String? secondTitle, bool navLogin = false, Function()? onTap}) {
    !navLogin
        ?
    showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Pedalocker",
                                style: TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500))),
                          ],
                        ),
                        InkWell(
                          onTap: onTap ??
                              () {
                                Navigator.pop(context);
                                if (navLogin) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TutorialScreen()),
                                      (route) => false);
                                }
                              },
                          child: Container(
                            margin: const EdgeInsets.only(top: 25),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: primaryDark2,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text("Ok".tr(),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                      ],
                    )),
              );
            },
          )
        :
    showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // title: const Text("Error!", style: TextStyle(fontSize: 28)),
                content:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Image.asset(
                        pedaLogo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(secondTitle??"createAnAccount".tr(),
                        style: const TextStyle(fontSize: 30),
                        textAlign: TextAlign.center),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 5),
                    child: PrimaryButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (navLogin) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TutorialScreen()),
                                (route) => false);
                          }
                        },
                        title:
                        Text("createAccountOr".tr(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500))),
                  ),
                ],
              );
            },
          );
  }

  confirmationDialog(context,
      {String? message,
      Function()? onContinue,
      Function()? onCancel,
      bool disableCancel = false}) {
    Widget cancelButton = InkWell(
      onTap: onCancel ??
          () {
            Navigator.pop(context);
          },
      child: Container(
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: lightGreyColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text("No".tr(),
            style: const TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );

    //"Cancel".tr(),
    Widget continueButton = InkWell(
      onTap: onContinue,
      child: Container(
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: primaryDark2,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text("Yes".tr(),
            style: const TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );

    Dialog alert = Dialog(
      backgroundColor: Colors.transparent,
      // contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Alert".tr(),
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Text(message ?? "",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  disableCancel ? const SizedBox() : cancelButton,
                  SizedBox(width: 10),
                  continueButton,
                ],
              ),
            ],
          )),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  internetConnetctionDialog(context) {
    //"Cancel".tr(),
    Widget okButton = InkWell(
      onTap:() {
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 25),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: primaryDark2,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text("OK".tr(),
              style: const TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );

    Dialog alert = Dialog(
      backgroundColor: Colors.transparent,
      // contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      child:
      Container(
          height: 500,
          margin: EdgeInsets.symmetric(horizontal: 50),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Lottie.asset(
                  'assets/nointernet.json',
                  repeat: false,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 20),
              okButton
            ],
          )),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  appRedirectDialog1(BuildContext context,) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child:AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Pedalocker",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text( "underDevelopment1".tr(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500))),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      GestureDetector(
                        onTap: (){
                          _launchWhatsapp();
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryDark2,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("Yes".tr(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryDark2,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("No".tr(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                        ),
                      ),


                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
showLoader(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const WillPopScope(
        onWillPop: _onWillPop,
        child: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
        ),
      );
    },
  );
}

appDialog(BuildContext context, String message) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        // title:  Text(AppStrings.appTitle,
        //     style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:blackColor, // background
                onPrimary: whiteColor, // foreground
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK')),
          /*  TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'))*/
        ],
      ),
    ),
  );
}




appRedirectDialog(BuildContext context, String message,
    {VoidCallback? onPressed}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        // title:  Text(AppStrings.appTitle,
        //     style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600)),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:blackColor, // background
                onPrimary: whiteColor, // foreground
              ),
              onPressed: onPressed ?? () {
                Navigator.of(context).pop();
              },
              child: const Text('OK')),
          /*  TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'))*/
        ],
      ),
    ),
  );
}


_launchWhatsapp() async {
  var phone = "+971526457953";
  print("Whats App Number ===> " + phone.toString().trim());
  var url = '';

  if (Platform.isAndroid) {
    url = "https://wa.me/$phone/?text=Hello";
  } else {
    url = "https://api.whatsapp.com/send?phone=$phone=Hello";
  }
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<bool> _onWillPop() async {
  return false;
}
