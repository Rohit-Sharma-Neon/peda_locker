import 'dart:async';
import 'dart:io' show Platform;
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/network/tt_api_provider.dart';
import 'package:cycle_lock/ui/main/change_password.dart';
import 'package:cycle_lock/ui/main/edit_profile_Screen.dart';
import 'package:cycle_lock/ui/onboarding/components/header.dart';
import 'package:cycle_lock/ui/onboarding/service_Screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/heading_medium.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/ui/widgets/primary_button.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:cycle_lock/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/user_data_provider.dart';
import '../../utils/strings.dart';

class OtpScreen extends StatefulWidget {
  final String? password, name, phone, countryCode, email, userType, preference;

  const OtpScreen(
      {Key? key,
      this.password,
      this.name,
      this.phone,
      this.countryCode,
      this.email,
      required this.userType,
      this.preference})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String os = Platform.operatingSystem;
  Apis apis = Apis();
  bool isLoading = false;
  late UserDataProvider userDataProvider;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    });
    super.initState();
    myFocusNode = FocusNode();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });

    //print(widget.preference);
  }

  TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  int secondsRemaining = 59;
  bool enableResend = false;
   late Timer timer;

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 59;
      enableResend = false;
    });
  }

  @override
  dispose() {
    timer.cancel();
    myFocusNode.dispose();
    super.dispose();
  }

  String strOtp ="";
  late FocusNode myFocusNode;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnBoardingHeader(heading: "otp".tr(), isSkip: false),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: scaffoldHorizontalPadding, vertical: 20),
              child: animatedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //headingMedium("enterOtpHere".tr()),
                  headingMedium("enterOtpHere2".tr()),
                  Text("${widget.countryCode} ${widget.phone}"),
                  const SizedBox(height: 40),
                  PinCodeTextField(
                    length: 4,
                    controller: otpController,
                    focusNode: myFocusNode,
                    obscureText: false,
                    textStyle: const TextStyle(fontSize: ts30),
                    animationType: AnimationType.fade,
                    autoFocus: true,
                    enablePinAutofill: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    ],
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 90,
                      activeColor: Colors.grey.shade600,
                      inactiveColor: Colors.grey.shade400,
                      selectedColor: primaryDark,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: false,
                    onChanged: (value) {
                      strOtp = value.toString();
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                    appContext: context,
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? Loader.load()
                      : PrimaryButton(
                          onPressed: () {
                            if (strOtp.length < 4) {

                              Dialogs().errorDialog(context,
                                  title: "PleaseEnterValidOtp".tr());
                            } else {
                              verifyOtp();
                            }
                          },
                          title:  Text("submitOtp".tr(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: ts20))),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: enableResend ? resendOtp : null,
                          style: TextButton.styleFrom(primary: Colors.black),
                          child: Text(
                            "strResendOtp".tr(),
                            style: const TextStyle(
                                fontSize: ts26,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationThickness: 1,
                                decorationColor: primaryDark),
                          )),
                      secondsRemaining == 0
                          ? const SizedBox()
                          : Text(
                              "00:" + secondsRemaining.toString() + "s",
                              style: const TextStyle(
                                  fontSize: ts19, fontWeight: FontWeight.w500),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 // TTApis _ttApis = TTApis();

  verifyOtp() async {
    setState(() {
      isLoading = true;
    });
    var number = widget.phone?.trim().replaceAll(' ', '');
    await apis.verifyOtpApi(
            countryCode: widget.countryCode ?? "",
            phone: number ?? "",
            email: widget.email ?? "",
            userType: widget.userType ?? "",
            password: widget.password ?? "",
            name: widget.name ?? "",
            otp: otpController.text,
            preferences: widget.preference ?? "")
        .then((value) {
      if (value?.status ?? false) {
        spPreferences.setString(SpUtil.USER_ID, value?.data?['id'].toString() ?? "0");
        setState(() {
          isLoading = false;
        });
        spPreferences.setString(SpUtil.ACCESS_TOKEN, value?.data?['access_token'] ?? "");
        spPreferences.setBool(SpUtil.IS_LOGGED_IN, true);
        spPreferences.setBool(SpUtil.IS_GUEST, false); //updatePhone
        if (widget.userType == "forgot") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(
                        countryCode: widget.countryCode,
                        mobile: number,
                      )));
        } else if (widget.userType == "register") {
          // userDataProvider.getProfileApi(true);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => EditProfileScreen(userType: "Registering",)),
              (route) => false);
        }else if (widget.userType == "login") {

          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => const ServiceScreen()),
                  (route) => false);

        } else if (widget.userType == "updatePhone") {
          Fluttertoast.showToast(msg: value?.message ?? "defaultError".tr());
          userDataProvider.data?.countryCode = widget.countryCode;
          userDataProvider.data?.phone = number;
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
          // userDataProvider.getProfileApi(true);
          Navigator.pop(context, '');
        }
      } else {

        otpController.text = "";
        FocusScope.of(context).requestFocus(myFocusNode);

        Dialogs().errorDialog(context, title: value?.message ?? "defaultError".tr(),onTap: (){
          Navigator.pop(context);
        });
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  resendOtp() async {
    Loaders().loader(context);
    var number = widget.phone?.trim().replaceAll(' ', '');
    await apis
        .resendOtpApi(
            countryCode: widget.countryCode ?? "",
            phone: number ?? "",
            userType: widget.userType ?? "")
        .then((value) {
      if (value?.status ?? false) {
        _resendCode();
        Navigator.pop(context);
        Dialogs().errorDialog(context, title: value?.message ?? "");
        // Fluttertoast.showToast(msg: value?.message ?? "");
      } else {
        Navigator.pop(context);
        Dialogs().errorDialog(context, title: value?.message ?? "Something went Wrong!\nPlease try again");
      }
    });
  }
}
