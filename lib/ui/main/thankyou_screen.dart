import 'package:cycle_lock/utils/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import 'dashboard_screen.dart';
import 'all_order.dart';

class ThankyouScreen extends StatefulWidget {


  ThankyouScreen({Key? key})
      : super(key: key);

  @override
  _ThankyouScreenState createState() => _ThankyouScreenState();
}

class _ThankyouScreenState extends State<ThankyouScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Container(
            padding: const EdgeInsets.all(0.0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    // Vertically center the widget inside the column
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SvgPicture.asset(thankYou,
                          height: 150, width: 150, color: buttonColor),
                      const SizedBox(height: 50),
                      Text("ThankYou".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: primaryDark,
                            fontWeight: FontWeight.w500,
                            fontSize: ts37,
                          )),
                      const SizedBox(height: 20),
                      Text("YourPaymentDone".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: primaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: ts20,
                          )),
                      const SizedBox(height: 20),
             /*         Text("ORDER ID #${widget.orderId}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: primaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: ts20,
                          )),
                      const SizedBox(height: 20),
                      Text("Container ID #${widget.containerId}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: primaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: ts20,
                          )), const SizedBox(height: 20),*/
                   /*   Text("Locker ID #${widget.lockerNo}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: primaryDark,
                            fontWeight: FontWeight.w400,
                            fontSize: ts20,
                          )),
                      const SizedBox(height: 10),*/
                      Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Container(
                              child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryDark.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: const Offset(-1, 4),
                                    ),
                                  ],
                                ),
                                child: ButtonTheme(
                                  height: MediaQuery.of(context).size.height *
                                      0.070,
                                  minWidth: double.infinity,
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      textColor: Colors.white,
                                      color: primaryDark2,
                                      onPressed: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const DashBoardScreen()),
                                            (route) => false);
                                      },
                                      child: Text('BackToHome'.tr(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: ts22,
                                          ))),
                                ),
                              ),
                            ],
                          ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> onWillPop() {
    showAlertDialog(context);
    return Future.value(false);
  }

  showAlertDialog(BuildContext context) {
    Dialogs().confirmationDialog(context,onContinue: (){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const DashBoardScreen()),
              (Route<dynamic> route) => false);
    },message: "BackToHome".tr(),disableCancel: true,);
  }
}
