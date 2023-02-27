import 'dart:convert';
import "dart:io";
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/providers/user_data_provider.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/main/edit_profile_Screen.dart';
import 'package:cycle_lock/ui/main/privacy_policy_screen.dart';
import 'package:cycle_lock/ui/main/terms_conditions_screen.dart';
import 'package:cycle_lock/ui/onboarding/preference_screen.dart';
import 'package:cycle_lock/ui/onboarding/tutorial_screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/utils/TimeAgo.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/profile_calculator.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../responses/get_profile_response.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';

import 'feedback_screen.dart';
import 'how_it_works_screen.dart';
import 'invite_friend_screen.dart';

class MyAccountScreen extends StatefulWidget {
  static const routeName = "/my-account";

  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen>
    with AutomaticKeepAliveClientMixin {
  String imageStatus = "0";
  String? selectNationality;
  String? networkImage;
  File? userImage;
  String? imageName;
  Data userData = Data();

  // final ImagePicker _picker = ImagePicker();

  Apis _apis = Apis();
  bool isLoading = false;
  late UserDataProvider userDataProvider;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
      userDataProvider.getProfileApi(true);
    });
    getPrefences();
    // getProfileApi();
    // getProfileData();
    super.initState();
  }

  String preferencesNames = "";

  getPrefences() {
    if ((spPreferences.getString(SpUtil.PREFERENCES_NAMES) ?? "").length == 1) {
      preferencesNames = "";
    } else {
      preferencesNames = spPreferences.getString(SpUtil.PREFERENCES_NAMES) ?? "";
    }
  }

  getProfileData() {
    userData = Data.fromJson(json.decode(spPreferences.getString(SpUtil.PROFILE_DATA) ?? ""));
  }

  Future<void> _pullRefresh() async {
    userDataProvider.getProfileApi(true);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: Platform.isIOS ? 140.0 : 100),
            child: FloatingActionButton(
              backgroundColor: watsUp,
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Image.asset(
                  wathsUp,
                  height: 80,
                  width: 80,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                _launchWhatsapp();
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildBody()],
          )),
    );
  }

  _launchWhatsapp() async {
    var phone = "+971526457953";
    print("Whats App Number ===> " + phone.toString().trim());
    var url = '';

    if (Platform.isAndroid) {
      setState(() {
        url = "https://wa.me/$phone/?text=Hello";
      });
    } else {
      setState(() {
        url = "https://api.whatsapp.com/send?phone=$phone=Hello";
      });
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          color: lightGreyColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                        );
                      },

                      child: /*SvgPicture.asset(backArrow, height: 30)*/  const Icon(Icons.arrow_back_ios_rounded, size: 28,color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  Text("MyAccount".tr(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: ts22)),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                              userType: "editProfile",
                            )));
              },
              child: Text("EditProfile".tr(),
                  style: const TextStyle(
                      decorationThickness: 1,
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: ts18)),
            )
          ])),
    );
  }

  _buildBody() {
    return Consumer<UserDataProvider>(
      builder: (BuildContext context, userData, child) {

        ProfileCalculator.calculate(userData.data);

        return Expanded(
          child: userData.isLoadings
              ? Loader.load()
              : ListView(
                  children: [
                    animatedColumn(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              (userData.data?.imageUrl ?? "") + "/" + (userData.data?.image ?? ""),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return  Center(
                                    child: Loader.load());
                              },
                              height: 100,
                              width: 100,
                              errorBuilder: (context, error, stackTrace) => SvgPicture.asset(icDummyProfile, color: buttonColor),
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),

                          Text(userData.data?.name.toString() ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: primaryDark2,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ts24)),

                          Text("${ProfileCalculator.getPercent.toString()}% " + "completeProfile".tr(), style: const TextStyle(fontSize: 10),),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: 14,
                                  child: LinearProgressIndicator(
                                    value: (ProfileCalculator.getPercent / 100),
                                    valueColor: const AlwaysStoppedAnimation<Color>(buttonColor),
                                    backgroundColor: greyBgColor,
                                  ),
                                ),
                              )
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          (userData.data?.gender ?? "").isEmpty ||
                                  (userData.data?.dob ?? "").isEmpty
                              ? const SizedBox()
                              : Text(
                                  (userData.data?.gender ?? "") +
                                      "," +
                                      " " +
                                      (userData.data?.dob ?? ""),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: primaryDark2,
                                      fontSize: ts18)),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: greyBgColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("EmailAddress".tr(),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: primaryDark,
                                          fontSize: ts16)),
                                  const SizedBox(height: 5),
                                  Text(userData.data?.email.toString() ?? "",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: greyFontColor,
                                          fontSize: ts20)),
                                ],
                              )),
                          const SizedBox(height: 16),
                          Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: greyBgColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("MobileNumber".tr(),
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: primaryDark,
                                          fontSize: ts16)),
                                  const SizedBox(height: 5),
                                  Text(
                                      (userData.data?.countryCode.toString() ??
                                              "") +
                                          "  " + TimeAgo.getFormatNumber((userData.data?.phone.toString() ??
                                          ""))
                                          ,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: greyFontColor,
                                          fontSize: ts20)),
                                ],
                              )),
                          const SizedBox(height: 16),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PreferenceScreen())).then((value) {
                                  if (value == "update") {
                                    setState(() {
                                      preferencesNames = "";
                                      getPrefences();
                                    });
                                  }
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: greyBgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Row(children: [
                                            Text("ChangePreference".tr(),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: greyFontColor,
                                                    fontSize:
                                                        preferencesNames.isEmpty
                                                            ? ts20
                                                            : ts16)),
                                          ]),
                                        ],
                                      ),
                                      preferencesNames.isNotEmpty
                                          ? Text(preferencesNames,
                                              style: const TextStyle(
                                                  fontSize: ts21,
                                                  fontWeight: FontWeight.w600))
                                          : const SizedBox(),
                                    ],
                                  ))),
                      /*    const SizedBox(height: 16),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChangePasswordScreen()));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: greyBgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text("ChangePassword".tr(),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: greyFontColor,
                                                fontSize: ts20)),
                                      ]),
                                    ],
                                  ))),*/
                          const SizedBox(height: 16),
                          GestureDetector(
                              onTap: () {
                                changeLanguage();
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: greyBgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("ChangeLanguage".tr(),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: greyFontColor,
                                                fontSize: ts20)),
                                        Image.asset(
                                          translate,
                                          height: 24,
                                          width: 24,
                                          color: buttonColor,
                                        ),
                                      ]))),
                          const SizedBox(height: 16),
                       /*   GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CouponScreen()));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: greyBgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Row(children: [
                                        Text(
                                          "Coupons".tr(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: greyFontColor,
                                              fontSize: ts20),
                                        ),
                                      ]),
                                    ],
                                  ))),*/
                          // const SizedBox(height: 16),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const InviteFriendScreen()));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: greyBgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Row(children: [
                                        Text(
                                          "InviteFriend".tr(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: greyFontColor,
                                              fontSize: ts20),
                                        ),
                                      ]),
                                    ],
                                  ))),
                          const SizedBox(height: 16),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FeedbackScreen()));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: greyBgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Row(children: [
                                        Text(
                                          "feedback".tr(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: greyFontColor,
                                              fontSize: ts20),
                                        ),
                                      ]),
                                    ],
                                  ))),
                          const SizedBox(height: 16),
                          GestureDetector(
                              onTap: () {
                                _dialog("logoutAlert".tr());

                                /*    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder:
                          (BuildContext context) =>
                          LoginScreen()));*/
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: greyBgColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Row(children: [
                                        Text(
                                          "LogOut".tr(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: greyFontColor,
                                              fontSize: ts20),
                                        ),
                                      ]),
                                    ],
                                  ))),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HowItWorksScreen()));
                            },
                            child: Text("HowItWorks".tr(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: lightGreyColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: ts24)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TermsConditionsScreen()));
                                  },
                                  child: Text("TermsConditions".tr(),
                                      style: const TextStyle(
                                          color: lightGreyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: ts24))),
                              Container(
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                height: 20,
                                width: 2,
                                color: lightGreyColor,
                                alignment: Alignment.center,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PrivacyPolicyScreen()));
                                  },
                                  child: Text("PrivacyPolicy".tr(),
                                      style: const TextStyle(
                                          color: lightGreyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: ts24))),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            margin: const EdgeInsets.only(top: 16),
                            width: double.infinity,
                            color: const Color(0xffF2F2F2),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(icVisa, height: 28),
                                const SizedBox(width: 40),
                                SvgPicture.asset(icMasterCard, height: 35),
                                const SizedBox(width:40),
                                SvgPicture.asset(icAmerican, height: 32),
                                const SizedBox(width: 40),
                                SvgPicture.asset(icUnion, height: 33),


                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                              "Version".tr() +
                                  (spPreferences
                                          .getString(SpUtil.APP_VERSION) ??
                                      ""),
                              style: const TextStyle(
                                  color: buttonColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ts16)),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  openFacebook(
                                      "https://facebook.com/pedalocker");
                                },
                                child:
                                Image.asset(
                                  facebook,
                                  height: 45,
                                  width: 45,
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  openTwitter();
                                },
                                child: Image.asset(
                                  twitter,
                                  height: 45,
                                  width: 45,
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  openInstagram("");
                                },
                                child: Image.asset(
                                  instagram,
                                  height: 45,
                                  width: 45,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                        ])
                  ],
                ),
        );
      },
    );
  }

  _dialog(String Message) {
    Dialogs().confirmationDialog(context, message: "logoutAlert".tr(),
        onContinue: () {
      logoutApi();
    });
  }

  changeLanguage() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          "selectLanguage".tr(),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                context.setLocale(const Locale("en", "US"));
                spPreferences.setString(SpUtil.USER_LANGUAGE, "en");
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashBoardScreen()), (route) => false,);
                _apis.changeLanguage().then((value){});
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.locale.toString() == "en_US"
                      ? lightGreyColor
                      : Colors.white,
                ),
                child: Text(
                  "english".tr(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.setLocale(const Locale("ar", "DZ"));
                spPreferences.setString(SpUtil.USER_LANGUAGE, "ar");
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashBoardScreen()), (route) => false,);
                _apis.changeLanguage().then((value){});
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.locale.toString() != "en_US"
                      ? lightGreyColor
                      : Colors.white,
                ),
                child: Text(
                  "arabic".tr(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showImagePicker(context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: Text("PhotoGallery".tr()),
                    onTap: () {
                      // _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text("Camera".tr()),
                  onTap: () {
                    // _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

/*
  _imgFromCamera() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      userImage = File(image!.path);
      imageStatus = "2";
    });
  }

  _imgFromGallery() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      userImage = File(image!.path);
      imageStatus = "2";
    });
  }*/

  logoutApi() async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    await _apis.logoutApi().then((value) async {
      if (value?.status ?? false) {
        SpUtil().clearUserData();
        userData = Data();

        // final result = await FlutterRestart.restartApp();
        Fluttertoast.showToast(msg: value?.message ?? "");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorialScreen()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  openFacebook(fbProtocolUrl) async {
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/page_id';
    } else {
      fbProtocolUrl = 'fb://page/page_id';
    }

    String fallbackUrl = 'https://facebook.com/pedalocker';

    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }

  openInstagram(profile) async {
    var url = 'https://instagram.com/pedalocker' + profile + '/';

    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  openTwitter() async {
    var url = 'https://twitter.com/pedalocker';

    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      throw 'There was a problem to open the url: $url';
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

// getProfileApi() async {
//   isLoading = true;
//   await _apis.getProfileApis().then((value) {
//     if (value?.status ?? false) {
//       setState(() {
//         isLoading = false;
//         userData = value!.data!;
//       });
//     } else {
//       Fluttertoast.showToast(msg: value?.message ?? "");
//     }
//   });
// }
}
