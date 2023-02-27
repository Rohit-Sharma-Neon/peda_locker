import 'package:cycle_lock/responses/orders_list_response.dart';
import 'package:cycle_lock/ui/main/share_booking_screen.dart';
import 'package:cycle_lock/ui/main/share_screen.dart';
import 'package:cycle_lock/ui/widgets/not_found_text.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../network/api_provider.dart';
import '../../responses/swap_bike_list_response.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import '../onboarding/bike_detail_screen.dart';
import 'book_now_screen.dart';

class CancelOrdersScreen extends StatefulWidget {
  const CancelOrdersScreen({Key? key}) : super(key: key);

  @override
  _CancelOrdersScreenState createState() => _CancelOrdersScreenState();
}

class _CancelOrdersScreenState extends State<CancelOrdersScreen>
    with AutomaticKeepAliveClientMixin {
  var selectedBikeIndex = -1;
  var selectedUserIndex = -1;
  bool imageSelect = false;
  var selectSwapId = "";
  var selectUserBikeId = "";
  Apis apis = Apis();
  bool isLoading = true;
  List<OrdersData>? allOrdersList;
  DateTime? selectedDate;
  List<SwapBike>? swapBikes;
  List<UserBike>? userBikes;

  @override
  void initState() {
    ordersListApi();
    super.initState();
  }

  ordersListApi() async {
    setState(() {
      isLoading = true;
    });
    apis.orderListApi("cancel").then((value) {
      setState(() {
        isLoading = false;
      });
      if (value?.status ?? false) {
        setState(() {
          allOrdersList = value?.data;
        });
      } else {
        setState(() {
          allOrdersList = [];
        });
      }
    });
  }

  swapBikeListApi(orderId) async {
    apis.orderSwapListApi(orderId).then((value) {
      if (value?.status ?? false) {
        setState(() {
          swapBikes = value?.data?.swapBike;
          userBikes = value?.data?.userBike;
          swapDialogBox(orderId);
        });
      } else {}
    });
  }

  ordersCancelApi(orderId) async {
    setState(() {
      isLoading = true;
    });
    apis.orderCancelApi(orderId).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value?.status ?? false) {
        showMessageDialog(context,( value?.message?.toString() ?? "") /*+ "cancellationCharges".tr() + (value?.data?.cancellationCharges?.toString() ?? "")*/);
        ordersListApi();
      } else {}
    });
  }

  ordersRateApi(orderId, rating, review) async {
    setState(() {
      isLoading = true;
    });
    apis.orderRatingApi(orderId, rating, review).then((value) {
      setState(() {
        isLoading = false;
        if (value?.status ?? false) {
          showMessageDialog(context, value?.message?.toString() ?? "");
        } else {
          showMessageDialog(context, value?.message?.toString() ?? "");
        }
        isLoading = false;
      });
    });
  }

  ordersSwapApi(orderId, bikeId, swap_bike_id) async {
    setState(() {
      isLoading = true;
    });
    apis.orderSwapApi(orderId, bikeId, swap_bike_id).then((value) {
      setState(() {
        isLoading = false;
        if (value?.status ?? false) {
          showMessageDialog(context, value?.message?.toString() ?? "");
        } else {
          showMessageDialog(context, value?.message?.toString() ?? "");
        }
        isLoading = false;
      });
    });
  }

  ordersExtendApi(orderId, date) async {
    setState(() {
      isLoading = true;
    });
    apis.orderExtendApi(orderId, date).then((value) {
      setState(() {
        isLoading = false;
        if (value?.status ?? false) {
          ordersListApi();
          showMessageDialog(context, value?.message?.toString() ?? "");
        } else {}
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(bottom: 60),

          child: isLoading
              ?  Center(
                  child: Loader.load(),
                )
              : allOrdersList != null && allOrdersList!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: allOrdersList?.length??0,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      itemBuilder: (context, index) {
                        return orderSell(index);
                      })
                  : Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                         // Lottie.network(animCycleUrl),
                          notFound("cancelledOrderNotFound".tr())
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  orderSell(index) {
    return Card(
      color: greyBgColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Padding(
        padding: const EdgeInsets.all(13),
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
                        Text("#${allOrdersList?[index].orderId ?? ""}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: ts20)),
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
                                    allOrdersList?[index]
                                                .orderStatus
                                                .toString() ==
                                            "complete"
                                        ? "Completed".tr()
                                        : allOrdersList?[index]
                                                    .orderStatus
                                                    .toString() ==
                                                "cancel"
                                            ? "Cancelled".tr()
                                            : "ActiveBooking".tr(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: ts12)))
                          ],
                        ),
                      ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    SvgPicture.asset(
                      calendar,
                      height: 20,
                      width: 20,
                      color: buttonColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                        //"${DateFormat(dateFormatSlash).format(DateTime.parse(allOrdersList?[index].checkInDate.toString()??""))} - ${DateFormat(dateFormatSlash).format(DateTime.parse(allOrdersList?[index].checkOutDate.toString()??""))}",
                        "${allOrdersList?[index].checkInDate.toString() ?? ""}\n${allOrdersList?[index].extend_date_time ?? allOrdersList?[index].checkOutDate.toString() ?? ""}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: ts20)),
                  ]),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Image.network(
                            "${allOrdersList?[index].imageUrl}/${allOrdersList?[index].bike?[0].bikeInfo?.bikeImage}",
                            errorBuilder: (context, error, stackTrace) {
                              return SvgPicture.asset(
                                icSmallBicycle,
                                width: 25,
                                height: 25,
                                fit: BoxFit.fitWidth,
                                color: lightGreyColor,
                              ); //do something
                            },
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                              allOrdersList?[index]
                                      .bike?[0]
                                      .bikeInfo
                                      ?.bikeName
                                      ?.toString() ??
                                  "",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ts20)),
                          allOrdersList?[index].bike != null &&
                                  allOrdersList![index].bike!.length > 1
                              ? Container(
                                  padding: const EdgeInsets.all(7),
                                  margin: const EdgeInsets.only(left: 20),
                                  decoration: const BoxDecoration(
                                      color: buttonColor,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    "+" +
                                        (allOrdersList![index].bike!.length - 1)
                                            .toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: ts14),
                                  ),
                                )
                              : const SizedBox(),
                        ]),
                        Text(
                            "AED ${double.parse(allOrdersList?[index].totalAmount ?? "").toStringAsFixed(2)}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: ts22)),
                      ]),

                  const SizedBox(height: 8),
                  Text(
                      allOrdersList?[index].parkingSport?.name.toString() ?? "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: ts17)),
                  const SizedBox(height: 12),
                  allOrdersList?[index].orderStatus.toString() == "order"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showAlertDialog(context, "cancelAlert".tr(),
                                        "cancel", index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                   // height: 90,
                                    color: buttonColor,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        SvgPicture.asset(icRemove, height: 30),
                                        const SizedBox(height: 15),
                                        Text("Cancel".tr(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: ts16)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    checkOutPopup(context, index);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                   // height: 90,
                                    color: buttonColorAlfa70,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        SvgPicture.asset(icExtended,
                                            height: 30),
                                        const SizedBox(height: 15),
                                        Text("Extend".tr(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: ts16)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BookingShareScreen(
                                                  orderId: allOrdersList?[index]
                                                          .id
                                                          ?.toString() ??
                                                      "",
                                                )));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    //height: 90,
                                    color: buttonColor,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        SvgPicture.asset(icShare, height: 30),
                                        const SizedBox(height: 15),
                                        Text("Share".tr(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: ts16)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    swapBikeListApi(
                                        allOrdersList![index].id ?? "");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                   // height: 90,
                                    color: buttonColorAlfa70,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        SvgPicture.asset(icSwap, height: 30),
                                        const SizedBox(height: 15),
                                        Text("Swap".tr(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: ts16)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ])
                      : allOrdersList?[index].orderStatus.toString() == "complete"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showRateDialog(
                                            context,
                                            "cancelAlert".tr(),
                                            "cancel",
                                            index);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        height: 60,
                                        color: Colors.black,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("RateNow".tr(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: ts16)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showAlertDialog(
                                            context,
                                            "rebookAlert".tr(),
                                            "rebook",
                                            index);
                                      },
                                      child: Container(
                                        height: 60,
                                        padding: const EdgeInsets.all(5),
                                        color: buttonColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Rebook".tr(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: ts16)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ])
                          : GestureDetector(
                              onTap: () {
                                showAlertDialog(context, "rebookAlert".tr(),
                                    "rebook", index);
                              },
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.all(5),
                                color: buttonColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Rebook".tr(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: ts16)),
                                  ],
                                ),
                              ),
                            ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkOutPopup(BuildContext context, id) {
    DateTime tempDate = DateFormat(dateFormatHyphen)
        .parse(allOrdersList?[id].checkInDate.toString() ?? "");
    DateTime onlyDate = DateTime(tempDate.year, tempDate.month, tempDate.day);
    selectedDate = onlyDate;
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
                            this.selectedDate = selectedDate;
                            print("end Time $selectedDate");
                          }
                        },
                        minDate: onlyDate,
                        maxDate: DateTime(2025),
                        selectionMode: DateRangePickerSelectionMode.single,
                        initialDisplayDate: onlyDate,
                        initialSelectedDate: onlyDate,

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
                            if(selectedDate != null) {
                              Navigator.pop(context);
                              setState(() {
                               // selectedDate = dateTime!;
                                String dateSlug =
                                    "${selectedDate!.year.toString()}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
                                //ordersExtendApi(allOrdersList?[id].id.toString() ?? "", dateSlug);
                                final DateFormat formatter = DateFormat(dateFormatHyphen);
                                final String formatted = formatter.format(selectedDate!);
                               // _selectTime(id, formatted);
                                ordersExtendApi(allOrdersList?[id].id.toString() ?? "", dateSlug);
                              });
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

 /* Future<void> _selectDate(BuildContext context, id) async {
    DateTime tempDate = DateFormat(dateFormatHyphen)
        .parse(allOrdersList?[id].checkOutDate.toString() ?? "");
    DateTime onlyDate =
        DateTime(tempDate.year, tempDate.month, tempDate.day + 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: onlyDate,
      firstDate: onlyDate,
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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String dateSlug =
            "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
        ordersExtendApi(allOrdersList?[id].id.toString() ?? "", dateSlug);
      });
    }
  }*/

  showMessageDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }

  showAlertDialog(BuildContext context, message, title, id) {
    Dialogs().confirmationDialog(context, onContinue: () {
      Navigator.pop(context);
      if (title == "cancel") {
        ordersCancelApi(allOrdersList?[id].id.toString());
      }
      if (title == "rebook") {
        var bikeIds = "";
        for (var a in allOrdersList![id].bike!) {
          if (bikeIds == "") {
            bikeIds = a.bikeId.toString();
          } else {
            bikeIds += "," + a.bikeId.toString();
          }
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookNowScreen(
                    bikeIds: bikeIds,
                    soptId:
                    allOrdersList?[id].parkingSpotId?.toString() ?? "")));
      }
    }, message: message.toString());
  }

  showRateDialog(BuildContext context, message, title, id) {
    bool _validate = false;
    var rating = 2.5;
    TextEditingController reviewController = TextEditingController();
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //this right here
      child: Container(
        height: 500.0,
        width: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SmoothStarRating(
                allowHalfRating: false,
                onRated: (v) {
                  setState(() {
                    rating = v;
                  });
                },
                starCount: 5,
                rating: rating,
                size: 40.0,
                isReadOnly: false,
                color: Colors.green,
                borderColor: Colors.green,
                spacing: 0.0),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                maxLines: 9,
                maxLength: 400,
                controller: reviewController,
                decoration: new InputDecoration(
                  errorText: _validate ? "Please Enter Reviews!" : "",
                  hintText: 'EnterYourReviews'.tr(),
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: const OutlineInputBorder(),
                  labelStyle: new TextStyle(color: Colors.green),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 50.0)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () {
                  if (reviewController.text.isEmpty) {
                    _validate = true;
                  } else if (rating != 0.0) {
                    _validate = false;
                    Navigator.pop(context);
                    ordersRateApi(allOrdersList?[id].id.toString(),
                        rating.toString(), reviewController.text.toString());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  height: 60,
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("RateNow".tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: ts16)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  productPartCatalogue() {
    return Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: List.generate(1, (index) => buildListTile()),
            ),
          ],
        ));
  }

  buildListTile() {
    return;
  }

  void swapDialogBox(orderId) {
    selectedBikeIndex = -1;
    selectedUserIndex = -1;
    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(builder: (context, StateSetter setState) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 10),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: SizedBox(
              width: MediaQuery.of(context).size.width - 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  alertBoxTopBar(),
                  Container(
                    color: Colors.grey,
                    height: 1,
                    width: double.infinity,
                  ),
                  SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () {},
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.80,
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text("SelectOneSwap".tr(),
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: ts18))),
                                      buildSelectedBikeList(setState),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text("YourNewBike".tr(),
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: ts18))),
                                      const SizedBox(height: 10),
                                      userBikeList(setState),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          if (selectedBikeIndex == -1) {
                                            showMessageDialog(context,
                                                "PleaseSelectBikeSwap".tr());
                                          } else if (selectedUserIndex == -1) {
                                            showMessageDialog(context,
                                                "PleaseSelectYourNewBike".tr());
                                          } else {
                                            selectUserBikeId =
                                                userBikes?[selectedUserIndex]
                                                        .id
                                                        ?.toString() ??
                                                    "";
                                            selectSwapId =
                                                swapBikes?[selectedBikeIndex]
                                                        .bike
                                                        ?.id
                                                        ?.toString() ??
                                                    "";
                                            Navigator.of(context).pop();
                                            ordersSwapApi(
                                                swapBikes?[selectedBikeIndex]
                                                        .id
                                                        .toString()
                                                        .toString() ??
                                                    "",
                                                selectSwapId,
                                                selectUserBikeId);
                                          }
                                        },
                                        child: Container(
                                          color: buttonColor,
                                          margin: const EdgeInsets.only(
                                              left: 16, right: 16),
                                          width: double.infinity,
                                          height: 60,
                                          child: Center(
                                            child: Text(
                                              "Swap".tr(),
                                              style: const TextStyle(
                                                  fontSize: ts18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const BikeDetailScreen()));
                                        },
                                        child: Text("AddNewBike".tr(),
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: buttonColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: ts18)),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ))),
                        ],
                      ))
                ],
              )),
        );
      }),
    );
  }

  alertBoxBody(setState) {
    return;
  }

  alertBoxTopBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text("Swap".tr(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ts24)),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  icRemove,
                  height: 20,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  buildSelectedBikeList(setState) {
    return Expanded(
      child: swapBikes != null && swapBikes?.length != 0
          ? GridView.builder(
              padding: const EdgeInsets.all(6),
              physics: const BouncingScrollPhysics(),
              itemCount: swapBikes?.length??0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: MediaQuery.of(context).size.width * .300,
              ),
              itemBuilder: (_, index) => buildSwapBikes(index, setState),
            )
          : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Lottie.network(animCycleUrl),
            notFound("dataNotFound".tr())
          ],
        ),
            ),
    );
  }

  userBikeList(setState) {
    return Expanded(
      child: userBikes != null && userBikes?.length != 0
          ? GridView.builder(
              padding: const EdgeInsets.all(6),
              physics: const BouncingScrollPhysics(),
              itemCount: userBikes?.length??0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: MediaQuery.of(context).size.width * .300,
              ),
              itemBuilder: (_, index) => buildUsersBikeSell(index, setState),
            )
          : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           // Lottie.network(animCycleUrl),
            notFound("dataNotFound".tr())
          ],
        ),
            ),
    );
  }

  buildUsersBikeSell(index, setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUserIndex = index;
        });
      },
      child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedUserIndex == index ? Colors.black : Colors.black38,
              style: BorderStyle.solid,
              width: index == 1 ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                        selectedUserIndex == index ? icCheck : backArrow,
                        height: 25)),
                Image.network(
                  "${userBikes?[index].imageUrl}/${userBikes?[index].bike_image}",
                  errorBuilder: (context, error, stackTrace) {
                    return SvgPicture.asset(
                      icSmallBicycle,
                      width: 25,
                      height: 25,
                      fit: BoxFit.fitWidth,
                      color: lightGreyColor,
                    ); //do something
                  },
                  height: 20,
                  width: 20,
                ),
                const SizedBox(height: 15),
                Text(userBikes?[index].bikeName.toString() ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: ts18)),
              ],
            ),
          )),
    );
  }

  buildSwapBikes(index, setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBikeIndex = index;
        });
      },
      child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedBikeIndex == index ? Colors.black : Colors.black38,
              style: BorderStyle.solid,
              width: index == 1 ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                        selectedBikeIndex == index ? icCheck : backArrow,
                        height: 25)),
                Image.network(
                  "${swapBikes?[index].bike?.imageUrl}/${swapBikes?[index].bike?.image}",
                  height: 20,
                  width: 20,
                ),
                const SizedBox(height: 15),
                Text(swapBikes?[index].bike?.bikeName.toString() ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: ts18)),
              ],
            ),
          )),
    );
  }

  Future<void> _pullRefresh() async {
    ordersListApi();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class TabItemModel {
  int id;
  bool isStatus;
  String name;

  TabItemModel({required this.id, required this.isStatus, required this.name});
}
