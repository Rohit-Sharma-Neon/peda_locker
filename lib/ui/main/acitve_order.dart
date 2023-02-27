import 'dart:async';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cycle_lock/responses/orders_list_response.dart';
import 'package:cycle_lock/ui/main/share_booking_screen.dart';
import 'package:cycle_lock/ui/main/share_screen.dart';
import 'package:cycle_lock/ui/widgets/not_found_text.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../network/api_provider.dart';
import '../../responses/swap_bike_list_response.dart';
import '../../utils/colors.dart';
import '../../utils/dialogs.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import '../onboarding/bike_detail_screen.dart';
import '../widgets/loaders.dart';
import 'book_now_screen.dart';
import 'cart_screen.dart';
import 'order_details.dart';

class ActiveOrdersScreen extends StatefulWidget {
  bool isUnlock;
  int type;

  ActiveOrdersScreen({Key? key, this.isUnlock = false, this.type = 0})
      : super(key: key);

  @override
  _ActiveOrdersScreenState createState() => _ActiveOrdersScreenState();
}

class _ActiveOrdersScreenState extends State<ActiveOrdersScreen>
    with AutomaticKeepAliveClientMixin {
  bool imageSelect = false;
  var selectSwapId = "";
  var selectUserBikeId = "";
  var tanNumber = "";
  bool isShow = false;
  Apis apis = Apis();
  bool isLoading = true;
  List<OrdersData>? allOrdersList;
  DateTime? selectedDate;
  List<SwapBike>? swapBikes;
  List<UserBike>? userBikes;
  var cancellationCharges = "0";

  @override
  void initState() {
    ordersListApi();
    super.initState();
  }

  ordersListApi() async {
    setState(() {
      isLoading = true;
    });
    apis.orderListApi("order").then((value) {
      setState(() {
        isLoading = false;
      });
      if (value?.status ?? false) {
        setState(() {
          allOrdersList = value?.data;
          cancellationCharges = value?.cancellationCharges ?? "";
        });
      } else {
        setState(() {
          allOrdersList = [];
        });
      }
    });
  }

  Future<void> _pullRefresh() async {
    ordersListApi();
  }

  ordersUnlockApi(orderId, dateSlug, bike_id, order_details_id, is_lock) async {
    Loaders().loader(context);

    // setState(() {
    //   isLoading = true;
    // });
    apis.orderUnlockApi(orderId, bike_id, order_details_id, is_lock)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);

      if (value?.status ?? false) {
        tanNumber=value?.tanNumber??"";
        // isShow = true;
        // Timer(const Duration(minutes: 10), () {
        //   isShow = false;
        // });
        // if (value?.isPayment == "payment") {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => CartScreen(
        //                 check_out_date: dateSlug,
        //                 type: "complete",
        //                 orderID: orderId,
        //               )));
        // } else {
        //   showMessageDialog(context, value?.message?.toString() ?? "");
        //   ordersListApi();
        // }
        codeDialog(context);
        //showMessageDialog(context,  "Code for Unlock: $tanNumber");


      } else {
       showMessageDialog(context, value?.message?.toString() ?? "");
      }
    });
  }

  swapBikeListApi(orderId, BuildContext context) async {
    Loaders().loader(context);
    apis.orderSwapListApi(orderId).then((value) {
      if (value?.status ?? false) {
        Navigator.pop(context);
        setState(() {
          swapBikes = value?.data?.swapBike;
          userBikes = value?.data?.userBike;
          swapDialogBox(orderId, context);
        });
      } else {
        Navigator.pop(context);
        Dialogs()
            .errorDialog(context, title: value?.message ?? "defaultError".tr());
      }
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

  orderCancelCharges(id, index) async {
    Loaders().loader(context);
    apis.orderCancelCharges(id).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {
        setState(() {
          cancellationCharges = value?.data?.cancellationCharges.toString() ?? "0";
        });
        showAlertDialog(
            context,
            "cancelAlert".tr() + "RefundAmount".tr() + " ${double.parse((value?.data?.refundAmount.toString() ?? "0"))}",
            "cancel",
            index);
      }
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
          ordersListApi();
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
                          notFound("activeOrderNotFound".tr())
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  orderSell(index) {
    return GestureDetector(
      onTap: () async {
        if (allOrdersList?[index].orderStatus == "order") {
          if (allOrdersList?[index].bike?.length != 1) {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrderDetailsScreen(
                          ordersData: allOrdersList?[index],
                        )));
            setState(() {
              if (result == "update") {
                ordersListApi();
              }
            });
          }
        }
      },
      child: Card(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                          fontSize: ts12))),
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
                          //"${DateFormat(dateFormatSlash).format(DateTime.parse(allOrdersList?[index].checkInDate.toString()??""))} - ""${DateFormat(dateFormatSlash).format(DateTime.parse(allOrdersList?[index].checkOutDate.toString()??""))}",
                          "${allOrdersList?[index].checkInDate.toString() ?? ""}\n"
                          "${allOrdersList?[index].extend_date_time ?? allOrdersList?[index].checkOutDate.toString() ?? ""}",
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
                                          (allOrdersList![index].bike!.length - 1).toString(),
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
                    allOrdersList?[index].bike != null && allOrdersList![index].bike!.length > 1
                        ? const SizedBox() : Column(
                      children: [
                        Text(
                          "Locker No. #${allOrdersList![index].bike?[0].lockerNo?.toString() ?? ""}",
                          style: const TextStyle(
                            fontSize: ts22,
                          ),
                        ),
                        // Text(
                        //   "Tan No. #${allOrdersList![index].bike?[0].tanNo?.toString() ?? ""}",
                        //   style: const TextStyle(
                        //     fontSize: ts22,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                        allOrdersList?[index].parkingSport?.name.toString() ??
                            "",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: ts17)),
                    const SizedBox(height: 12),
                    allOrdersList?[index].orderStatus.toString() == "order"
                        ? Column(
                            children: [
                              widget.isUnlock
                                  ? const SizedBox()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                         Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                /*var cancelCharges =
                                                    int.parse(
                                                        allOrdersList?[index]
                                                            .totalAmount ??
                                                            "0") /int.parse(
                                                        cancellationCharges) ;*/

                                                orderCancelCharges(allOrdersList?[index].id?.toString(), index);
                                              /*  showAlertDialog(
                                                    context,
                                                    "cancelAlert".tr() *//*+ " AED:  ${cancelCharges}"*//*,
                                                    "cancel",
                                                    index);*/
                                              },
                                              child: Container(

                                                //height: 90,
                                                color: buttonColorAlfa70,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    SvgPicture.asset(icRemove,
                                                        height: 30),
                                                    const SizedBox(height: 15),
                                                    Text("Cancel".tr(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
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

                                               // height: 90,
                                                color: buttonColor,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    SvgPicture.asset(icExtended,
                                                        height: 30),
                                                    const SizedBox(height: 15),
                                                    Text("Extend".tr(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                showAlertDialog(
                                                    context,
                                                    "AreYouAssignSomeoneElse"
                                                        .tr(),
                                                    "share",
                                                    index);
                                              },
                                              child: Container(

                                               // height: 90,
                                                color: buttonColorAlfa70,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    SvgPicture.asset(icShare,
                                                        height: 30),
                                                    const SizedBox(height: 15),
                                                    Text("Share".tr(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                                    allOrdersList![index].id ??
                                                        "",
                                                    context);
                                              },
                                              child: Container(

                                               // height: 90,
                                                color: buttonColor,
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    SvgPicture.asset(icSwap,
                                                        height: 30),
                                                    const SizedBox(height: 15),
                                                    Text("Swap".tr(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: ts16)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                              const SizedBox(height: 20),

                              allOrdersList?[index].bike!.length == 1
                                  ? GestureDetector(
                                      onTap: () {
                                        ordersUnlockApi(
                                          allOrdersList?[index].id.toString(),
                                          allOrdersList?[index].checkOutDate.toString(),
                                          allOrdersList?[index].bike?[0].bikeId.toString(),
                                          allOrdersList?[index].bike?[0].id.toString(),
                                          "unlock",
                                        );

                                        // if(allOrdersList?[index].bike![0].isLock.toString() == "unlock"){
                                        //   if(isShow){
                                        //     showMessageDialog(context,  "Tan Number: $tanNumber");
                                        //   }else{
                                        //     showAlertDialog(
                                        //         context,
                                        //         allOrdersList?[index]
                                        //             .bike![0]
                                        //             .isLock
                                        //             .toString() ==
                                        //             "unlock"
                                        //             ? "lockAlert".tr()
                                        //             : "unlockAlert".tr(),
                                        //         "unlock",
                                        //         index);
                                        //   }
                                        //
                                        // }
                                        // else{
                                        //   showAlertDialog(
                                        //       context,
                                        //       allOrdersList?[index]
                                        //           .bike![0]
                                        //           .isLock
                                        //           .toString() ==
                                        //           "unlock"
                                        //           ? "lockAlert".tr()
                                        //           : "unlockAlert".tr(),
                                        //       "unlock",
                                        //       index);
                                        //
                                        // }
                                      },
                                      child: Container(
                                        height: 60,
                                        padding: const EdgeInsets.all(5),
                                        color: lightGreyColor,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                                "Unlock",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: ts20)),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),

                              const SizedBox(height: 10),
                              if((allOrdersList?[index]
                                  .orderStatus
                                  .toString() ==
                                  "expiry" || allOrdersList?[index]
                                  .orderStatus
                                  .toString() ==
                                  "order") && (allOrdersList?[index].is_assgin_lock ?? 0) == 1)
                                GestureDetector(
                                  onTap: (){
                                    ordersCompleteApi(allOrdersList?[index].id);
                                   /* showApiAlertDialog(
                                        context,
                                        "completeAlert".tr(),
                                        allOrdersList?[index].id);*/
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      height: 60,
                                      padding: const EdgeInsets.all(5),
                                      color: lightGreyColor,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: const [
                                          Text("Complete",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: ts12)),
                                        ],
                                      )),
                                ),
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("CancellationApply".tr(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: ts16)),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                      onTap: (){
                                        // Fluttertoast.showToast(msg: "Under development");
                                        DateTime start =  Platform.isAndroid ?
                                        DateFormat("dd/MM/yyyy hh:mm a").parse(allOrdersList?[index].checkInDate.toString().toLowerCase() ?? "") :
                                        DateFormat("dd/MM/yyyy hh:mm a").parse(allOrdersList?[index].checkInDate.toString() ?? "");
                                        DateTime end =  Platform.isAndroid ?
                                        DateFormat("dd/MM/yyyy hh:mm a").parse(allOrdersList?[index].checkOutDate.toString().toLowerCase() ?? "") :
                                        DateFormat("dd/MM/yyyy hh:mm a").parse(allOrdersList?[index].checkOutDate.toString() ?? "");
                                        final Event event = Event(
                                          title: allOrdersList?[index]
                                              .bike?[0]
                                              .bikeInfo
                                              ?.bikeName
                                              ?.toString() ??
                                              'Event title',
                                          //description: 'Event description',
                                          //location: 'Event location',
                                          //allDay: false,
                                          startDate: start,
                                          endDate: end,
                                          /*iosParams: const IOSParams(
                                          reminder: Duration(minutes: 30), // on iOS, you can set alarm notification after your event.
                                        ),*/
                                          /* androidParams: const AndroidParams(
                                          emailInvites: ["test@example.com"], // on Android, you can add invite emails to your event.
                                        ),*/
                                          /*recurrence: Recurrence(
                                        frequency: Frequency.weekly,
                                        endDate: DateTime.now().add(Duration(days: 60)),
                                        ),*/
                                        );
                                        Add2Calendar.addEvent2Cal(event);
                                      },
                                      child: const Icon(Icons.event_note, size: 32,)
                                  )
                                ],
                              )
                            ],
                          )
                        : allOrdersList?[index].orderStatus.toString() == "complete"
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                          color: lightGreyColor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("Rebook".tr(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                  color: lightGreyColor,
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
      ),
    );
  }

  void _selectTime(id, date) async {
    DatePicker.showTime12hPicker(context,
        title:"Select Extend Time",
        showTitleActions: true,
        currentTime: DateTime.now(),
        onConfirm: (time) {
          setState(() {
            final localizations = MaterialLocalizations.of(context);
            final formattedTimeOfDay = localizations
                .formatTimeOfDay(TimeOfDay(hour: time.hour, minute: time.minute));


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartScreen(
                      check_out_date:
                      date.toString() + " " + formattedTimeOfDay.toString(),
                      orderID: allOrdersList?[id].id.toString(),
                    )));
          });
        });



/*
    TimeOfDay _time = TimeOfDay.now();
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        // if (title == "In") {
        //   checkInController.text =
        //       date + " " + _time.format(context).toString();
        // }
        // if (title == "Out") {
        //   checkOutController.text =
        //       date + " " + _time.format(context).toString();
        // }
        final localizations = MaterialLocalizations.of(context);
        final formattedTimeOfDay = localizations.formatTimeOfDay(_time);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartScreen(
                      check_out_date:
                          date.toString() + " " + formattedTimeOfDay.toString(),
                      orderID: allOrdersList?[id].id.toString(),
                    )));
      });
    }*/
  }

  checkOutPopup(BuildContext context, id) {
    DateTime tempDate = DateFormat(dateFormatHyphen).parse(allOrdersList?[id].checkInDate.toString() ?? "");
    DateTime onlyDate = DateTime(tempDate.year, tempDate.month, tempDate.day);
    selectedDate = onlyDate;
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
                                //String dateSlug = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                //ordersExtendApi(allOrdersList?[id].id.toString() ?? "", dateSlug);
                                final DateFormat formatter = DateFormat(dateFormatHyphen);
                                final String formatted = formatter.format(selectedDate!);
                                _selectTime(id, formatted);
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

  /*Future<void> _selectDate(BuildContext context, id) async {
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
        //ordersExtendApi(allOrdersList?[id].id.toString() ?? "", dateSlug);
        final DateFormat formatter = DateFormat(dateFormatHyphen);
        final String formatted = formatter.format(selectedDate);
        _selectTime(id, formatted);
      });
    }
  }*/

  showMessageDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);


  }

  showAlertDialog(BuildContext context, message, title, id) {
    Dialogs().confirmationDialog(context, message: message, onContinue: () {
      Navigator.pop(context);
      if (title == "cancel") {
        ordersCancelApi(allOrdersList?[id].id.toString());
      }
      if (title == "unlock") {
        ordersUnlockApi(
          allOrdersList?[id].id.toString(),
          allOrdersList?[id].checkOutDate.toString(),
          allOrdersList?[id].bike?[0].bikeId.toString(),
          allOrdersList?[id].bike?[0].id.toString(),
          allOrdersList?[id].bike?[0].isLock.toString() == "lock"
              ? "unlock"
              : "lock",
        );
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
      if (title == "share") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookingShareScreen(
                  orderId: allOrdersList?[id].id?.toString() ?? "",
                  checkIn: allOrdersList?[id].checkInDate?.toString() ?? "",
                  checkOut: (allOrdersList?[id].extend_date_time != null) ? allOrdersList![id].extend_date_time?.toString() ?? "" : allOrdersList?[id].checkOut.toString() ?? "",
                ))
        );
      }

    });
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
                decoration: InputDecoration(
                  errorText: _validate ? "Please Enter Reviews!" : "",
                  hintText: 'EnterYourReviews'.tr(),
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: const OutlineInputBorder(),
                  labelStyle: const TextStyle(color: Colors.green),
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

  void swapDialogBox(orderId, BuildContext ctx) {
    selectSwapId == "";
    selectUserBikeId == "";
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
                                          for (var a in userBikes!) {
                                            if (a.isSelect) {
                                              selectUserBikeId =
                                                  a.id?.toString() ?? "";
                                            }
                                          }
                                          for (var a in swapBikes!) {
                                            if (a.isSelect) {
                                              selectSwapId =
                                                  a.bike_id?.toString() ?? "";
                                            }
                                          }

                                          if (selectSwapId == "") {
                                            showMessageDialog(context,
                                                "PleaseSelectBikeSwap".tr());
                                          } else if (selectUserBikeId == "") {
                                            showMessageDialog(context,
                                                "PleaseSelectYourNewBike".tr());
                                          } else {
                                            Navigator.of(context).pop();
                                            ordersSwapApi(orderId.toString(),
                                                selectSwapId, selectUserBikeId);
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
                                          Navigator.pop(ctx);
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BikeDetailScreen()))
                                              .then((value) {
                                            if (value == 'update') {
                                              swapBikeListApi(orderId, context);
                                            }
                                          });
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
              itemCount: swapBikes?.length,
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
           // Lottie.network(animCycleUrl),
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
              itemCount: userBikes!.length,
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
          for (var a in userBikes!) {
            a.isSelect = false;
          }
          userBikes![index].isSelect = true;
        });
      },
      child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: userBikes![index].isSelect == index
                  ? lightGreyColor
                  : Colors.black38,
              style: BorderStyle.solid,
              width: userBikes![index].isSelect ? 2.5 : 1,
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
                  Container(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                          userBikes![index].isSelect ? icCheck1 : backArrow,
                          height: 25)),
                ],
              ))),
    );
  }

  buildSwapBikes(index, setState) {
    return GestureDetector(
      onTap: () {
        setState(() {
          for (var a in swapBikes!) {
            a.isSelect = false;
          }
          swapBikes![index].isSelect = true;
        });
      },
      child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: swapBikes![index].isSelect == index
                  ? lightGreyColor
                  : Colors.black38,
              style: BorderStyle.solid,
              width: swapBikes![index].isSelect ? 2.5 : 1,
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
                      Image.network(
                        "${swapBikes?[index].bike?.imageUrl}/${swapBikes?[index].bike?.bike_image}",
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
                      Text(swapBikes?[index].bike?.bikeName.toString() ?? "",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: ts18)),
                    ],
                  ),
                  Container(
                      alignment: Alignment.topRight,
                      child: swapBikes![index].isSelect
                          ? SvgPicture.asset(icCheck1, height: 25)
                          : const SizedBox()),
                ],
              ))),
    );
  }


  showApiAlertDialog(BuildContext context, message, id) {
    Dialogs().confirmationDialog(context, onContinue: () {
      Navigator.pop(context);
      ordersCompleteApi(id);
    }, message: message.toString());
  }

  ordersCompleteApi(orderId) async {
    Loaders().loader(context);
    apis.orderCompleteApi(orderId).then((value) {
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
      if (value?.status ?? false) {
        ordersListApi();
        /*if (value?.isPayment == "payment") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CartScreen(
                    type: "complete",
                    orderID: orderId,
                  )));
        } else {
          showMessageDialog(context, value?.message?.toString() ?? "");
        }*/
      } else {
        showMessageDialog(context, value?.message?.toString() ?? "");
      }
    });
  }
  codeDialog(BuildContext context,) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child:AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Pedalocker",
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text( "Code for Unlock: $tanNumber",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500))),

                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.asset(box),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 25),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryDark2,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("Ok".tr(),
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white)),
                        ),
                      ),


                    ],
                  ),
                ],
              )),
        ),
      ),
    );
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
