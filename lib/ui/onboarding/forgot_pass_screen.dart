import 'dart:async';
import 'dart:io' show Platform;
import 'package:country_code_picker/country_code_picker.dart';
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/ui/main/change_password.dart';
import 'package:cycle_lock/ui/onboarding/components/header.dart';
import 'package:cycle_lock/ui/onboarding/otp_Screen.dart';
import 'package:cycle_lock/ui/onboarding/service_Screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/heading_medium.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/ui/widgets/primary_button.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:cycle_lock/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/images.dart';
import '../../utils/strings.dart';
import '../widgets/custom_textfield.dart';

class ForgotScreen extends StatefulWidget {

  final String mobile;
  const ForgotScreen({this.mobile = "",Key? key}) : super(key: key);

  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {

  final TextEditingController _mobileController = TextEditingController();
  String selectedCountry = "+971";

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Apis apis = Apis();

  @override
  void initState() {
    _mobileController.text = widget.mobile;
    super.initState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnBoardingHeader(heading: "EnterRegisteredMobile".tr(), isSkip: false),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: scaffoldHorizontalPadding, vertical: 40),
              child: animatedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          Dialogs().errorDialog(context, title: "mobileEmptyError".tr());
                          return "";
                        }else if (val.length<6) {
                          Dialogs().errorDialog(context, title: "mobileLengthError".tr());
                          return "";
                        }else{
                          return null;
                        }
                      },
                      maxLength: 13,
                      prefixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CountryCodePicker(
                            onChanged: (val) {
                              selectedCountry = val.dialCode!;
                            },
                            flagWidth: 60,
                            padding: EdgeInsets.zero,

                            // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                            initialSelection: selectedCountry,
                            favorite: [selectedCountry],
                            // optional. Shows only country name and flag
                            showCountryOnly: false,
                            // optional. Shows only country name and flag when popup is closed.
                            showOnlyCountryWhenClosed: false,
                            textStyle: const TextStyle(fontWeight: FontWeight.w400,fontSize: 24, color: textColor,),
                            // optional. aligns the flag and the Text left
                            alignLeft: false,
                          ),
                          const SizedBox(width: 0),
                          SvgPicture.asset(icArrowDown),
                          const SizedBox(width: 14),
                        ],
                      ),
                      hintText: "mobileNumber".tr(),
                      controller: _mobileController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13)
                      ],
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 30),
                  PrimaryButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          funSendOtp(context);
                        }
                      },
                      title:  Text("strContinue".tr(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: ts20))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  funSendOtp(BuildContext context)async{
    Loaders().loader(context);
    await apis.sendOtpApi(countryCode: selectedCountry, phone: _mobileController.text, userType: "forgot",email: "").then((value){
      if (value?.status??false) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> OtpScreen(userType: "forgot",countryCode: selectedCountry,phone: _mobileController.text,)));
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> OtpScreen(userType: "forgot")), (route) => false);
      }else{
        Navigator.pop(context);
        Dialogs().errorDialog(context, title: value!.message??"defaultError".tr());
      }
    });
    // Navigator.pop(context);
  }
}