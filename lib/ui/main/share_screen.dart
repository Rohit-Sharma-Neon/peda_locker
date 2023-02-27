import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../network/api_provider.dart';
import '../../responses/share_data_response.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import '../widgets/custom_textfield.dart';
import 'mygear_screen.dart';

class ShareScreen extends StatefulWidget {
  ShareBike shareData;
  final String? checkIn;
  final String? checkOut;

 ShareScreen({Key? key, required this.shareData, this.checkIn, this.checkOut}) : super(key: key);


  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  int groupValue = 1;
  Apis apis = Apis();
  bool isLoading = false;
  bool isShowAdd = true;
  var share_type = "permanent";
  String selectedCountry = "+971";
  DateTime? checkselectedEndDate;
  DateTime? selectedStartDate;

  DateTime? checkIn;
  DateTime? checkOut;

  //late DateTime selectedEndDate;
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  var width;
  var height;
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
    DateTime.now(),
  ];

  @override
  void initState() {
    super.initState();

    selectedStartDate =  DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.checkIn ?? "");
    checkselectedEndDate =  DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.checkOut ?? "");

    checkIn =  DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.checkIn ?? "");
    checkOut =  DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.checkOut ?? "");

    print("object >>>> $selectedStartDate");
    print("object >>>> $checkselectedEndDate");
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          //customAppbar(),
          isLoading
              ?  Center(
                  child:  Loader.load(),
                )
              : buildListTile()
        ],
      ),
    );
  }

  addShareData() async {
    var number = _mobileController.text.trim().replaceAll(' ', '');
    apis
        .shareBikeAddApi(
            widget.shareData.id.toString(),
            widget.shareData.bike?.id?.toString(),
            share_type,
            selectedCountry,
             number,
            _nameController.text.toString(),
            _fromDateController.text.toString(),
            _toDateController.text.toString(),
            widget.shareData.parkingSpotId?.toString())
        .then((value) {
      if (value?.status ?? false) {
        Dialogs().errorDialog(context, title: value?.message?.toString() ?? "", onTap: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
       // showMessageDialog(context, value?.message?.toString() ?? "");
        Dialogs().errorDialog(context, title: value?.message?.toString() ?? "", onTap: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      }
    });
  }

  shareRevoke(id) async {
    apis.shareBikeRevokeApi(id).then((value) {
      if (value?.status ?? false) {
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  productPartCatalogue() {
    var height = MediaQuery.of(context).size.height;
    return Container(
        height: height / 1.25,
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Column(
              children: List.generate(8, (index) => buildListTile()),
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  buildListTile() {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, ProductDetailScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("#" + widget.shareData.orderId.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: ts28)),
                      ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Container(
                      width: width / 1.1,
                      child: Text(
                          widget.shareData.parkingSport?.location.toString() ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: ts20)),
                    ),
                  ]),
                  const SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          widget.shareData.locker_no != null && widget.shareData.locker_no!.isNotEmpty
                              ? Text(
                                  "Locker No: ${widget.shareData.locker_no ?? ""}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ts22))
                              : SizedBox(),
                        ]),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!isShowAdd) {
                                isShowAdd = true;
                              } else {
                                isShowAdd = false;
                              }
                            });
                          },
                          child: Text("AddNewShare".tr(),
                              style: const TextStyle(
                                  decorationThickness: 1,
                                  decoration: TextDecoration.underline,
                                  color: lightGreyColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ts22)),
                        ),
                      ]),
                  const SizedBox(height: 30),
                  Container(
                      color: greyBgColor,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Image.network(
                                "${widget.shareData.bike?.imageUrl?.toString()}/${widget.shareData.bike?.bike_image?.toString()}",
                                errorBuilder: (context, error, stackTrace) {
                                  return SvgPicture.asset(
                                    icSmallBicycle,
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.fitWidth,
                                    color: lightGreyColor,
                                  ); //do something
                                },
                                height: 25,
                                width: 25,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                  widget.shareData.bike?.bikeName?.toString() ??
                                      "",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ts20)),
                            ]),
                            SvgPicture.asset(
                              icLock,
                              height: 30,
                              width: 30,
                              color: buttonColor,
                            ),
                          ])),
                  const SizedBox(height: 12),
                  isShowAdd ? addShare() : const SizedBox(),
                  ...widget.shareData.shareBike!.map((e) {
                    return shareUserSell(e);
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  shareUserSell(Share data) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      color: greyBgColor,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                SvgPicture.asset(
                  userMale,
                  height: 25,
                  width: 25,
                ),
                const SizedBox(width: 10),
                SizedBox(
                  child: Text(data.name.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: ts20)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: lightGreyColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                        data.shareType.toString() == "temporary"
                            ? "TEMPORARYSHARED".tr()
                            : "PERMANENTSHARED".tr(),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 0))),
              ],
            )
          ]),
          const SizedBox(height: 8),
          Row(children: [
            SvgPicture.asset(
              phone,
              height: 25,
              width: 25,
            ),
            const SizedBox(width: 10),
            Text(data.countryCode.toString() + " " + data.phone.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: ts20))
          ]),
          const SizedBox(height: 15),
          data.shareType.toString() != "permanent"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      SvgPicture.asset(
                        calendar,
                        height: 25,
                        width: 25,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          width: 150,
                          child: Text(data.startDateTime.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ts20)),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 25,
                        width: 3,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      SvgPicture.asset(
                        calendar,
                        height: 25,
                        width: 25,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          width: 150,
                          child: Text(data.endDateTime.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ts20)),
                        ),
                      ),
                    ])
              : const SizedBox(),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            height: 70,
            child: ElevatedButton(
                onPressed: () {
                  showAlertDialog(
                      context, "revokeAlert".tr(), data.id.toString());
                },
                child: Text(
                  "Revoke".tr(),
                  style: const TextStyle(
                      fontSize: ts18, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  primary: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(20),
                )),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  addShare() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text("SelectType".tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: ts20)),
                const SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Transform.scale(
                                scale: 1.3,
                                child: Radio(
                                  value: 1,
                                  groupValue: groupValue,
                                  onChanged: (index) {
                                    setState(() {
                                      groupValue = 1;
                                      share_type = "permanent";
                                    });
                                  },
                                  activeColor: buttonColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    groupValue = 1;
                                    share_type = "permanent";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text("Permanent".tr(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: ts20)),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                        onTap: () {

                                          showAlertDialog1(context,"Pending");
                                        },
                                        child: Icon(Icons.info_outline))
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              child: Transform.scale(
                                scale: 1.3,
                                child: Radio(
                                  value: 2,
                                  groupValue: groupValue,
                                  onChanged: (index) {
                                    setState(() {
                                      groupValue = 2;
                                      share_type = "temporary";
                                    });
                                  },
                                  activeColor: buttonColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    groupValue = 2;
                                    share_type = "temporary";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text("Temporary".tr(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: ts20)),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                        onTap: () {

                                          showAlertDialog1(context,"Pending");
                                        },
                                        child: Icon(Icons.info_outline))
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ]),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(1),
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      groupValue != 1
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                   /* var config =
                                    CalendarDatePicker2WithActionButtonsConfig(
                                      calendarType: CalendarDatePicker2Type.range,
                                      currentDate: DateTime.now(),
                                      firstDate: Jiffy(DateTime.now()).add(days: -1).dateTime,
                                      lastDate:
                                      Jiffy(DateTime.now()).add(days: 364).dateTime,
                                      selectedDayHighlightColor: Colors.purple[800],
                                      shouldCloseDialogAfterCancelTapped: true,
                                    );
                                    var values = await showCalendarDatePicker2Dialog(
                                      context: context,
                                      config: config,
                                      dialogSize: const Size(325, 400),
                                      borderRadius: 15,
                                      initialValue: _dialogCalendarPickerValue,
                                      dialogBackgroundColor: Colors.white,
                                    );
                                    if (values != null) {
                                      // ignore: avoid_print
                                      print(_getValueText(
                                        config.calendarType,
                                        values,
                                      ));
                                      setState(() {
                                        _dialogCalendarPickerValue = values;

                                        _selectTime1();
                                      });
                                    }*/
                                   // _selectDate(context, "From");
                                    checkInPopup("From");
                                  },
                                  child: IgnorePointer(
                                      child: CustomTextField(
                                          hintText: "FromDateTime".tr(),
                                          controller: _fromDateController,
                                          suffixIconAsset: icCalendar)),
                                ),
                                const SizedBox(height: 30.0),
                                InkWell(
                                  onTap: () async {

                                   /* var config =
                                    CalendarDatePicker2WithActionButtonsConfig(
                                      calendarType: CalendarDatePicker2Type.range,
                                      currentDate: DateTime.now(),
                                      firstDate: Jiffy(DateTime.now()).add(days: -1).dateTime,
                                      lastDate:
                                      Jiffy(DateTime.now()).add(days: 364).dateTime,
                                      selectedDayHighlightColor: Colors.purple[800],
                                      shouldCloseDialogAfterCancelTapped: true,
                                    );
                                    var values = await showCalendarDatePicker2Dialog(
                                      context: context,
                                      config: config,
                                      dialogSize: const Size(325, 400),
                                      borderRadius: 15,
                                      initialValue: _dialogCalendarPickerValue,
                                      dialogBackgroundColor: Colors.white,
                                    );
                                    if (values != null) {
                                      // ignore: avoid_print
                                      print(_getValueText(
                                        config.calendarType,
                                        values,
                                      ));
                                      setState(() {
                                        _dialogCalendarPickerValue = values;

                                        _selectTime1();
                                      });
                                    }
*/
                                    _fromDateController.text.isNotEmpty
                                        ? /*_selectDate(context, "To")*/  checkOutPopup("To")
                                        : const SizedBox();
                                  },
                                  child: IgnorePointer(
                                      child: CustomTextField(
                                          hintText: "ToDateTime".tr(),
                                          controller: _toDateController,
                                          suffixIconAsset: icCalendar)),
                                ),
                                const SizedBox(height: 30.0),
                              ],
                            )
                          : const SizedBox(),
                      CustomTextField(
                          keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MaskedInputFormater('00 000 00000000', anyCharMatcher: RegExp(r'[0-9]'))
                        ],
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
                          hintText: "mobileNumber".tr(),
                          controller: _mobileController,
                          ),
                      const SizedBox(height: 30.0),
                      CustomTextField(
                          keyboardType: TextInputType.name,
                          hintText: "fullName".tr(),
                          controller: _nameController),
                      const SizedBox(height: 40.0),
                      Container(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                            onPressed: () {
                              var number = _mobileController.text.trim().replaceAll(' ', '');
                              if (groupValue == 1) {
                                if (number.isEmpty) {
                                  showMessageDialog(
                                      context, "PleaseEnterMobileNumber".tr());
                                } else if (number.length < 6) {
                                  showMessageDialog(context,
                                      "PleaseEnterMobileValidNumber".tr());
                                } else if (_nameController.text.isEmpty) {
                                  showMessageDialog(
                                      context, "PleaseEnterName".tr());
                                } else {
                                  addShareData();
                                }
                              }
                              if (groupValue == 2) {
                                if (_fromDateController.text.isEmpty) {
                                  showMessageDialog(context,
                                      "PleaseEnterFromDateAndTime".tr());
                                } else if (_toDateController.text.isEmpty) {
                                  showMessageDialog(
                                      context, "PleaseEnterToDateAndTime".tr());
                                } else if (number.isEmpty) {
                                  showMessageDialog(
                                      context, "PleaseEnterMobileNumber".tr());
                                } else if (number.length < 6) {
                                  showMessageDialog(context,
                                      "PleaseEnterMobileValidNumber".tr());
                                } else if (_nameController.text.isEmpty) {
                                  showMessageDialog(
                                      context, "PleaseEnterName".tr());
                                }else if (differentHours(_fromDateController.text,_toDateController.text)) {
                                  showAlertDialog2(context, 'StartDateShouldBeGraterThanEndDate'.tr());
                                } else {
                                  addShareData();
                                }
                              }
                            },
                            child: Text(
                              "Share".tr(),
                              style: const TextStyle(
                                  fontSize: ts18, fontWeight: FontWeight.w500),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(20),
                            )),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _selectTime1() async {
    DatePicker.showTime12hPicker(context,
        showTitleActions: true,
        currentTime: DateTime.now(), onConfirm: (time) {
          setState(() {
            final localizations = MaterialLocalizations.of(context);
            final formattedTimeOfDay = localizations.formatTimeOfDay(TimeOfDay(hour: time.hour,minute: time.minute));
            String formattedDate = DateFormat(dateFormatHyphen)
                .format(_dialogCalendarPickerValue[0] ?? DateTime.now());

            _fromDateController.text =
                formattedDate + " " + formattedTimeOfDay.toString();
            _selectTime2();
            //pickedtime = "Picked time is : ${time.hour} : ${time.minute} : ${time.second}";
          });
        });

    //
    // TimeOfDay _time = TimeOfDay.now();
    // final TimeOfDay? newTime = await showTimePicker(
    //   helpText: "Select Start Time",
    //   context: context,
    //   initialTime: TimeOfDay.now(),
    // );
    // if (newTime != null) {
    //   setState(() {
    //     _time = newTime;
    //     // if (title == "In") {
    //     //   checkInController.text =
    //     //       date + " " + _time.format(context).toString();
    //     // }
    //     // if (title == "Out") {
    //     //   checkOutController.text =
    //     //       date + " " + _time.format(context).toString();
    //     // }
    //     final localizations = MaterialLocalizations.of(context);
    //     final formattedTimeOfDay = localizations.formatTimeOfDay(_time);
    //     String formattedDate = DateFormat(dateFormatHyphen)
    //         .format(_dialogCalendarPickerValue[0] ?? DateTime.now());
    //
    //     checkInController.text =
    //         formattedDate + " " + formattedTimeOfDay.toString();
    //     _selectTime2();
    //   });
    // }
  }

  void _selectTime2() async {

    DatePicker.showTime12hPicker(
        context,
        showTitleActions: true,
        currentTime: DateTime.now(),
        onConfirm: (time) {
          setState(() {
            final localizations = MaterialLocalizations.of(context);
            final formattedTimeOfDay = localizations.formatTimeOfDay(TimeOfDay(hour: time.hour,minute: time.minute));
            String formattedDate = DateFormat(dateFormatHyphen).format(_dialogCalendarPickerValue[1] ?? DateTime.now());
            _toDateController.text = formattedDate + " " + formattedTimeOfDay.toString();
            //pickedtime = "Picked time is : ${time.hour} : ${time.minute} : ${time.second}";
          });
        });
    // TimeOfDay _time = TimeOfDay.now();
    // final TimeOfDay? newTime = await showTimePicker(
    //   helpText: "Select End Time",
    //   context: context,
    //   initialTime: TimeOfDay.now(),
    // );
    // if (newTime != null) {
    //   setState(() {
    //     _time = newTime;
    //     // if (title == "In") {
    //     //   checkInController.text =
    //     //       date + " " + _time.format(context).toString();
    //     // }
    //     // if (title == "Out") {
    //     //   checkOutController.text =
    //     //       date + " " + _time.format(context).toString();
    //     // }
    //     final localizations = MaterialLocalizations.of(context);
    //     final formattedTimeOfDay = localizations.formatTimeOfDay(_time);
    //     String formattedDate = DateFormat(dateFormatHyphen)
    //         .format(_dialogCalendarPickerValue[1] ?? DateTime.now());
    //
    //     checkOutController.text =
    //         formattedDate + " " + formattedTimeOfDay.toString();
    //   });
    // }
  }


  showAlertDialog(BuildContext context, message, id) {
    Dialogs().confirmationDialog(context, message: message, onContinue: () {
      Navigator.pop(context);
      shareRevoke(id);
    });
  }

  showMessageDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }

  checkInPopup(String title) {
    _toDateController.text = "";
    //DateTime? dateTime;
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Wrap(
              children: [
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        width: MediaQuery.of(context).size.width,
                        color : buttonColor,
                        child: Text('selectDate'.tr(), textAlign : TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                          ),)),

                    Container(
                      transform: Matrix4.translationValues(0, -1, 0),
                      child: SfDateRangePicker(
                        showNavigationArrow: true,
                        enablePastDates: false,
                        todayHighlightColor: buttonColor,
                        selectionColor: buttonColor,
                        headerHeight: 70,
                        headerStyle: const DateRangePickerHeaderStyle(
                            backgroundColor: buttonColor,
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 25,
                              letterSpacing: 5,
                              color: Colors.black,
                            )),
                        monthViewSettings: const DateRangePickerMonthViewSettings(
                            viewHeaderHeight: 40,
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black))),
                        monthCellStyle: const DateRangePickerMonthCellStyle(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16),
                          disabledDatesTextStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16),
                          todayTextStyle: TextStyle(
                              color: buttonColor,
                              fontSize: 16),
                        ),
                        view: DateRangePickerView.month,
                        onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
                          if (args.value is DateTime) {
                            final DateTime selectedDate = args.value;
                            selectedStartDate = selectedDate;
                            print("start Time $selectedStartDate");
                          }
                        },
                        minDate: checkIn ?? DateTime.now(),
                        maxDate: checkOut ?? Jiffy(DateTime.now()).add(years: 2).dateTime,
                        selectionMode: DateRangePickerSelectionMode.single,
                        initialDisplayDate: DateTime.now(),
                        initialSelectedDate: checkIn /*?? DateTime.now()*/,


                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed:(){
                            Navigator.pop(context);
                          }, child:  Text("CANCEL".tr(), style: const TextStyle(color: Colors.black),)),
                          const SizedBox(width: 16,),
                          TextButton(onPressed:(){
                            if (selectedStartDate != null) {
                              Navigator.pop(context);
                              if(_toDateController.text.isNotEmpty){
                                  if (selectedStartDate!.difference(checkselectedEndDate!).inDays > 0) {
                                    showAlertDialog2(context, 'StartDateShouldBeGraterThanEndDate'.tr());
                                  }else{
                                    setState(() {
                                     // String dateSlug = "${selectedStartDate!.year.toString()}-${selectedStartDate!.month.toString().padLeft(2, '0')}-${selectedStartDate.day.toString().padLeft(2, '0')}";
                                      final DateFormat formatter = DateFormat(dateFormatHyphen);
                                      final String formatted = formatter.format(selectedStartDate!);
                                      _selectTime(title, formatted);
                                    });
                                  }
                                }else{
                                  setState(() {
                                    //String dateSlug = "${selectedStartDate!.year.toString()}-${selectedStartDate!.month.toString().padLeft(2, '0')}-${selectedStartDate.day.toString().padLeft(2, '0')}";
                                    final DateFormat formatter = DateFormat(dateFormatHyphen);
                                    final String formatted = formatter.format(selectedStartDate!);
                                    _selectTime(title, formatted);
                                  });

                                }

                            }else{
                              Fluttertoast.showToast(msg: "pleaseSelectDate".tr());
                            }
                          }, child:  Text("OK".tr(), style: const TextStyle(color: Colors.black),)),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkOutPopup(String title) {
    showDialog(
      context: context,
      builder: (_) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: Wrap(
              children: [
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        width: MediaQuery.of(context).size.width,
                        color : buttonColor,
                        child: Text('selectDate'.tr(),
                          textAlign : TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                          ),)),

                    Container(
                      transform: Matrix4.translationValues(0, -1, 0),
                      child: SfDateRangePicker(
                        showNavigationArrow: true,
                        enablePastDates: false,
                        todayHighlightColor: buttonColor,
                        selectionColor: buttonColor,
                        headerHeight: 70,
                        headerStyle: const DateRangePickerHeaderStyle(
                            backgroundColor: buttonColor,
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 25,
                              letterSpacing: 5,
                              color: Colors.black,
                            )),
                        monthViewSettings: const DateRangePickerMonthViewSettings(
                            viewHeaderHeight: 40,
                            viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black))),
                        monthCellStyle: const DateRangePickerMonthCellStyle(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16),
                          disabledDatesTextStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16),
                          todayTextStyle: TextStyle(
                              color: buttonColor,
                              fontSize: 16),
                        ),
                        view: DateRangePickerView.month,
                        onSelectionChanged: (DateRangePickerSelectionChangedArgs args){
                          if (args.value is DateTime) {
                            final DateTime selectedDate = args.value;
                            checkselectedEndDate = selectedDate;
                            print("end Time $checkselectedEndDate");
                          }
                        },
                        minDate: checkIn ?? DateTime.now(),
                        maxDate: checkOut ?? Jiffy(DateTime.now()).add(years: 2).dateTime,
                        selectionMode: DateRangePickerSelectionMode.single,
                        initialDisplayDate: DateTime.now(),
                        initialSelectedDate: checkIn /*?? DateTime.now()*/,

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed:(){
                            Navigator.pop(context);
                          }, child:  Text("CANCEL".tr(), style: const TextStyle(color: Colors.black),)),
                          const SizedBox(width: 16,),
                          TextButton(onPressed:(){
                            if(checkselectedEndDate != null) {
                              Navigator.pop(context);
                              if (selectedStartDate!.difference(checkselectedEndDate!).inDays > 0) {
                                showMessageDialog(context, 'EndDateShouldBeGraterThanStartDate'.tr());
                              } else {
                                setState(() {
                                  checkselectedEndDate = checkselectedEndDate!;
                                  final DateFormat formatter = DateFormat(dateFormatSlash);
                                  final String formatted = formatter.format(checkselectedEndDate!);
                                  // String dateSlug =
                                  //     "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                  _selectTime(title, formatted);
                                });
                              }
                            }else{
                              Fluttertoast.showToast(msg: "pleaseSelectDate".tr());
                            }
                          }, child:  Text("OK".tr(), style: const TextStyle(color: Colors.black),)),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<void> _selectDate(BuildContext context, String title) async {
    if (title == "From") {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: lightGreyColor,
                surface: Colors.pink, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null) {
        selectedStartDate = picked;

        if(_toDateController.text.isNotEmpty){
          if (selectedStartDate!.difference(checkselectedEndDate!).inDays > 0) {
            showAlertDialog2(context, 'StartDateShouldBeGraterThanEndDate'.tr());
          }else{
            setState(() {
              String dateSlug =
                  "${selectedStartDate!.year.toString()}-${selectedStartDate!.month.toString().padLeft(2, '0')}-${selectedStartDate!.day.toString().padLeft(2, '0')}";
              final DateFormat formatter = DateFormat(dateFormatHyphen);
              final String formatted = formatter.format(selectedStartDate!);
              _selectTime(title, formatted);
            });
          }
        }else{
          setState(() {
            String dateSlug =
                "${selectedStartDate!.year.toString()}-${selectedStartDate!.month.toString().padLeft(2, '0')}-${selectedStartDate!.day.toString().padLeft(2, '0')}";
            final DateFormat formatter = DateFormat(dateFormatHyphen);
            final String formatted = formatter.format(selectedStartDate!);
            _selectTime(title, formatted);
          });

        }

      }
    } else {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: lightGreyColor,
                surface: Colors.pink, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      ).then((value) {
        setState(() {
          checkselectedEndDate = value!;
        });

        if (selectedStartDate!.difference(checkselectedEndDate!).inDays > 0) {
          showMessageDialog(context, 'EndDateShouldBeGraterThanStartDate'.tr());
        } else {
          setState(() {
            selectedStartDate = value!;
            final DateFormat formatter = DateFormat(dateFormatSlash);
            final String formatted = formatter.format(selectedStartDate!);
            // String dateSlug =
            //     "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
            _selectTime(title, formatted);
          });
        }
      });
    }
  }



  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        var startDate = values[0].toString().replaceAll('00:00:00.000', '');
        var endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
  showAlertDialog2(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }
  void _selectTime(title, date) async {
    String value;
    if (title == "From") {
      value = "Select From Time";
    } else {
      value = "Select To Time";
    }
    _showDialog(

        CupertinoDatePicker(
          //initialDateTime: DateTime(DateTime.now().year , 1, 1),
          initialDateTime: checkIn ?? DateTime.now(),
          mode: CupertinoDatePickerMode.time,
          minuteInterval : 5,
          minimumDate: checkIn ?? DateTime.now(),
          maximumDate: checkOut ?? Jiffy(DateTime.now()).add(years: 2).dateTime,
          // maximumDate: DateTime.now(),
          // This is called when the user changes the date.
          onDateTimeChanged: (DateTime time) {
            setState(() {
              final localizations = MaterialLocalizations.of(context);
              final formattedTimeOfDay = localizations.formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute));

              if (title == "From") {
                _fromDateController.text =
                    date.toString() + " " + formattedTimeOfDay.toString();
              }
              if (title == "To") {
                _toDateController.text =
                    date.toString() + " " + formattedTimeOfDay.toString();
              }
            });
          },
        ));
   /* DatePicker.showTime12hPicker(context,
        title: value,
        showTitleActions: true,
        currentTime: DateTime.now(),
        onConfirm: (time) {

          setState(() {
            final localizations = MaterialLocalizations.of(context);
            final formattedTimeOfDay = localizations.formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute));

            if (title == "From") {
              _fromDateController.text =
                  date.toString() + " " + formattedTimeOfDay.toString();
            }
            if (title == "To") {
              _toDateController.text =
                  date.toString() + " " + formattedTimeOfDay.toString();
            }
          });
        });*/


    // TimeOfDay _time = TimeOfDay.now();
    // final TimeOfDay? newTime = await showTimePicker(
    //   context: context,
    //   initialTime: TimeOfDay.now(),
    // );
    // if (newTime != null) {
    //   setState(() {
    //     _time = newTime;
    //     // if (title == "In") {
    //     //   checkInController.text =
    //     //       date + " " + _time.format(context).toString();
    //     // }
    //     // if (title == "Out") {
    //     //   checkOutController.text =
    //     //       date + " " + _time.format(context).toString();
    //     // }
    //     final localizations = MaterialLocalizations.of(context);
    //     final formattedTimeOfDay = localizations.formatTimeOfDay(_time);
    //
    //   });
    // }
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

/*
  void _selectTime(title, date) async {
    TimeOfDay _time = TimeOfDay.now();
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        final localizations = MaterialLocalizations.of(context);
        final formattedTimeOfDay = localizations.formatTimeOfDay(_time);
        if (title == "From") {
          _fromDateController.text = date + " " + formattedTimeOfDay;
        }
        if (title == "To") {
          _toDateController.text = date + " " + formattedTimeOfDay;
        }
      });
    }
  }
*/

  showAlertDialog1(BuildContext context,message) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Pedalocker"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class TabItemModel {
  int id;
  bool isStatus;
  String name;

  TabItemModel({required this.id, required this.isStatus, required this.name});
}
