import 'package:cycle_lock/ui/main/cart_screen.dart';
import 'package:cycle_lock/ui/main/parking_spot_details_screen.dart';
import 'package:cycle_lock/ui/main/parking_spots_screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/strings.dart';
import 'package:date_util/date_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:math' as math;
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../../network/api_provider.dart';
import '../../responses/added_bike_list_response.dart';
import '../../responses/chec_spo_availability_response.dart';
import '../../responses/find_spots_list_response.dart';
import '../../responses/parking_spots_details_response.dart';
import '../../utils/dialogs.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../onboarding/bike_detail_screen.dart';
import '../widgets/heading_medium.dart';
import '../widgets/primary_button.dart';
import '../widgets/tag.dart';
import 'dashboard_screen.dart';
import 'delete.dart';
import 'make_payment_screen.dart';

class EditBookingScreen extends StatefulWidget {
  final String? soptId;
  final String? bikeName;
  final String? bikeIds;
  final String? check_in_date;
  final String? check_out_date;
  final String? bookingId;

  const EditBookingScreen(
      {Key? key,
      this.soptId,
      this.bookingId,
      this.bikeIds,
      this.check_out_date,
      this.check_in_date,
      this.bikeName = ''})
      : super(key: key);

  @override
  _EditBookingScreenState createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();
  //late CalendarController _controller;
  late Map<DateTime, List<dynamic>> _events = {};
  String bikeIds = "";
  String arrayCounters = "";
  int totalAmount = 0;
  String selectedSpotsIds = "";
  String checkInDateValue = "";
  var total_space = 0;
  late DateTime checkselectedEndDate;
  var today = DateTime.now();

  String checkOutDateValue = "";
  late DateTime selectedStartDate;
  DateTime tableStartDate = DateTime.now();
  late DateTime tableEndDate;

  late DateTime selectedEndDate;

  Apis apis = Apis();
  bool isLoading = false;
  bool isMakePayment = false;
  List<BikeData>? bikeData;
  List<CheckSpotAvailability>? checkAvailabilityListData;
  List<FindSpots>? findSpotsList;
  Data? spotsDetail;
  List<DateTime> list = [];

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime(2022, 3, 9)
  ];
  List<DateTime?> _multiDatePickerValueWithDefaultValue = [
    DateTime(DateTime.now().year, DateTime.now().month, 1),
    DateTime(DateTime.now().year, DateTime.now().month, 5),
    DateTime(DateTime.now().year, DateTime.now().month, 14),
    DateTime(DateTime.now().year, DateTime.now().month, 17),
    DateTime(DateTime.now().year, DateTime.now().month, 25),
  ];
  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime(1999, 5, 6),
    DateTime(1999, 5, 21),
  ];

  List<DateTime?> _rangeDatePickerWithActionButtonsWithValue = [
    DateTime(2022, 5, 20),
    DateTime(2022, 5, 25)
  ];
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
    Jiffy(DateTime.now()).add(days: 1).dateTime,
  ];

  @override
  void initState() {
    checkInController.text = widget.check_in_date ?? "";
    checkOutController.text = widget.check_out_date ?? "";
    parkingSportDetailsApi();
    addedBikeListing();
   // _controller = CalendarController();
    super.initState();
  }

  addedBikeListing() async {
    //showLoader(context);
    setState(() {
      isLoading = true;
    });
    apis.addBikeListingApi().then((value) {
      isLoading = false;
      if (value?.status ?? false) {
        print("Bike Name  ---" + (widget.bikeIds ?? ""));
        setState(() {
          bikeData = value!.data;
          if (widget.bikeIds != null) {
            for (var a in bikeData!) {
              print("Bike Name  ---" + (widget.bikeIds ?? ""));
              print("Bike Name  ---" + (a.id.toString()));

              if (widget.bikeIds.toString().contains(a.id.toString())) {
                a.isSelect = true;
              }
            }
          }
          bikeData
              ?.add(BikeData(bike_name: ">>>>>>>>>>", image: icSmallBicycle));
          for (var element in bikeData!) {
            if (element.bike_name == widget.bikeName) {
              element.isSelect = true;
            }
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  checkAvailability() async {
    setState(() {
      isLoading = true;
    });
    apis
        .checkSpotAvailabilityApi(spotsDetail?.id?.toString() ?? "")
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value?.status ?? false) {
        setState(() {
          checkAvailabilityListData = value!.data;
// fhsdfhsdfa
          DateTime date = DateTime.now();
          for (var value in checkAvailabilityListData!) {
            var count = value.totalSpace! - value.bookOrder!;
            List<dynamic> zeros = List.filled(count, 0);
            _events[DateTime.parse(value.checkInDate!)] = [...zeros];
          }

/*
          for (var a = 0; a <= 60; a++) {
            for (var value in checkAvailabilityListData!) {
              //list.add(DateTime.parse(value.checkInDate!.toString()));
              if (DateTime.parse(value.checkInDate!.toString()) ==
                  (DateTime(date.year, date.month, date.day + a))) {
                var count = value.totalSpace! - value.bookOrder!;
                List<dynamic> zeros = List.filled(count, 0);
                _events[DateTime.parse(value.checkInDate!)] = [...zeros];
              } else {
                List<dynamic> zerosValue = List.filled(total_space, 0);
                _events[DateTime(date.year, date.month, date.day + a)] = [
                  ...zerosValue
                ];
              }
            }
            // if (DateTime(date.year, date.month, date.day + a) == DateTime.parse(value.checkInDate!)) {
            // } else {
            //
            // }
          }
*/

          isLoading = false;
        });
      } else {
        setState(() {
          DateTime date = DateTime.now();
          var dateUtility = DateUtil();
          var day1 = dateUtility.daysInMonth(int.parse(date.month.toString()),
              int.parse(date.year.toString()));
          var days = (day1 - date.day);
          List<dynamic> zeros = List.filled(total_space, 0);
          for (var a = 0; a <= 60; a++) {
            //     (DateTime(date.year, date.month, date.day + a)).toString());
            // _events.addEntries(: ['Meeting URUS']);
            _events[DateTime(date.year, date.month, date.day + a)] = [...zeros];
          }
          isLoading = false;
        });
      }
    });
  }

  getFindSpotsData() {
    setState(() {
      isLoading = true;
    });
    apis
        .getFindSpot(
            spotsDetail?.id?.toString() ?? "",
            bikeIds,
            checkInController.text.toString(),
            checkOutController.text.toString())
        .then((value) {
      setState(() {
        isMakePayment = false;
        isLoading = false;
        if (value?.status ?? false) {
          findSpotsList = value!.data;
          if (findSpotsList?.length == 1) {
            for (var a in findSpotsList!) {
              if (a.available == "available") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartScreen(
                              parking_spot_id: spotsDetail?.id.toString() ?? "",
                              arrayCounters: a.array_counter.toString(),
                              bike_id: a.id.toString(),
                              check_in_date: checkInController.text.toString(),
                              check_out_date:
                                  checkOutController.text.toString(),
                            )));
              }
            }
          }
        } else {
          isLoading = false;
        }
      });
    });
  }

  Widget _buildEventsMarkerNum(DateTime date, List events) {
    return Container(
      height: 70,
      width: 60,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),

      child: Column(
        children: [
          Text(date.day.toString(),
              style: const TextStyle(fontSize: 6.0, color: Colors.white)),
          Text(events.length.toString(),
              style: const TextStyle(fontSize: 6.0, color: Colors.white)),
        ],
      ),
      // Column(
      //   children: [
      //
      //     Text(events.length.toString(), style: const TextStyle(fontSize: 6,color: Colors.white)),
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(title: "editBooking".tr()),
      body: SingleChildScrollView(
        child: spotsDetail != null
            ? Column(
                children: [
                  Container(
                    color: greyColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              spotsDetail?.name?.toString() ?? "",
                              style: const TextStyle(
                                  fontSize: ts30, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              spotsDetail?.distance?.toString() ?? "",
                              style: const TextStyle(
                                  fontSize: ts22, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  icStar,
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "${spotsDetail?.avgRate?.toString()} ( ${spotsDetail?.totalRate?.toString()} Review)",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18)),
                              ],
                            ),
                            spotsDetail?.markParkingSpotAsFeatured == "1"
                                ? tag("FEATURED".tr())
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: animatedColumn(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("SelectBike".tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: ts20)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        bikeData != null
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: bikeData?.length ?? 0,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent:
                                      MediaQuery.of(context).size.width * .250,
                                ),
                                itemBuilder: (_, index) =>
                                    buildCarCard(index, setState),
                              )
                            : Center(
                                child: Text("NoBikeAddedPlease".tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: ts20)),
                              ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () async {
                            // var config =
                            //     CalendarDatePicker2WithActionButtonsConfig(
                            //   calendarType: CalendarDatePicker2Type.range,
                            //   currentDate: DateTime.now(),
                            //   firstDate:
                            //       Jiffy(DateTime.now()).add(days: -1).dateTime,
                            //   lastDate:
                            //       Jiffy(DateTime.now()).add(days: 364).dateTime,
                            //   selectedDayHighlightColor: Colors.purple[800],
                            //   shouldCloseDialogAfterCancelTapped: true,
                            // );
                            // var values = await showCalendarDatePicker2Dialog(
                            //   context: context,
                            //   config: config,
                            //   dialogSize: const Size(325, 400),
                            //   borderRadius: 15,
                            //   initialValue: _dialogCalendarPickerValue,
                            //   dialogBackgroundColor: Colors.white,
                            // );
                            // if (values != null) {
                            //   // ignore: avoid_print
                            //   print(_getValueText(
                            //     config.calendarType,
                            //     values,
                            //   ));
                            //   setState(() {
                            //     _dialogCalendarPickerValue = values;
                            //     _selectTime1();
                            //   });
                            // }

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const DeleteScreen()));
                            _selectDate(context, "In");
                          },
                          child: IgnorePointer(
                              child: CustomTextField(
                                  hintSizes: 20.0,
                                  hintColors: Colors.black,
                                  hintText: "checkInDate".tr(),
                                  controller: checkInController,
                                  suffixIconAsset: icCalendar)),
                        ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () async {
                            // var config =
                            //     CalendarDatePicker2WithActionButtonsConfig(
                            //   calendarType: CalendarDatePicker2Type.range,
                            //   currentDate: DateTime.now(),
                            //   firstDate:
                            //       Jiffy(DateTime.now()).add(days: -1).dateTime,
                            //   lastDate:
                            //       Jiffy(DateTime.now()).add(days: 364).dateTime,
                            //   selectedDayHighlightColor: Colors.purple[800],
                            //   shouldCloseDialogAfterCancelTapped: true,
                            // );
                            // var values = await showCalendarDatePicker2Dialog(
                            //   context: context,
                            //   config: config,
                            //   dialogSize: const Size(325, 400),
                            //   borderRadius: 15,
                            //   initialValue: _dialogCalendarPickerValue,
                            //   dialogBackgroundColor: Colors.white,
                            // );
                            // if (values != null) {
                            //   // ignore: avoid_print
                            //   print(_getValueText(
                            //     config.calendarType,
                            //     values,
                            //   ));
                            //   setState(() {
                            //     _dialogCalendarPickerValue = values;
                            //     _selectTime1();
                            //   });
                            // }

                            checkInController.text.isNotEmpty
                                ? _selectDate(context, "Out")
                                : const SizedBox();
                          },
                          child: IgnorePointer(
                              child: CustomTextField(
                                  hintSizes: 20.0,
                                  hintColors: Colors.black,
                                  hintText: "checkOutDate".tr(),
                                  controller: checkOutController,
                                  suffixIconAsset: icCalendar)),
                        ),
                        const SizedBox(height: 30),
                        PrimaryButton(
                            onPressed: () {
                              bikeIds = "";
                              totalAmount = 0;
                              for (var a in bikeData!) {
                                if (a.isSelect) {
                                  if (bikeIds == "") {
                                    bikeIds = a.id.toString();
                                  } else {
                                    bikeIds += "," + a.id.toString();
                                  }
                                  if (totalAmount == 0) {
                                    totalAmount = int.parse(a.bikeValue!);
                                  } else {
                                    totalAmount += int.parse(a.bikeValue!);
                                  }
                                }
                              }

                              if (bikeIds.isEmpty) {
                                showAlertDialog(
                                    context, "PleaseSelectBike".tr());
                              } else if (checkInController.text.isEmpty) {
                                showAlertDialog(
                                    context, "PleaseSelectCheckInDate".tr());
                              } else if (checkOutController.text.isEmpty) {
                                showAlertDialog(
                                    context, "PleaseSelectCheckOutDate".tr());
                              } else if (checkInController.text ==
                                  checkOutController.text) {
                                showAlertDialog(context,
                                    "PleaseSelectDifferentCheckOutDate".tr());
                              } else {
                                editOrderApi(
                                    context,
                                    bikeIds,
                                    checkInController.text.toString(),
                                    checkOutController.text.toString());
                              }
                            },
                            title: Text("editBooking".tr(),
                                style: const TextStyle(fontSize: ts22))),
                      ],
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.only(top: height / 2 - 100),
                child:  Center(
                  child: Loader.load(),
                ),
              ),
      ),
    );
  }

  bool checkDate(var startDate, var endDate) {
    DateTime start = DateFormat(dateFormatHyphen).parse(startDate.toString());
    DateTime end = DateFormat(dateFormatHyphen).parse(endDate.toString());

    if (start.difference(end).inHours >= 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _selectDate(BuildContext context, String title) async {
    if (title == "In") {
      print("picked");

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: Jiffy(DateTime.now()).add(days: 364).dateTime,
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
            child: Container(
              height: 700,
              width: 700,
              child: child,
            ),
          );
        },
      );

      if (picked != null) {
        selectedStartDate = picked;
        if (checkOutController.text.isNotEmpty) {
          if (selectedStartDate.difference(checkselectedEndDate).inDays > 0) {
            showAlertDialog(context, 'StartDateShouldBeGraterThanEndDate'.tr());
          } else {
            setState(() {
              String dateSlug =
                  "${selectedStartDate.year.toString()}-${selectedStartDate.month.toString().padLeft(2, '0')}-${selectedStartDate.day.toString().padLeft(2, '0')}";
              final DateFormat formatter = DateFormat(dateFormatHyphen);
              final String formatted = formatter.format(selectedStartDate);
              _selectTime(title, formatted);
            });
          }
        } else {
          setState(() {
            String dateSlug =
                "${selectedStartDate.year.toString()}-${selectedStartDate.month.toString().padLeft(2, '0')}-${selectedStartDate.day.toString().padLeft(2, '0')}";
            final DateFormat formatter = DateFormat(dateFormatHyphen);
            final String formatted = formatter.format(selectedStartDate);
            _selectTime(title, formatted);
          });
        }
      } else {
        print("unpicked");
      }
    } else {
      checkOutController.text = "";
      final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
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
              lastDate: Jiffy(DateTime.now()).add(days: 364).dateTime)
          .then((value) {
        setState(() {
          checkselectedEndDate = value!;
          if (selectedStartDate.difference(checkselectedEndDate).inDays > 0) {
            showAlertDialog(context, 'EndDateShouldBeGraterThanStartDate'.tr());
          } else {
            setState(() {
              setState(() {
                final DateFormat formatter = DateFormat(dateFormatHyphen);
                final String formatted = formatter.format(checkselectedEndDate);
                _selectTime(title, formatted);
              });
            });
          }
        });
      });
    }
  }

  void _selectTime(title, date) async {
    String value;
    if (title == "In") {
      value = "Check in Time";
    } else {
      value = "Check out Time";
    }
    DatePicker.showTime12hPicker(context,
        title: value,
        showTitleActions: true,
        currentTime: DateTime.now(), onConfirm: (time) {
      setState(() {
        final localizations = MaterialLocalizations.of(context);
        final formattedTimeOfDay = localizations
            .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute));
        if (title == "In") {
          checkInController.text =
              date.toString() + " " + formattedTimeOfDay.toString();
        }
        if (title == "Out") {
          checkOutController.text =
              date.toString() + " " + formattedTimeOfDay.toString();
        }
      });
    });

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

  void _selectTime1() async {
    DatePicker.showTime12hPicker(context,
        title: "CheckIn Time",
        showTitleActions: true,
        currentTime: DateTime.now(), onConfirm: (time) {
      setState(() {
        final localizations = MaterialLocalizations.of(context);
        final formattedTimeOfDay = localizations
            .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute));
        String formattedDate = DateFormat(dateFormatHyphen)
            .format(_dialogCalendarPickerValue[0] ?? DateTime.now());
        selectedStartDate = _dialogCalendarPickerValue[0] ?? DateTime.now();
        checkselectedEndDate = _dialogCalendarPickerValue[1] ?? DateTime.now();
        //if (selectedStartDate.difference(checkselectedEndDate).inDays > 0) {
        checkInController.text =
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
    DatePicker.showTime12hPicker(context,
        title: "CheckOut Time",
        showTitleActions: true,
        currentTime: DateTime.now(), onConfirm: (time) {
      setState(() {
        final localizations = MaterialLocalizations.of(context);
        final formattedTimeOfDay = localizations
            .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute));
        String formattedDate = DateFormat(dateFormatHyphen)
            .format(_dialogCalendarPickerValue[1] ?? DateTime.now());
        checkOutController.text =
            formattedDate + " " + formattedTimeOfDay.toString();
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

  showAlertDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }

  showPutMeAlertDialog(BuildContext context, String message, spotId) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK".tr(), style: const TextStyle(color: lightGreyColor)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget openSpotButton = TextButton(
      child: Text("ShowAvailableContainer".tr()),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ParkingSpotDetailsScreen(soptId: spotId)));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert".tr()),
      content: Text(message),
      actions: [openSpotButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /*openSpotAvailability() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "availableSpots".tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: ts26),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset(
                            icClose,
                            height: 25,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(height: 0, thickness: 2, color: Colors.grey.shade300),
                TableCalendar(
                  initialCalendarFormat: CalendarFormat.month,
                  initialSelectedDay: tableStartDate,
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekendStyle: TextStyle(
                      color: Colors.black,
                    ),
                    weekdayStyle: TextStyle(color: Colors.black),
                  ),
                  startDay: DateTime.now(),
                  onDaySelected: (selectedDay, focusedDay, focusedDay2) {
                    // final DateFormat formatter = DateFormat(dateFormatHyphen);
                    // final String formatted = formatter.format(selectedDay);
                    // if (checkInController.text.toString().isEmpty) {
                    //   checkInController.text = formatted.toString();
                    //   Navigator.pop(context);
                    // } else {
                    //   DateTime start = DateFormat(dateFormatHyphen)
                    //       .parse(checkInController.text.toString());
                    //   DateTime end =
                    //       DateFormat(dateFormatHyphen).parse(formatted);
                    //   if (start.difference(end).inDays >= 0) {
                    //     Navigator.pop(context);
                    //     showAlertDialog(
                    //         context, 'EndDateShouldBeGraterThanStartDate'.tr());
                    //   } else {
                    //     Navigator.pop(context);
                    //     checkOutController.text = formatted.toString();
                    //    }
                    // }
                  },
                  endDay: Jiffy(DateTime.now()).add(days: 364).dateTime,
                  builders: CalendarBuilders(
                    // outsideWeekendDayBuilder: (context, date, _) {
                    //   String weeks = date.weekday.toString().trimRight();
                    //   return Text(weeks);
                    // },

                    markersBuilder: (context, date, events, holidays) {
                      final children = <Widget>[];
                      if (events.isNotEmpty) {
                        children.add(
                          Positioned(
                            bottom: 1,
                            child: _buildEventsMarkerNum(date, events),
                          ),
                        );
                      }
                      return children;
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    todayColor: Color(0x9429AAE1),
                    selectedColor: Color(0xFF29AAE1),
                    markersColor: Color(0xFFA2CD3A),
                    weekendStyle: TextStyle(color: Colors.black),
                    weekdayStyle: TextStyle(color: Colors.black),
                  ),
                  headerStyle: const HeaderStyle(
                      centerHeaderTitle: true,
                      leftChevronIcon: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 30,
                        color: Colors.grey,
                      ),
                      rightChevronIcon: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 30,
                        color: Colors.grey,
                      ),
                      titleTextStyle: TextStyle(
                          fontSize: ts24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  availableCalendarFormats: const {
                    CalendarFormat.month: '',
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarController: _controller,
                  events: _events,
                ),
              ],
            ),
          );
        });
  }*/

  buildCarCard(index1, setState) {
    return GestureDetector(
      onTap: () {
        if (bikeData?[index1].bike_name == ">>>>>>>>>>") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BikeDetailScreen(
                        isRegistering: false,
                      ))).then((value) {
            if (value == "update") {
              parkingSportDetailsApi();
              addedBikeListing();
            }
          });
        } else {
          setState(() {
            if (bikeData![index1].isSelect) {
              bikeData![index1].isSelect = false;
            } else {
              bikeData![index1].isSelect = true;
            }
          });
        }
      },
      child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  bikeData![index1].isSelect ? lightGreyColor : Colors.black38,
              style: BorderStyle.solid,
              width: bikeData![index1].isSelect ? 2.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    bikeData?[index1].bike_name == ">>>>>>>>>>"
                        ? const Icon(Icons.add, size: 50)
                        : Image.network(
                            "${bikeData![index1].image_url}/${bikeData![index1].bike_image}",
                            errorBuilder: (context, error, stackTrace) {
                              return SvgPicture.asset(
                                icSmallBicycle,
                                width: 25,
                                height: 25,
                                fit: BoxFit.fitWidth,
                                color: lightGreyColor,
                              ); //do something
                            },
                            height: 40,
                            width: 80,
                          ),
                    Text(
                        bikeData![index1].bike_name.toString() != ">>>>>>>>>>"
                            ? bikeData![index1].bike_name.toString()
                            : "addBike".tr(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: ts18)),
                  ],
                ),
                Container(
                    alignment: Alignment.topRight,
                    child: bikeData![index1].isSelect
                        ? SvgPicture.asset(icCheck1, height: 25)
                        : const SizedBox())
              ],
            ),
          )),
    );
  }

  parkingSportDetailsApi() async {
    setState(() {
      isLoading = true;
    });
    apis.parkingSportDetailsApi(widget.soptId ?? "").then((value) {
      if (value?.status ?? false) {
        setState(() {
          spotsDetail = value?.data!;
          isLoading = false;
          total_space = spotsDetail?.totalSpace ?? 0;
          checkAvailability();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  putMeNotifyApi(bikeId) async {
    Loaders().loader(context);
    apis
        .putMeNotifyApi(
            spotsDetail?.id?.toString() ?? "",
            bikeId,
            checkInController.text.toString(),
            checkOutController.text.toString())
        .then((value) {
      Navigator.of(context).pop();

      if (value?.status ?? false) {
        showPutMeAlertDialog(context, value?.message.toString() ?? "",
            value?.data?.parkingSpotId?.toString());
        setState(() {
          isLoading = false;
        });
      } else {
        showAlertDialog(context, value?.message.toString() ?? "");
        setState(() {
          isLoading = false;
        });
      }
    });
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

  editOrderApi(
    BuildContext context,
    String? bike_id,
    String? check_in_date,
    String? check_out_date,
  ) async {
    showLoader(context);
    setState(() {
      isLoading = true;
    });
    apis
        .orderEditApi(bike_id ?? "", check_in_date ?? "", check_out_date ?? "",
            widget.bookingId ?? "")
        .then((value) {
      isLoading = false;
      if (value?.status ?? false) {
        Fluttertoast.showToast(msg: value?.message ?? "");
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  showAlertDialog1(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK".tr(), style: const TextStyle(color: lightGreyColor)),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert".tr()),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
