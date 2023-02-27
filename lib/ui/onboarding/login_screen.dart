import 'package:country_code_picker/country_code_picker.dart';
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/ui/onboarding/otp_Screen.dart';
import 'package:cycle_lock/ui/onboarding/register_screen.dart';
import 'package:cycle_lock/ui/onboarding/service_Screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/utils/TimeAgo.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../network/api_provider.dart';
import '../../utils/dialogs.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../widgets/primary_button.dart';
import 'components/header.dart';
import 'forgot_pass_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();
  //final TextEditingController _passwordController = TextEditingController();

  Apis apis = Apis();

  bool _obscureText = true;

  bool isNutrition = false, isBikes = false, isAccessories = false;
  bool isLoading = false;
  final _mobileFormKey = GlobalKey<FormState>();
 // final _passwordFormKey = GlobalKey<FormState>();
  String selectedCountry = "+971";
  bool isRememberMe = false;

  @override
  void initState() {
    super.initState();
    if (spPreferences.getBool(SpUtil.REMEMBER_ME) ?? false) {
      isRememberMe = spPreferences.getBool(SpUtil.REMEMBER_ME) ?? false;
      _mobileController.text = TimeAgo.getFormatNumber((spPreferences.getString(SpUtil.SP_PHONE) ?? ""));
      //_passwordController.text = spPreferences.getString(SpUtil.SP_PASSWORD) ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            OnBoardingHeader(heading: "login".tr(), isSkip: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: animatedColumn(
                duration: 300,
                children: [
                  const SizedBox(height: 20),
                  Form(
                    key: _mobileFormKey,
                    child:
                    CustomTextField(
                        validator: (val) {
                          var number = val?.trim().replaceAll(' ', '');
                          if (number!.isEmpty) {
                            Dialogs().errorDialog(context,
                                title: "mobileEmptyError".tr());
                            return "";
                          } else if (number.length < 6) {
                            Dialogs().errorDialog(context,
                                title: "mobileLengthError".tr());
                            return "";
                          } else {
                            return null;
                          }
                        },
                        maxLength: 15,
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
                              textStyle:
                                  const TextStyle(fontSize: 24, color: textColor,fontWeight: FontWeight.w400,),
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                            const SizedBox(width: 0),
                            SvgPicture.asset(icArrowDown),
                            const SizedBox(width: 14),
                          ],
                        ),
                        hintText: "mobileNumber".tr(),
                        inputFormatters: [
                          MaskedInputFormater('00 000 00000000', anyCharMatcher: RegExp(r'[0-9]'))
                        ],
                        controller: _mobileController,
                        keyboardType: TextInputType.phone),
                  ),
                  /*const SizedBox(height: 20),
                  Form(
                    key: _passwordFormKey,
                    child: TextFormField(
                      autofocus: false,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          Dialogs().errorDialog(context,
                              title: "emptyPassError".tr());
                          return "";
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                        hintText: "password".tr(),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: hintColor,
                            fontSize: 24),
                        isDense: true,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(color: primaryDark, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryDark, width: 1),
                        ),
                        prefixIcon: Transform.scale(
                            scale: 0.7,
                            child: SvgPicture.asset("assets/images/lock.svg",
                                color: iconColor)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            semanticLabel: _obscureText
                                ? 'show password'
                                : 'hide password',
                            size: 30,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ),*/
                  const SizedBox(height: 40),
                  /*Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isRememberMe = !isRememberMe;
                          });
                          spPreferences.setBool(
                              SpUtil.REMEMBER_ME, isRememberMe);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: isRememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    isRememberMe = value!;
                                  });
                                  spPreferences.setBool(
                                      SpUtil.REMEMBER_ME, isRememberMe);
                                },
                                visualDensity:
                                    const VisualDensity(horizontal: -4),
                                activeColor: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              "rememberMe".tr(),
                              style: const TextStyle(
                                  fontSize: ts18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),*/
                  const SizedBox(height: 10),
                  isLoading
                      ? Loader.load()
                      : PrimaryButton(
                      onPressed: () {
                            if (_mobileFormKey.currentState!.validate()) {
                              var number = _mobileController.text.trim().replaceAll(' ', '');
                             // if (_passwordFormKey.currentState!.validate()) {
                                funLogin(
                                    password: /*_passwordController.text.trim()*/"",
                                    phone: number,
                                    context: context,
                                    countryCode: selectedCountry);
                             // }
                            }
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=> const OtpScreen()));
                          },
                          title: Text("login".tr(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: ts20))
                  ),
                 // const SizedBox(height: 15),
                 /* TextButton(
                    onPressed: () {
                      if (_mobileFormKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotScreen(
                                      mobile: _mobileController.text.trim(),
                                    )));
                      }
                    },
                    child: Text("forgotPassword".tr(),
                        style: const TextStyle(
                          shadows: [
                            const Shadow(color: iconColor, offset: Offset(0, -5))
                          ],
                          fontSize: ts20,
                          fontWeight: FontWeight.bold,
                          color: Colors.transparent,
                          decorationThickness: 1,
                          decoration: TextDecoration.underline,
                          decorationColor: iconColor,
                        )),
                  ),*/
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: Text("DontHaveAnAccount".tr(),
                        style: const TextStyle(
                          shadows: [
                            Shadow(color: lightGreyColor, offset: Offset(0, -5))
                          ],
                          fontSize: ts26,
                          fontWeight: FontWeight.w500,
                          color: Colors.transparent,
                          decoration: TextDecoration.underline,
                          decorationColor: lightGreyColor,
                          decorationThickness: 1,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  funLogin(
      {required String countryCode,
      required String phone,
      required BuildContext context,
      required String password}) async {
    Loaders().loader(context);
    await apis.sendOtpApi(
        countryCode: countryCode,
        phone: phone,
        email: "",
        userType: "").then((value) {
      if (value?.status ?? false) {
        Navigator.pop(context);
        if (isRememberMe) {
          var number = _mobileController.text.trim().replaceAll(' ', '');
          spPreferences.setBool(SpUtil.REMEMBER_ME, true);
          spPreferences.setString(SpUtil.SP_PHONE, number);
          spPreferences.setString(SpUtil.SP_PASSWORD, "");
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                    password: "",
                    name: "",
                    phone: _mobileController.text,
                    countryCode: selectedCountry,
                    email: "",
                    userType: "login")));
      } else {
        Navigator.pop(context);
        Dialogs().errorDialog(context, title: value?.message ?? "");
      }
    });
    /*await apis
        .loginApi(countryCode: countryCode, phone: phone, password: password)
        .then((value) {
      if (value?.status ?? false) {
        spPreferences.setString(SpUtil.USER_ID, value?.data?.id.toString() ?? "0");
        spPreferences.setBool(SpUtil.IS_GUEST, false);
        Navigator.pop(context);
        spPreferences.setBool(SpUtil.IS_LOGGED_IN, true);
        if (isRememberMe) {
          spPreferences.setBool(SpUtil.REMEMBER_ME, true);
          spPreferences.setString(SpUtil.SP_PHONE, _mobileController.text.trim());

          spPreferences.setString(SpUtil.SP_PASSWORD, _passwordController.text.trim());
        }
        spPreferences.remove(SpUtil.ACCESS_TOKEN);
        spPreferences.setString(SpUtil.ACCESS_TOKEN, value!.data!.accessToken!);

       Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const ServiceScreen()),
            (route) => false);


      } else {
        Navigator.pop(context);
        Dialogs().errorDialog(context, title: value?.message ?? "");
      }
    });*/
  }
}
