import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/profile_response.dart';
import 'package:cycle_lock/ui/onboarding/bike_detail_screen.dart';
import 'package:cycle_lock/ui/onboarding/otp_Screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/ui/widgets/primary_button.dart';
import 'package:cycle_lock/utils/TimeAgo.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/user_data_provider.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import '../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  String userType;

  EditProfileScreen({Key? key, this.userType = ""}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController _driverHeightController = TextEditingController();
  DateTime? selectedDate;


  int group1Value = 0;
  bool isGuest = false;

  // Data userData = Data();
  UserDataProvider? userData;

  @override
  void initState() {
    isGuest = spPreferences.getBool(SpUtil.IS_GUEST) ?? false;
    if (!isGuest) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        userData = Provider.of<UserDataProvider>(context, listen: false);
        if (userData != null) {
          userData?.getProfileApi(true).then((value) {
            setProfileData(value!);
          });
        }
      });
    }
    super.initState();
  }

  String selectedCountry = "+971";

  setProfileData(ProfileData userData) {
    // userData = Data.fromJson(json.decode(spPreferences.getString(SpUtil.PROFILE_DATA)??""));
    if (userData != null) {
      _fullNameController.text = userData.name ?? "";
      _emailController.text = userData.email ?? "";
     // print('1234567890'.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "sasa ${m[1]} ${m[2]} ${m[3]}"));
      _phoneController.text = TimeAgo.getFormatNumber((userData.phone ?? ""));
      selectedCountry = userData.countryCode ?? "";
      dateController.text = userData.dob ?? "";
      selectedDate = userData.dob != null ? DateFormat("dd/MM/yyyy").parse(userData.dob ?? "") : DateTime(DateTime.now().year - 5, 1, 1);

      _driverHeightController.text = (userData.height != null && userData.height != "0") ?  userData.height ?? "" : "";
      _heightType = (userData.heightType?.replaceFirst(
                      userData.heightType?[0] ?? "",
                      (userData.heightType?[0] ?? "").toUpperCase()) ??
                  "Cm") ==
              "Cm"
          ? "Cm"
          : "Inch";
      if (userData.gender != null) {
        group1Value = userData.gender == "Male" ? 1 : 2;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  final _nameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _dobFormKey = GlobalKey<FormState>();

  Future<bool> onWillPop() {
    if (widget.userType == "Registering") {
      showAlertDialog(context);
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  showAlertDialog(BuildContext context) {
    Dialogs().confirmationDialog(context, message: "AreYouExit".tr(),
        onContinue: () {
      exit(0);
    });
  }

  String _heightType = "Cm";

  final _heightFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Consumer<UserDataProvider>(
        builder: (BuildContext context, value, child) {
          return Scaffold(
            appBar: BaseAppBar(
                isBack: widget.userType == "editProfile" ? true : false,
                title: widget.userType == "Registering"
                    ? "Complete Profile"
                    : "editProfile".tr(),
                actions: widget.userType == "Registering"
                    ? [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BikeDetailScreen(
                                          isRegistering: true,
                                        )));
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20,left: 20),
                              child: Text(
                                "skip".tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: ts20,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1),
                              ),
                            ),
                          ),
                        )
                      ]
                    : []),
            body: value.isLoadings
                ? Loader.load()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: animatedColumn(children: [
                      const SizedBox(height: 40),
                      Center(
                        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                            ? FutureBuilder<void>(
                                future: retrieveLostData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return profileImage();
                                    case ConnectionState.done:
                                      return Stack(
                                        alignment: Alignment.bottomCenter,
                                        overflow: Overflow.visible,
                                        children: [
                                          _handlePreview(),
                                          Positioned(
                                              right: -43,
                                              child: SvgPicture.asset(
                                                icEdit,
                                                height: 100,
                                                fit: BoxFit.fitHeight,
                                              )),
                                        ],
                                      );
                                    default:
                                      if (snapshot.hasError) {
                                        return Stack(
                                          children: [
                                            SvgPicture.asset(icDummyProfile,
                                                height: 250),
                                            Positioned(
                                                right: 16,
                                                bottom: 20,
                                                child: SvgPicture.asset(
                                                  icEdit,
                                                  height: 100,
                                                  fit: BoxFit.fitHeight,
                                                )),
                                          ],
                                        );
                                      } else {
                                        return Stack(
                                          children: [
                                            SvgPicture.asset(icDummyProfile,
                                                height: 250),
                                            Positioned(
                                                right: 16,
                                                bottom: 20,
                                                child: SvgPicture.asset(
                                                  icEdit,
                                                  height: 100,
                                                  fit: BoxFit.fitHeight,
                                                )),
                                          ],
                                        );
                                      }
                                  }
                                },
                              )
                            : Stack(
                          alignment: Alignment.bottomCenter,
                          overflow: Overflow.visible,
                          children: [
                            _handlePreview(),
                            Positioned(
                                right: -43,
                                child: SvgPicture.asset(
                                  icEdit,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _nameFormKey,
                        child: CustomTextField(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SvgPicture.asset(
                                  "assets/images/profile.svg",
                                  color: primaryDark2),
                            ),
                            keyboardType: TextInputType.name,
                            validator: (val) {
                              if (val!.isEmpty) {
                                Dialogs().errorDialog(context,
                                    title: "emptyNameError".tr());
                                return "";
                              } else if (val.length < 2) {
                                Dialogs().errorDialog(context,
                                    title: "nameLengthError".tr());
                                return "";
                              } else {
                                return null;
                              }
                            },
                            hintText: "fullName".tr(),
                            controller: _fullNameController),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _emailFormKey,
                        child: CustomTextField(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: SvgPicture.asset("assets/images/mail.svg",
                                  color: primaryDark2),
                            ),
                            // iconAsset: "assets/images/mail.svg",
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = RegExp(pattern.toString());
                              if (val!.isEmpty) {
                                Dialogs().errorDialog(context,
                                    title: "emailEmptyError".tr());
                                return "";
                              } else if (!regex.hasMatch(val)) {
                                Dialogs().errorDialog(context,
                                    title: "emailInvalidError".tr());
                                return "";
                              } else {
                                return null;
                              }
                            },
                            hintText: "emailAddress".tr(),
                            controller: _emailController),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _phoneFormKey,
                        child: CustomTextField(
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
                                  textStyle: const TextStyle(
                                      fontSize: 24,
                                      color: textColor,
                                      fontWeight: FontWeight.w400),
                                  // optional. aligns the flag and the Text left
                                  alignLeft: false,

                                ),
                                const SizedBox(width: 0),
                                SvgPicture.asset(icArrowDown,
                                    color: primaryDark2),
                                const SizedBox(width: 14),
                              ],
                            ),
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
                            hintText: "mobileNumber".tr(),
                            controller: _phoneController,
                            inputFormatters: [
                             // FilteringTextInputFormatter.digitsOnly,
                             // LengthLimitingTextInputFormatter(15),
                              MaskedInputFormater('00 000 00000000', anyCharMatcher: RegExp(r'[0-9]'))
                            ],
                            keyboardType: TextInputType.phone),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _showDialog(
                                CupertinoDatePicker(
                              //initialDateTime: DateTime(DateTime.now().year , 1, 1),
                              initialDateTime: selectedDate ?? DateTime(DateTime.now().year - 5, 1, 1),
                              mode: CupertinoDatePickerMode.date,
                              //use24hFormat: true,
                               minimumDate: DateTime(1900),
                               maximumDate: DateTime(DateTime.now().year - 5, DateTime.now().month, DateTime.now().day),
                              // maximumDate: DateTime.now(),
                              // This is called when the user changes the date.
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() {
                                  selectedDate = newDate;
                                  final DateFormat formatter = DateFormat(dateFormatSlash);
                                  final String formatted = formatter.format(selectedDate!);
                                  dateController.text = formatted;
                                });
                              },
                            ));
                          },
                          child: IgnorePointer(
                              child: Form(
                            key: _dobFormKey,
                            child: CustomTextField(
                                hintText: "DateOfBirth".tr(),
                                controller: dateController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    Dialogs().errorDialog(context, title: "dobEmptyError".tr());
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: SvgPicture.asset(icCalendar,
                                      color: iconColor),
                                )),
                          ))),
                      const SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(bottom: 9),
                              child: Form(
                                key: _heightFormKey,
                                child: CustomTextField(
                                    maxLength: 3,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        Dialogs().errorDialog(context,
                                            title:
                                                "driverHeightEmptyError".tr());
                                        return "";
                                      } else {
                                        return null;
                                      }
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]")),
                                    ],
                                    keyboardType: TextInputType.number,
                                    hintText: "driverHeight".tr(),
                                    controller: _driverHeightController),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: DropdownButton(
                                hint: _heightType == "Cm"
                                    ? const Text(
                                        'Cm',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: ts24),
                                      )
                                    : Text(
                                        _heightType,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: ts24),
                                      ),
                                iconEnabledColor: Colors.black,
                                isExpanded: true,
                                underline: Container(
                                  height: 1,
                                  color: lightGreyColor,
                                ),
                                iconSize: 30.0,
                                items: ["Cm", "Inch"].map(
                                  (val) {
                                    return DropdownMenuItem(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: ts24),
                                      ),
                                    );
                                  },
                                ).toList(),
                                onChanged: (val) {
                                  setState(
                                    () {
                                      _heightType = val.toString();
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Text("gender".tr(),
                              style: const TextStyle(
                                fontSize: ts24,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: Radio(
                                      value: 1,
                                      groupValue: group1Value,
                                      onChanged: (index) {
                                        setState(() {
                                          group1Value = 1;
                                        });
                                      },
                                      activeColor: lightGreyColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        group1Value = 1;
                                      });
                                    },
                                    child: Text("male".tr(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: ts22))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: Radio(
                                      value: 2,
                                      groupValue: group1Value,
                                      onChanged: (index) {
                                        setState(() {
                                          group1Value = 2;
                                        });
                                      },
                                      activeColor: lightGreyColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        group1Value = 2;
                                      });
                                    },
                                    child: Text("female".tr(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: ts22))),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 100,
                          ),
                        ]),
                      ),
                      const SizedBox(height: 25),
                      isLoading
                          ? Loader.load()
                          : PrimaryButton(
                              onPressed: () {
                                var number = _phoneController.text.trim().replaceAll(' ', '');
                                if ((userData?.data?.phone ?? "") == number
                                    && (userData?.data?.countryCode ?? "") == selectedCountry) {
                                  if (_nameFormKey.currentState!.validate()) {
                                    if (_emailFormKey.currentState!
                                        .validate()) {
                                      if (_phoneFormKey.currentState!
                                          .validate()) {
                                        if (_dobFormKey.currentState!
                                            .validate()) {
                                          if (_heightFormKey.currentState!
                                              .validate()) {
                                            if (group1Value == 0) {
                                              Dialogs().errorDialog(context,
                                                  title:
                                                      "genderEmptyError".tr());
                                            } else {
                                              Loaders().loader(context);
                                              userData?.updateProfileApi(
                                                  userType: widget.userType,
                                                  dob: dateController.text,
                                                  gender: group1Value == 1
                                                      ? "Male"
                                                      : "Female",
                                                  name: _fullNameController.text
                                                      .trim(),
                                                  image: _image?.path ?? "",
                                                  context: context,
                                                  email: _emailController.text,
                                                  height:
                                                      _driverHeightController
                                                          .text,
                                                  heightType: _heightType);
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                } else {
                                  if (_phoneFormKey.currentState!.validate()) {
                                    var number = _phoneController.text.trim().replaceAll(' ', '');
                                    funSendOtp(
                                        countryCode: selectedCountry,
                                        phone: number,
                                        context: context);
                                  }
                                }
                              },
                              title: Text("save".tr(),
                                  style: const TextStyle(fontSize: 24))),
                    ]),
                  ),
          );
        },
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.topRight,
                  children: [
                    child,
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Done".tr(),
                              style: const TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            primary: primaryDark2,
                          )),
                    ),
                  ],
                ),
              ),
            ));
  }

  _selectDate(BuildContext context) async {
    final DateFormat formatter = DateFormat(dateFormatSlash);
    selectedDate = (await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year - 12, 1, 13),
    ))!;
    final String formatted = formatter.format(selectedDate!);
    dateController.text = formatted;
  }

  Widget bottomSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading:
                const Icon(Icons.camera_alt, size: 30, color: Colors.black),
            title: Text('Camera'.tr(),
                style: const TextStyle(
                    fontSize: ts22, fontWeight: FontWeight.w500)),
            onTap: () {
              pickImage(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image, size: 30, color: Colors.black),
            title: Text('Gallery'.tr(),
                style: const TextStyle(
                    fontSize: ts22, fontWeight: FontWeight.w500)),
            onTap: () {
              pickImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget profileImage() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            builder: (context) {
              return bottomSheet();
            });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.network(
            (userData?.data?.imageUrl ?? "") +
                "/" +
                (userData?.data?.image ?? ""),
            fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Loader.load();
            },
            height: 200,
            width: 200,
            errorBuilder: (context, error, stackTrace) =>
                SvgPicture.asset(icDummyProfile)),
      ),
    );
  }

  XFile? _image;

  set _imageFile(XFile? value) {
    _image = value;
  }

  dynamic _pickImageError;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      imageQuality : 50,
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_image != null) {
      return InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15))),
                builder: (context) {
                  return bottomSheet();
                });
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.file(
                File(_image?.path ?? ""),
                height: 200,
                width: 200,
                fit: BoxFit.fill,
              )));
    } else if (_pickImageError != null) {
      return SvgPicture.asset(icDummyProfile);
    } else {
      return profileImage();
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  bool isLoading = false;
  Apis apis = Apis();

  funSendOtp(
      {required String phone,
      required String countryCode,
      required BuildContext context}) async {
    setState(() {
      isLoading = true;
    });
    await apis
        .sendOtpApi(
            countryCode: selectedCountry,
            phone: phone,
            userType: "updatePhone",
            email: "")
        .then((value) {
      if (value?.status ?? false) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                    phone: _phoneController.text.trim(),
                    countryCode: selectedCountry,
                    userType: "updatePhone"))).then((value) {
          if (value == "update") {
            userData?.getProfileApi(true);
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Dialogs()
            .errorDialog(context, title: value?.message ?? "defaultError".tr());
      }
    });
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
