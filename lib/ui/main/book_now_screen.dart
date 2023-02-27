import 'dart:io';

import 'package:calendar_view/calendar_view.dart';
import 'package:cycle_lock/ui/main/cart_screen.dart';
import 'package:cycle_lock/ui/main/parking_spot_details_screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/strings.dart';
import 'package:cycle_lock/utils/utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';

//import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cycle_lock/responses/find_spots_list_response.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../event/event.dart';
import '../../network/api_provider.dart';
import '../../responses/added_bike_list_response.dart';
import '../../responses/chec_spo_availability_response.dart';

import '../../responses/parking_spots_details_response.dart';
import '../../utils/dialogs.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../onboarding/bike_detail_screen.dart';
import '../widgets/heading_medium.dart';
import '../widgets/primary_button.dart';
import '../widgets/tag.dart';
import 'dashboard_screen.dart';

class BookNowScreen extends StatefulWidget {
  final String? soptId;
  final String? bikeName;
  final String? bikeIds;

  const BookNowScreen({Key? key, this.soptId, this.bikeIds, this.bikeName = ''})
      : super(key: key);

  @override
  _BookNowScreenState createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();

  // late CalendarController _controller;
  late final Map<DateTime, List<dynamic>> _events = {};
  String bikeIds = "";
  String arrayCounters = "";
  int totalAmount = 0;
  String selectedSpotsIds = "";
  String checkInDateValue = "";
  var total_space = 0;
  DateTime? checkselectedEndDate;
  var today = DateTime.now();

  String checkOutDateValue = "";
  DateTime? selectedStartDate;
  DateTime tableStartDate = DateTime.now();
  late DateTime tableEndDate;

  DateTime? selectedEndDate;

  Apis apis = Apis();
  bool isLoading = false;
  bool isMakePayment = false;
  List<BikeData>? bikeData;
  List<CheckSpotAvailability>? checkAvailabilityListData;
  List<FindSpots>? findSpotsList;
  FindSpotsListRequest? request;
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

  /*List<DateTime?> _dialogCalendarPickerValue = [
  ];*/

  /* List<DateTimeRange?> _dialogCalendarPickerValue = [
  ];*/

 /* DateTimeRange? _dialogCalendarPickerValue = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );*/

 /* PickerDateRange? _dialogCalendarPickerValue = PickerDateRange(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(const Duration(days: 1)),
  );*/

  PickerDateRange? _dialogCalendarPickerValue = PickerDateRange(
      DateTime.now(),
      DateTime.now().add(const Duration(days: 1))
  );


  DateTime? startTime;
  DateTime? endTime;

  @override
  void initState() {
    parkingSportDetailsApi();
    addedBikeListing();
    //_controller = CalendarController();
    super.initState();

    // _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
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

  /* checkAvailability() async {
    setState(() {
      isLoading = true;
    });
    apis.checkSpotAvailabilityApi(spotsDetail?.id?.toString() ?? "")
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value?.status ?? false) {
        setState(() {
          checkAvailabilityListData = value!.data;
          DateTime date = DateTime.now();
          for (var value in checkAvailabilityListData!) {
            var count;
            if(value.totalSpace!=null && value.totalSpace!=0  ){
               count = value.totalSpace! - value.bookOrder!;
            }else{
              count = 0 ;
            }
            List<dynamic> zeros = List.filled(count, 0);
            _events[DateTime.parse(value.checkInDate!)] = [...zeros];
          }
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
  }*/

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
          request = value.request;
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

  rangePopup() {
   // PickerDateRange? pickerDateRange;
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
                        child:  Text('selectDate'.tr(),
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
                        startRangeSelectionColor: buttonColor,
                        endRangeSelectionColor: buttonColor,
                        rangeSelectionColor: buttonColorAlfa,
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
                        onSelectionChanged: (DateRangePickerSelectionChangedArgs dateRangePickerSelection){
                          _dialogCalendarPickerValue = dateRangePickerSelection.value;
                          print("sasasa ${_dialogCalendarPickerValue?.startDate}");
                        },
                        minDate:Jiffy(DateTime.now())
                              .add(days: -1)
                              .dateTime,
                         maxDate: Jiffy(DateTime.now())
                              .add(years: 2)
                              .dateTime,
                        selectionMode: DateRangePickerSelectionMode.range,
                        initialSelectedRange: _dialogCalendarPickerValue
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
                            if(_dialogCalendarPickerValue?.startDate != null && _dialogCalendarPickerValue?.endDate != null){
                              Navigator.pop(context);
                              setState(() {
                              //  _dialogCalendarPickerValue = _dialogCalendarPickerValue;
                                _selectTime1();
                              });
                            }else{
                              Fluttertoast.showToast(msg: "pleaseSelectTwoDates".tr());
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(title: "bookNow".tr(), actions: [
        GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardScreen()),
                  (route) => false);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.home_outlined,
                size: 40,
                color: buttonColor,
              ),
            ))
      ]),
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
                                    "${spotsDetail?.avgRate?.toString()} ( ${spotsDetail?.totalRate?.toString()} ${"Review".tr()})",
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
                            GestureDetector(
                              onTap: () async {
                                /*var config = CalendarDatePicker2WithActionButtonsConfig(
                                  calendarType: CalendarDatePicker2Type.range,
                                  currentDate: DateTime.now(),
                                  firstDate:Jiffy(DateTime.now())
                                      .add(days: -1)
                                      .dateTime,
                                  lastDate:Jiffy(DateTime.now())
                                      .add(years: 2)
                                      .dateTime,
                                  selectedDayHighlightColor: buttonColor,
                                  shouldCloseDialogAfterCancelTapped: true,

                                );
                                var values =
                                    await showCalendarDatePicker2Dialog(
                                  context: context,
                                  config: config,
                                  dialogSize: const Size(325, 425),
                                  borderRadius: 2,
                                  initialValue: _dialogCalendarPickerValue,
                                  dialogBackgroundColor: Colors.white,
                                );*/

                                rangePopup();

                                /* final themeData = Theme.of(context);
                                final DateTimeRange? newDateRange = await showDateRangePicker(
                                  context: context,


                                  initialDateRange: _dialogCalendarPickerValue,
                                    firstDate:Jiffy(DateTime.now())
                                        .add(days: -1)
                                        .dateTime,
                                    lastDate:Jiffy(DateTime.now())
                                    .add(years: 2)
                                    .dateTime,
                                  builder: (context, Widget? child) => Theme(
                                    data: themeData.copyWith(
                                        appBarTheme: themeData.appBarTheme.copyWith(
                                            backgroundColor: buttonColor,
                                            iconTheme: themeData.appBarTheme.iconTheme?.copyWith(color: buttonColor)),
                                        colorScheme: ColorScheme.light(
                                            onPrimary: Colors.white,
                                            primary: buttonColor
                                        )),
                                    child: child!,
                                  ),
                                  helpText: 'Select a date',
                                );*/

                                /*if (newDateRange != null) {
                                  // ignore: avoid_print
                                   print(_getValueText(
                                    config.calendarType,
                                    values,
                                  ));
                                  setState(() {
                                    _dialogCalendarPickerValue = newDateRange;
                                    _selectTime1();
                                  });
                                }*/
                                //openSpotAvailability();
                              },
                              child: Text("CheckAvailability".tr(),
                                  style: const TextStyle(
                                      decorationThickness: 1,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                      color: buttonColor,
                                      fontSize: ts20)),
                            ),
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
                              } /*else if (checkInController.text == checkOutController.text) {
                                showAlertDialog(context,
                                    "PleaseSelectDifferentCheckOutDate".tr());
                              }*/else if (different2Hours(checkInController.text, checkOutController.text, 2)) {
                                showAlertDialog(context,
                                    "PleaseSelectDifferentCheckOutDate2".tr());
                              } else {
                                getFindSpotsData();
                              }
                            },
                            title: Text("findSpots".tr(),
                                style: const TextStyle(fontSize: ts22))),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            headingMedium("spaces".tr()),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BikeDetailScreen(
                                                isRegistering: false,
                                              ))).then((value) {
                                    if (value == "update") {
                                      parkingSportDetailsApi();
                                      addedBikeListing();
                                    }
                                  });
                                },
                                child: Text(
                                  "addBike".tr(),
                                  style: const TextStyle(
                                      decorationThickness: 1,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                      color: buttonColor,
                                      fontSize: ts20),
                                )),
                          ],
                        ),
                        isLoading
                            ? Center(
                                child: Loader.load(),
                              )
                            : findSpotsList != null
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: findSpotsList?.length,
                                    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (findSpotsList![index].available ==
                                              "available") {
                                            setState(() {
                                              if (findSpotsList![index]
                                                  .isSelect!) {
                                                findSpotsList![index].isSelect =
                                                    false;
                                              } else {
                                                findSpotsList![index].isSelect =
                                                    true;
                                              }
                                              // selectedSpotsIds = "";
                                              bool isInfluencerSelected = false;
                                              for (var element
                                                  in findSpotsList!) {
                                                if (element.isSelect!) {
                                                  isInfluencerSelected = true;
                                                }
                                              }
                                              isMakePayment =
                                                  isInfluencerSelected
                                                      ? true
                                                      : false;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                          margin: const EdgeInsets.symmetric(vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 0),
                                                    spreadRadius: 2),
                                              ]),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.network(
                                                          "${findSpotsList![index].imageUrl}/${findSpotsList![index].bike_image}",
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                        return SvgPicture.asset(
                                                          icSmallBicycle,
                                                          width: 25,
                                                          height: 25,
                                                          fit: BoxFit.fitWidth,
                                                          color: lightGreyColor,
                                                        ); //do something
                                                      }, height: 32, width: 32),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        findSpotsList![index]
                                                                .bikeName
                                                                ?.toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: ts22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  if(findSpotsList![index].available == "available")
                                                  Container(
                                                      alignment: Alignment.centerRight,
                                                      child: SvgPicture.asset(
                                                        findSpotsList![index].isSelect! ? icCheck : uncheck,
                                                        height: 25,
                                                        color: buttonColor,
                                                        colorBlendMode:
                                                            findSpotsList![index].isSelect!
                                                                ? BlendMode.lighten
                                                                : BlendMode.srcATop,
                                                      )),
                                                ],
                                              ),
                                              /* Text(
                                                "Locker No. #${findSpotsList![index].array_counter?.toString() ?? ""}",
                                                style: const TextStyle(
                                                  fontSize: ts22,
                                                ),
                                              ),*/
                                              const SizedBox(height: 8),
                                              Row(
                                               // mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  findSpotsList![index].available != "available"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            putMeNotifyApi(findSpotsList?[index].id.toString());
                                                          },
                                                          child: Row(
                                                           // mainAxisSize: MainAxisSize.min,
                                                           // mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SvgPicture.asset(icBell, color: iconColor),
                                                              const SizedBox(width: 10),
                                                              Text(
                                                                  "PutMeOnWaitingList".tr(),
                                                                  style: const TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      color: lightGreyColor,
                                                                      fontSize: ts18,
                                                                      decoration: TextDecoration.underline,
                                                                      decorationColor: lightGreyColor,
                                                                      decorationThickness: 0.5)),
                                                            ],
                                                          ),
                                                        )
                                                      : const Expanded(child: SizedBox()),
                                                  const SizedBox(width: 4),
                                                  const Spacer(),
                                                  findSpotsList![index].available == "available"
                                                      ? tag2("available".tr())
                                                      : tag2("unavailable".tr()),
                                                ],
                                              ),
                                              findSpotsList![index].available !=
                                                      "available"
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        nextDateAvailability(request?.parkingSpotId.toString(), request?.checkInDate);
                                                        //openSpotAvailability2(findSpotsList![index]);
                                                      },
                                                      child: Text(
                                                          "CheckAvailability"
                                                              .tr(),
                                                          style: const TextStyle(
                                                              decorationThickness:
                                                                  1,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  lightGreyColor,
                                                              fontSize: ts20)),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : const SizedBox(),
                        const SizedBox(height: 20),
                        findSpotsList != null
                            ? PrimaryButton(
                                color: isMakePayment ? buttonColor : greyColor,
                                onPressed: () {
                                  if (isMakePayment) {
                                    selectedSpotsIds = "";
                                    arrayCounters = "";

                                    for (var a in findSpotsList!) {
                                      if (a.isSelect!) {
                                        if (selectedSpotsIds == "") {
                                          selectedSpotsIds = a.id.toString();
                                        } else {
                                          selectedSpotsIds +=
                                              "," + a.id.toString();
                                        }
                                        if (arrayCounters == "") {
                                          arrayCounters =
                                              a.array_counter.toString();
                                        } else {
                                          arrayCounters +=
                                              "," + a.array_counter.toString();
                                        }
                                      }
                                    }

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CartScreen(
                                                parking_spot_id: spotsDetail?.id
                                                        .toString() ??
                                                    "",
                                                bike_id: selectedSpotsIds,
                                                arrayCounters: arrayCounters,
                                                check_in_date: checkInController
                                                    .text
                                                    .toString(),
                                                check_out_date:
                                                    checkOutController.text
                                                        .toString())));
                                  }
                                },
                                title: Text("makePayment".tr(),
                                    style: const TextStyle(fontSize: ts22)))
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.only(top: height / 2 - 100),
                child: Center(
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
      checkInPopup(title);
      /*final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: Jiffy(DateTime.now()).add(years: 2).dateTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: buttonColor,
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
      }*/
    } else {
     // checkOutController.text = "";
      checkOutPopup(title);
      /*final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: buttonColor,
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
              lastDate: Jiffy(DateTime.now()).add(years: 2).dateTime)
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
      });*/
    }
  }

  checkInPopup(String title) {
    checkOutController.text = "";

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
                          minDate: DateTime.now(),
                          maxDate: Jiffy(DateTime.now()).add(years: 2).dateTime,
                          selectionMode: DateRangePickerSelectionMode.single,
                          initialDisplayDate: DateTime.now(),
                          initialSelectedDate: selectedStartDate /*?? DateTime.now()*/,
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
                              if (checkOutController.text.isNotEmpty) {
                                if (selectedStartDate!.difference(checkselectedEndDate!).inDays > 0) {
                                  showAlertDialog(context, 'StartDateShouldBeGraterThanEndDate'.tr());
                                } else {
                                  selectedStartDate = selectedStartDate!;
                                  setState(() {
                                    // String dateSlug = "${selectedStartDate.year.toString()}-${selectedStartDate.month.toString().padLeft(2, '0')}-${selectedStartDate.day.toString().padLeft(2, '0')}";
                                    final DateFormat formatter = DateFormat(dateFormatHyphen);
                                    final String formatted = formatter.format(selectedStartDate!);
                                    _selectTime(title, formatted);
                                  });
                                }
                              } else {
                                selectedStartDate = selectedStartDate!;
                                setState(() {
                                  // String dateSlug = "${selectedStartDate.year.toString()}-${selectedStartDate.month.toString().padLeft(2, '0')}-${selectedStartDate.day.toString().padLeft(2, '0')}";
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
   // DateTime? dateTime;
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
                          minDate: DateTime.now(),
                          maxDate: Jiffy(DateTime.now()).add(years: 2).dateTime,
                          selectionMode: DateRangePickerSelectionMode.single,
                          initialDisplayDate: DateTime.now(),
                          initialSelectedDate: checkselectedEndDate /*?? DateTime.now()*/,

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
                              //if (checkselectedEndDate != null) {
                                if (selectedStartDate!.difference(checkselectedEndDate!)
                                    .inDays > 0) {
                                  showAlertDialog(context,
                                      'EndDateShouldBeGraterThanStartDate'
                                          .tr());
                                } else {
                                  checkselectedEndDate = checkselectedEndDate!;
                                  setState(() {
                                    final DateFormat formatter = DateFormat(
                                        dateFormatHyphen);
                                    final String formatted = formatter.format(
                                        checkselectedEndDate!);
                                    _selectTime(title, formatted);
                                  });
                                }
                             // }
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
          // _dialogCalendarPickerValue[0] = selectedStartDate;

          // startTime  = date;
          // print("fdfdf ${date}");
          checkInController.text =
              date.toString() + " " + formattedTimeOfDay.toString();
        }
        if (title == "Out") {
          // _dialogCalendarPickerValue[1] = checkselectedEndDate;
          //print("fdfdf ${checkselectedEndDate}");
          // endTime  = date;
          checkOutController.text =
              date.toString() + " " + formattedTimeOfDay.toString();
        }

       /* _dialogCalendarPickerValue = DateTimeRange(
          start: selectedStartDate,
          end: checkselectedEndDate,
        );*/

        _dialogCalendarPickerValue = PickerDateRange(
            selectedStartDate,
            checkselectedEndDate
        );
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
            .format(_dialogCalendarPickerValue?.startDate ?? DateTime.now());

        //  String formattedDate = DateFormat(dateFormatHyphen).format(_dialogCalendarPickerValue[0] ?? DateTime.now());
        selectedStartDate = _dialogCalendarPickerValue?.startDate ?? DateTime.now();
        checkselectedEndDate =
            _dialogCalendarPickerValue?.endDate ?? DateTime.now();
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
        // String formattedDate = DateFormat(dateFormatHyphen).format(_dialogCalendarPickerValue[1] ?? DateTime.now());
        String formattedDate = DateFormat(dateFormatHyphen)
            .format(_dialogCalendarPickerValue?.endDate ?? DateTime.now());
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

  /* late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }*/

  /*final events = LinkedHashMap(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(eventloder);*/
  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  openSpotAvailability(FindSpots data) async {
    List<CalendarEventData<Event>> _events = [];
    DateTime startTime = Platform.isAndroid
        ? DateFormat('dd/MM/yyyy hh:mm a')
            .parse((request?.checkInDate?.toLowerCase() ?? ""))
        : DateFormat('dd/MM/yyyy hh:mm a').parse((request?.checkInDate ?? ""));
    DateTime endTime = Platform.isAndroid
        ? DateFormat('dd/MM/yyyy hh:mm a')
            .parse((request?.checkOutDate?.toLowerCase() ?? ""))
        : DateFormat('dd/MM/yyyy hh:mm a').parse((request?.checkOutDate ?? ""));
    data.unAvailabileDate?.forEach((element) {
      DateTime dateTime =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(element.checkInDate ?? "");
      var event = CalendarEventData<Event>(
        date: dateTime,
        title: "◉",
        color: Colors.red,
        startTime: startTime,
        endTime: endTime,
      );
      _events.add(event);
      // print("dsdsd ${element.checkInDate ?? ""}");
    });

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
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
                Expanded(
                  child: Scaffold(
                    body: MonthView(
                      width: MediaQuery.of(context).size.width,
                      controller: EventController<Event>()..addAll(_events),
                      cellBuilder: (date, events, isToday, isInMonth) {
                        return Container(
                          color: isInMonth
                              ? (startTime.compareWithoutTime(date) ||
                                      endTime.compareWithoutTime(date)
                                  ? buttonColorAlfa
                                  : Colors.white)
                              : Colors.grey.shade200,
                          child: Column(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? buttonColor
                                      : isInMonth
                                          ? Colors.white
                                          : Colors.grey.shade200,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                ),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    color: events.isNotEmpty
                                        ? Colors.redAccent
                                        : Colors.black,
                                    decoration: events.isNotEmpty
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      minMonth: DateTime.now(),
                      maxMonth: Jiffy().add(months: 5).dateTime,
                      initialMonth: DateTime.now(),
                      cellAspectRatio: 1,
                      startDay: WeekDays.monday,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 100,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: buttonColor),
                            child: const Center(
                                child: Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                            ))),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Container(
                          width: 100,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              color: buttonColor),
                          child: const Center(
                              child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ))),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  openSpotAvailability2(date) {
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
                        child: Text('nextAvailability'.tr(), textAlign : TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                          ),)),

                    const SizedBox(height: 50),
                    Text("$date", textAlign : TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black,
                      ),),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:  TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(buttonColor)
                        ),
                          onPressed:(){
                        Navigator.pop(context);
                      }, child: Padding(
                        padding:  const EdgeInsets.symmetric(horizontal: 24.0),
                        child:  Text("OK".tr(), style: const TextStyle(color: Colors.white),),
                      )),
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


  nextDateAvailability(parkingSpotId, checkInDate) async {
    Loaders().loader(context);
    apis.nextDateAvailability(parkingSpotId, checkInDate)
        .then((value) {
      Navigator.of(context).pop();
      DateTime dateInput = DateFormat("yyyy-MM-dd HH:mm:ss").parse(value?.data, true);
      var outputDate = DateFormat("dd/MM/yyyy hh:mm a").format(dateInput);
      openSpotAvailability2(outputDate.toUpperCase());
      setState(() {
        isLoading = false;
      });
    });
  }

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
                        ? SvgPicture.asset(
                            icCheck1,
                            height: 25,
                            color: buttonColor,
                            colorBlendMode: BlendMode.hardLight,
                          )
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
          //checkAvailability();
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

/*String _getValueText(
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
  }*/

/*_buildCalendarDialogButton() {
    var config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      shouldCloseDialogAfterCancelTapped: true,
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
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
                });
              }
            },
            child: const Text('Open Calendar Dialog'),
          ),
        ],
      ),
    );
  }*/

/*Widget _buildDefaultSingleDatePickerWithValue() {
    var config = CalendarDatePicker2Config(
      selectedDayHighlightColor: Colors.amber[900],
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsHeight: 50,
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Single Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          initialValue: _singleDatePickerValueWithDefaultValue,
          onValueChanged: (values) =>
              setState(() => _singleDatePickerValueWithDefaultValue = values),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _singleDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }*/

/* Widget _buildDefaultMultiDatePickerWithValue() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.multi,
      selectedDayHighlightColor: Colors.indigo,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Multi Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          initialValue: _multiDatePickerValueWithDefaultValue,
          onValueChanged: (values) =>
              setState(() => _multiDatePickerValueWithDefaultValue = values),
        ),
        const SizedBox(height: 10),
        Wrap(
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _multiDatePickerValueWithDefaultValue,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }*/

/*Widget _buildDefaultRangeDatePickerWithValue() {
    var config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.teal[800],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Range Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          initialValue: _rangeDatePickerValueWithDefaultValue,
          onValueChanged: (values) =>
              setState(() => _rangeDatePickerValueWithDefaultValue = values),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _rangeDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildCalendarWithActionButtons() {
    var config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Date Picker With Action Buttons'),
        CalendarDatePicker2WithActionButtons(
          config: config,
          initialValue: _rangeDatePickerWithActionButtonsWithValue,
          onValueChanged: (values) => setState(
              () => _rangeDatePickerWithActionButtonsWithValue = values),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _rangeDatePickerWithActionButtonsWithValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }*/
}
