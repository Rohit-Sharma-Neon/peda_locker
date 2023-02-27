import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/preference_response.dart';
import 'package:cycle_lock/ui/onboarding/login_screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../utils/sizes.dart';
import '../widgets/primary_button.dart';
import 'components/header.dart';
import 'otp_Screen.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
 // final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
 // final TextEditingController _passwordController = TextEditingController();
  List<String> preferenceId = [];
  String preferenceFirst = "";

  bool _obscureText = true;
 // final _nameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
 // final _passwordFormKey = GlobalKey<FormState>();

  bool isNutrition = false, isBikes = false, isAccessories = false;
  Apis apis = Apis();
  bool isLoading = false;
  String selectedCountry = "+971";
  bool isPreferenceLoading = true;
  bool /*isNameValid = false,*/
      isEmailValid = false,
      isNumberValid = false;
      /*isPasswordValid = false;*/

  PreferenceResponse data = PreferenceResponse();

  @override
  void initState() {
    super.initState();
    // getPreferencesApi();
  }

  appleSignIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId: 'de.lunaone.flutter.signinwithappleexample.service',

        redirectUri:
            // For web your redirect URI needs to be the host of the "current page",
            // while for Android you will be using the API server that redirects back into your app via a deep link
            kIsWeb
                ? Uri.parse(
                    'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                  )
                : Uri.parse(
                    'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                  ),
      ),
      // TODO: Remove these if you have no need for them
      nonce: 'example-nonce',
      state: 'example-state',
    );

    // ignore: avoid_print
    print(credential);

    // This is the endpoint that will convert an authorization code obtained
    // via Sign in with Apple into a session in your system
    final signInWithAppleEndpoint = Uri(
      scheme: 'https',
      host: 'flutter-sign-in-with-apple-example.glitch.me',
      path: '/sign_in_with_apple',
      queryParameters: <String, String>{
        'code': credential.authorizationCode,
        if (credential.givenName != null) 'firstName': credential.givenName!,
        if (credential.familyName != null) 'lastName': credential.familyName!,
        'useBundleId':
            !kIsWeb && (Platform.isIOS || Platform.isMacOS) ? 'true' : 'false',
        if (credential.state != null) 'state': credential.state!,
      },
    );

    final session = await http.Client().post(
      signInWithAppleEndpoint,
    );

    // If we got this far, a session based on the Apple ID credential has been created in your system,
    // and you can now set this as the app's session
    // ignore: avoid_print
    print("aaaaaaaaaaaaaaaa" + session.toString());
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<Resource?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          // final userCredential = await _auth.signInWithCredential(facebookCredential);
          final userData = await FacebookAuth.instance.getUserData();
          // var graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult.accessToken.token}');
         // _fullNameController.text = userData['name'].toString();
          _emailController.text = userData['email'].toString();
          return Resource(status: Status.Success);
        case LoginStatus.cancelled:
          return Resource(status: Status.Cancelled);
        case LoginStatus.failed:
          return Resource(status: Status.Error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // void initiateFacebookLogin() async {
  //   var facebookLogin = FacebookAuth.instance.login();
  //   var facebookLoginResult =
  //   await facebookLogin.logInWithReadPermissions(['email']);
  //   switch (facebookLoginResult.status) {
  //     case FacebookLoginStatus.error:
  //       print("Error");
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("CancelledByUser");
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       print("LoggedIn");
  //       onLoginStatusChanged(true);
  //       break;
  //   }
  // }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  bool isButtonEnable = false;

  Future<bool> rebuild() async {
    if (!mounted) return false;
    // if there's a current frame,
    if (SchedulerBinding.instance?.schedulerPhase != SchedulerPhase.idle) {
      // wait for the end of that frame.
      await SchedulerBinding.instance?.endOfFrame;
      if (!mounted) return false;
    }
    setState(() {
      isButtonEnable = true;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    User? result = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OnBoardingHeader(heading: "register".tr(), isSkip: false),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: animatedColumn(
                children: [
                  const SizedBox(height: 20),
                 /* Form(
                    key: _nameFormKey,
                    child: CustomTextField(
                        isRegister: true,
                        prefixIcon: SvgPicture.asset(
                            "assets/images/profile.svg",
                            color: iconColor),
                        iconAsset: "assets/images/profile.svg",
                        validator: (val) {
                          if (val!.isEmpty) {
                            // Dialogs().errorDialog(context, title: "emptyNameError".tr());
                            return "emptyNameError".tr();
                          } else if (val.length < 2) {
                            // Dialogs().errorDialog(context, title: "nameLengthError".tr());
                            return "nameLengthError".tr();
                          } else {
                            isNameValid = true;
                            return null;
                          }
                        },
                        keyboardType: TextInputType.name,
                        hintText: "fullName".tr(),
                        controller: _fullNameController),
                  ),*/
                 // const SizedBox(height: 30),
                  Form(
                    key: _emailFormKey,
                    child: CustomTextField(
                      isRegister: true,
                      prefixIcon: SvgPicture.asset("assets/images/mail.svg",
                          color: iconColor),
                      iconAsset: "assets/images/mail.svg",
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern.toString());
                        if (val!.isEmpty) {
                          // Dialogs().errorDialog(context, title: "emailEmptyError".tr());
                          return "emailEmptyError".tr();
                        } else if (!regex.hasMatch(val)) {
                          // Dialogs().errorDialog(context, title: "emailInvalidError".tr());
                          return "emailInvalidError".tr();
                        } else {
                          isEmailValid = true;
                          return null;
                        }
                      },
                      hintText: "emailAddress".tr(),
                      controller: _emailController,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _phoneFormKey,
                    child: CustomTextField(
                        maxLength: 15,
                        isRegister: true,
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
                              favorite: [selectedCountry, "+91"],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              dialogTextStyle: const TextStyle(fontSize: 22),
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              textStyle: const TextStyle(
                                fontSize: 24,
                                color: textColor,
                                fontWeight: FontWeight.w400,
                              ),
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                            const SizedBox(width: 0),
                            SvgPicture.asset(icArrowDown),
                            const SizedBox(width: 14),
                          ],
                        ),
                        onChanged: (value){
                          if(value.length < 6){
                            setState(() {
                              isButtonEnable = false;
                            });
                          }
                        },
                        validator: (val) {
                          var number = val?.trim().replaceAll(' ', '');
                          if (number!.isEmpty) {
                            // Dialogs().errorDialog(context, title: "mobileEmptyError".tr());
                            return "mobileEmptyError".tr();
                          } else if (number.length < 6) {
                            // Dialogs().errorDialog(context, title: "mobileLengthError".tr());
                            return "mobileLengthError".tr();
                          } else {
                            isNumberValid = true;
                            if (isNumberValid && isEmailValid) {
                              if (mounted) {
                                WidgetsBinding.instance?.addPostFrameCallback((_) {
                                  setState(() {
                                    isButtonEnable = true;
                                  });
                                });
                              }
                            }
                            return null;
                          }
                        },
                        hintText: "mobileNumber".tr(),
                        controller: _mobileController,
                        inputFormatters: [
                          MaskedInputFormater('00 000 00000000', anyCharMatcher: RegExp(r'[0-9]'))
                        ],
                        keyboardType: TextInputType.phone),
                  ),
                 // const SizedBox(height: 30),
                  /*Form(
                    key: _passwordFormKey,
                    child: TextFormField(
                      autofocus: false,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      validator: (val) {
                        Pattern pattern =
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
                        RegExp regex = RegExp(pattern.toString());
                        if (val!.isEmpty) {
                          // Dialogs().errorDialog(context, title: "emptyPassError".tr());
                          return "emptyPassError".tr();
                        } else if (!regex.hasMatch(val)) {
                          // Dialogs().errorDialog(context, title: "passInvalidError".tr());
                          return "passInvalidError".tr();
                        } else {
                          if (isNameValid && isNumberValid && isEmailValid) {
                            if (mounted) {
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                setState(() {
                                  isButtonEnable = true;
                                });
                              });
                            }
                            return null;
                          }
                        }
                      },
                      style: const TextStyle(fontSize: 24),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "password".tr(),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: hintColor,
                            fontSize: 24),
                        isDense: true,
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryDark, width: 1),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: const BorderSide(color: primaryDark, width: 1),
                        ),
                        errorStyle: const TextStyle(fontSize: 14),
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
                  // const SizedBox(height: 40),
                  // SizedBox(width: double.infinity,child: Text("selectPreferences".tr(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.w800))),
                  const SizedBox(height: 100),
                  isLoading
                      ? Loader.load()
                      : PrimaryButton(
                          onPressed: isButtonEnable
                              ? () {
                                  preferenceFirst = "";
                                 // if (_nameFormKey.currentState!.validate()) {
                                    if (_emailFormKey.currentState!.validate()) {
                                      if (_phoneFormKey.currentState!.validate()) {
                                       // if (_passwordFormKey.currentState!.validate()) {
                                        var number = _mobileController.text.trim().replaceAll(' ', '');
                                          funSendOtp(
                                            context: context,
                                            phone: number,
                                            countryCode: selectedCountry,
                                            email: _emailController.text,
                                          );
                                        //}
                                      }
                                    }
                                 // }
                                }
                              : null,
                          title: Text("strContinue".tr(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: ts24)),
                        ),
                  const SizedBox(height: 30),
                 /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("or".tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: primaryDark2)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    child:
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: PrimaryButton(
                          onPressed: () {
                            signInWithFacebook();
                          },
                          title: SvgPicture.asset(icFacebook,
                              color: Colors.white, height: 30),
                          color: (const Color(0xff4867aa)),
                        )),
                        const SizedBox(width: 20),
                        Expanded(
                            child:
                            PrimaryButton(
                                onPressed: () {
                                  signInWithGoogle(context).then((value) {
                                    if (value.user != null) {
                                      //_fullNameController.text = value.user?.displayName ?? "";
                                      _emailController.text = value.user?.email ?? "";
                                    }
                                  });
                                },
                                title: SvgPicture.asset(icGoogle,
                                    color: Colors.white, height: 30),
                                color: const Color(0xffe34034))),
                        const SizedBox(width: 20),
                        Platform.isIOS? Expanded(
                            child:

                            PrimaryButton(
                                onPressed: () {
                                  appleSignIn();
                                },
                                title: SvgPicture.asset(icApple,
                                    color: Colors.white, height: 30),
                                color: const Color(0xff5f5e66))
                      )
                        :const SizedBox(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),*/
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Text("AlreadyAUser".tr(),
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
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  funSendOtp(
      {required String phone,
      required String countryCode,
      required String email,
      required BuildContext context}) async {
    setState(() {
      isLoading = true;
    });
    await apis.sendOtpApi(
            countryCode: countryCode,
            phone: phone,
            email: email,
            userType: "register").then((value) {
      if (value?.status ?? false) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                    password: /*_passwordController.text*/"",
                    name: /*_fullNameController.text*/"",
                    phone: _mobileController.text,
                    countryCode: selectedCountry,
                    email: _emailController.text,
                    userType: "register")));
      } else {
        setState(() {
          isLoading = false;
        });
        Dialogs().errorDialog(context,
            title:value?.message ?? "");
      }
    });
  }

  getPreferencesApi() async {
    setState(() {
      isPreferenceLoading = true;
    });
    await apis.preferenceApi().then((value) {
      if (value?.status ?? false) {
        data = value!;
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
    setState(() {
      isPreferenceLoading = false;
    });
  }
}
class Resource {
  final Status status;

  Resource({required this.status});
}
enum Status { Success, Error, Cancelled }