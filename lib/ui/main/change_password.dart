import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/ui/onboarding/login_screen.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/colors.dart';
import '../../utils/dialogs.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String? mobile;
  final String? countryCode;

  const ChangePasswordScreen({this.mobile, this.countryCode, Key? key})
      : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool isChecked = false;
  bool _obscureText = true;
  TextEditingController oldpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  final _oldPassFormKey = GlobalKey<FormState>();
  final _newPassFormKey = GlobalKey<FormState>();
  final _confirmPassFormKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  bool _newPassVisible = true;
  bool _confirmpasswordVisible = true;

  Apis apis = Apis();
  bool isLoading = false;

  @override
  void initState() {
    _passwordVisible = false;
    _newPassVisible = false;
    _confirmpasswordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            customAppbar(),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  const SizedBox(height: 40.0),
                  (widget.mobile ?? "").isNotEmpty
                      ? const SizedBox()
                      : Form(
                          key: _oldPassFormKey,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: oldpassword,
                            obscureText: !_passwordVisible,
                            style: const TextStyle(fontSize: ts28),
                            //This will obscure text dynamically
                            decoration: InputDecoration(
                              hintText: "OldPassword".tr(),
                              hintStyle: const TextStyle(
                                  color: hintColor,
                                  fontSize: ts28,
                                  fontWeight: FontWeight.w400),
                              isDense: true,
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryDark, width: 1),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryDark, width: 1),
                              ),
                              counterText: "",
                              // Here is key idea

                              prefixIcon: const Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, right: 8, bottom: 0),
                                  child: Icon(Icons.lock,
                                      size: 40, color: primaryDark2)),
                              contentPadding: const EdgeInsets.fromLTRB(5.0, 15.0, 20.0, 15.0),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryDark2,
                                  size: 30,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            maxLength: 20,
                            validator: (val) {
                              if (val!.isEmpty) {
                                Dialogs().errorDialog(context,
                                    title: "oldPassEmptyError".tr());
                                return "";
                              }
                              return null;
                            },
                          ),
                        ),
                  const SizedBox(height: 40.0),
                  Form(
                    key: _newPassFormKey,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: newpassword,
                      obscureText: !_newPassVisible,
                      style: const TextStyle(fontSize: ts28),
                      //This will obscure text dynamically
                      decoration: InputDecoration(
                        hintText: "NewPassword.".tr(),
                        hintStyle: const TextStyle(
                            color: hintColor,
                            fontSize: ts28,
                            fontWeight: FontWeight.w400),
                        isDense: true,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryDark, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryDark, width: 1),
                        ),
                        counterText: "",
                        // Here is key idea

                        prefixIcon: const Padding(
                            padding: EdgeInsets.only(
                                top: 0, right: 8, bottom: 0),
                            child: Icon(Icons.lock,
                                size: 40, color: primaryDark2)),
                        contentPadding:
                            const EdgeInsets.fromLTRB(5.0, 15.0, 20.0, 15.0),
                        // Here is key idea
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _newPassVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryDark2,
                            size: 30,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _newPassVisible = !_newPassVisible;
                            });
                          },
                        ),
                      ),
                      maxLength: 20,
                      validator: (val) {
                        Pattern pattern =
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                        RegExp regex = RegExp(pattern.toString());
                        if (val!.isEmpty) {
                          Dialogs()
                              .errorDialog(context, title: "newPassEmptyError".tr());
                          return "";
                        } else if (!regex.hasMatch(val)) {
                          Dialogs()
                              .errorDialog(context, title: "newPassInvalidError".tr());
                          return "";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Form(
                    key: _confirmPassFormKey,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: confirmpassword,
                      obscureText: !_confirmpasswordVisible,
                      style: const TextStyle(fontSize: ts28),
                      //This will obscure text dynamically
                      decoration: InputDecoration(
                        hintText: "ConfirmPassword.".tr(),
                        hintStyle: const TextStyle(
                            color: hintColor,
                            fontSize: ts28,
                            fontWeight: FontWeight.w400),
                        isDense: true,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryDark, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryDark, width: 1),
                        ),
                        counterText: "",
                        prefixIcon: const Padding(
                            padding: EdgeInsets.only(
                                top: 0, right: 8, bottom: 0),
                            child: Icon(Icons.lock,
                                size: 40, color: primaryDark2)),
                        contentPadding: const EdgeInsets.fromLTRB(5.0, 15.0, 20.0, 15.0),
                        // Here is key idea
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _confirmpasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: primaryDark2,
                            size: 30,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _confirmpasswordVisible =
                                  !_confirmpasswordVisible;
                            });
                          },
                        ),
                      ),
                      maxLength: 20,
                      validator: (text) {
                        if (text!.isEmpty) {
                          Dialogs().errorDialog(context,
                              title: "confirmPassEmptyError".tr());
                          return "";
                        } else if (confirmpassword.text != newpassword.text) {
                          Dialogs().errorDialog(context,
                              title: "confirmPassMatchError".tr());
                          return "";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 40.0),
                ])),
            isLoading
                ?  Center(
                    child: Loader.load(),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                        onPressed: () {
                          if ((widget.mobile ?? "") == "") {
                            if (_oldPassFormKey.currentState!.validate()) {
                              if (_newPassFormKey.currentState!.validate()) {
                                if (_confirmPassFormKey.currentState!
                                    .validate()) {
                                  (widget.mobile ?? "").isEmpty
                                      ? changePasswordApi(context)
                                      : resetPassword(context);
                                }
                              }
                            }
                          } else {
                            if (_newPassFormKey.currentState!.validate()) {
                              if (_confirmPassFormKey.currentState!
                                  .validate()) {
                                (widget.mobile ?? "").isEmpty
                                    ? changePasswordApi(context)
                                    : resetPassword(context);
                              }
                            }
                          }
                        },
                        child: Text(
                          "Submit".tr(),
                          style: const TextStyle(
                              fontSize: ts18, fontWeight: FontWeight.w500),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: primaryDark2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(20),
                        )),
                  )
          ],
        ));
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          height: 70,
          color: lightGreyColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: /*SvgPicture.asset(backArrow, height: 30)*/  const Icon(Icons.arrow_back_ios_rounded, size: 28,color: Colors.white)
            ),
            const SizedBox(width: 20),
            Text(
                (widget.mobile ?? "").isEmpty
                    ? "ChangePassword".tr()
                    : "ResetPassword".tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: ts22)),
          ])),
    );
  }

  changePasswordApi(BuildContext context) async {
    Loaders().loader(context);
    apis
        .changePasswordApi(
            oldPass: oldpassword.text,
            newPass: newpassword.text,
            confPass: confirmpassword.text)
        .then((value) {
      if (value?.status ?? false) {
        Navigator.pop(context);
        if (spPreferences.getBool(SpUtil.REMEMBER_ME) ?? false) {
          spPreferences.setString(SpUtil.SP_PASSWORD, confirmpassword.text);
        }
        Fluttertoast.showToast(msg: value?.message ?? "");
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        Dialogs().errorDialog(context, title: value?.message ?? "");
        // Fluttertoast.showToast(msg: value?.message??"");
      }
    });
  }

  resetPassword(BuildContext context) {
    Loaders().loader(context);
    apis
        .resetPasswordApi(
            newPassword: confirmpassword.text,
            confirmPassword: confirmpassword.text,
            phone: widget.mobile ?? "",
            countryCode: widget.countryCode ?? "")
        .then((value) {
      if (value?.status ?? false) {
        spPreferences.remove(SpUtil.SP_PASSWORD);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: value?.message ?? "");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
        Navigator.pop(context);
      }
    });
  }
}
