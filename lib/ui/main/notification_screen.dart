import 'package:cycle_lock/providers/notification_provider.dart';
import 'package:cycle_lock/ui/main/share_details_screen.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/ui/widgets/not_found_text.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../network/api_provider.dart';
import '../../responses/notification_list_response.dart';
import '../../utils/TimeAgo.dart';
import '../../utils/dialogs.dart';
import '../../utils/images.dart';
import '../../utils/loder.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import '../widgets/primary_button.dart';
import 'cart_screen.dart';
import 'my_booking_main_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin {
  Apis apis = Apis();
  bool isLoading = true;

  late NotificationProvider notificationProvider;
  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    notificationProvider.notificationListingApi(context, true, false);
    super.initState();
  }

  showActionDialog(BuildContext context, NotificationProvider value, index) {
    Dialogs().confirmationDialog(context, onContinue: () {
      Navigator.pop(context);

      if (value.data![index].isStatus == "unread") {
        notificationProvider.readDecrement();
      }
      value.notificationDeleteApi(value.data![index].id!.toString(), context, false);

      setState(() {
        value.data!.removeAt(index);
      });
    }, message: "alertNotificationDelete".tr());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (BuildContext context, value, Widget? child) {
        return RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Scaffold(
            body: Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: value.isLoadings
                  ?  Center(
                      child: Loader.load(),
                    )
                  : value.data != null && value.data!.isNotEmpty
                      ? ListView.builder(
                          itemCount: value.data?.length ?? 0,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          itemBuilder: (context, index) {
                            return Dismissible(
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  showActionDialog(context, value, index);
                                }
                              },
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.endToStart) {}
                              },
                              background: const SizedBox(),
                              direction: DismissDirection.horizontal,
                              secondaryBackground: Container(
                                color: primaryDark2,
                                padding: const EdgeInsets.only(right: 30),
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    //showActionDialog(context,value.data!,index);
                                  },
                                  child: SvgPicture.asset(
                                    icDelete,
                                    height: 60,
                                  ),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (value.data?[index].type == "1") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyBookingScreen(
                                                  isBarShow: true,
                                                  type: 1,
                                                )));
                                  }
                                  if (value.data?[index].type == "2") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyBookingScreen(
                                                  isBarShow: true,
                                                  type: 2,
                                                )));
                                  }
                                  if (value.data?[index].type == "6") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShareBikeDetailScreen(
                                                  shareId: value
                                                      .data?[index].orderId
                                                      .toString(),
                                                )));
                                  }
                                  if (value.data?[index].type == "3") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyBookingScreen(
                                                  isBarShow: true,
                                                  type: 3,
                                                )));
                                  }
                                  if (value.data![index].isStatus != "read") {
                                    setState(() {
                                      notificationProvider.unReads = 0;
                                      value.data![index].isStatus = "read";
                                      value.data!.forEach((element) {
                                        if (element.isStatus == "unread") {
                                          notificationProvider.readIncrement();
                                        }
                                      });
                                    });
                                    value.notificationReadApi(
                                        value.data![index].id.toString(),
                                        false,
                                        context);
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  color: value.data![index].isStatus == "unread"
                                      ? const Color(0x947B7979)
                                      : const Color(0x94EFEFEF),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        value.data![index].title.toString(),
                                        style: TextStyle(
                                            color:
                                                value.data![index].isStatus ==
                                                        "unread"
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: ts20),
                                      ),
                                      Text(
                                        value.data![index].message.toString(),
                                        style: TextStyle(
                                            color:
                                                value.data![index].isStatus ==
                                                        "unread"
                                                    ? Colors.white
                                                    : Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: ts18),
                                      ),
                                      value.data![index].btnType != null
                                          ? Column(
                                              children: [
                                                const SizedBox(height: 5),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    value.data![index]
                                                                .btnType ==
                                                            '1'
                                                        ? SizedBox(
                                                            width: 150,
                                                            height: 45,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                checkOutPopup(context, value.data![index]);
                                                              },
                                                              child: Text(
                                                                "Extend".tr(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        ts20),
                                                              ),
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                primary:
                                                                    buttonColor,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                    value.data![index]
                                                                    .btnType ==
                                                                "2" ||
                                                            value.data![index]
                                                                    .btnType ==
                                                                "3"
                                                        ? Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 150,
                                                                height: 45,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                        checkOutPopup(context, value.data![index]);
                                                                  },
                                                                  child: Text(
                                                                    "Extend"
                                                                        .tr(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            ts20),
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    elevation:
                                                                        0,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    primary:
                                                                        buttonColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 50,
                                                              ),
                                                              SizedBox(
                                                                width: 150,
                                                                height: 45,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (value
                                                                            .data![index]
                                                                            .btnType ==
                                                                        "3") {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => CartScreen(
                                                                                    type: "complete",
                                                                                    orderID: value.data![index].orderInfo?.id.toString() ?? "",
                                                                                  )));
                                                                    } else {
                                                                      showApiAlertDialog(
                                                                          context,
                                                                          "completeAlert"
                                                                              .tr(),
                                                                          value
                                                                              .data![index]
                                                                              .orderInfo!
                                                                              .id);
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    "Complete"
                                                                        .tr(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            ts20),
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    elevation:
                                                                        0,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    primary:
                                                                        buttonColor,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          TimeAgo.timeAgoSinceDate(value
                                              .data![index].createdAt
                                              .toString()),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color:
                                                  value.data![index].isStatus ==
                                                          "unread"
                                                      ? Colors.white
                                                      : Colors.black,
                                              fontSize: ts14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                      : RefreshIndicator(
                          onRefresh: _pullRefresh,
                          child: Center(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                               // Lottie.network(lottieUrl),
                                notFound("notificationNotFound".tr())
                              ],
                            ),
                          ),
                        ),
            ),
          ),
        );
      },
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
        if (value?.isPayment == "payment") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CartScreen(
                        type: "complete",
                        orderID: orderId,
                      )));
        } else {
          notificationProvider.notificationListingApi(context, true, false);
          showMessageDialog(context, value?.message?.toString() ?? "");
        }
      } else {
        showMessageDialog(context, value?.message?.toString() ?? "");
      }
    });
  }

  showMessageDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }



  checkOutPopup(BuildContext context, NotificationData data) {
    DateTime tempDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(data.orderInfo?.checkIn.toString() ?? "");
    DateTime onlyDate = DateTime(tempDate.year, tempDate.month, tempDate.day);
    selectedDate = onlyDate;
    //2022-08-26 00:00:00.000
    print("ggggggg"+onlyDate.toString());
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
                            print("end Time ${this.selectedDate.toString()}");
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
                                  //selectedDate = picked;
                                 // String dateSlug = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                  //ordersExtendApi(allOrdersList?[id].id.toString() ?? "", dateSlug);
                                  final DateFormat formatter = DateFormat(dateFormatHyphen);
                                  final String formatted = formatter.format(selectedDate!);
                                  _selectTime(data.orderInfo!.id!.toString(), formatted);
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

  Future<void> _selectDate(BuildContext context, NotificationData data) async {
    String s = data.orderInfo!.checkOutDate!.toString();
    int idx = s.indexOf(" ");
    List parts = [s.substring(0, idx).trim(), s.substring(idx + 1).trim()];

    DateTime tempDate = DateFormat(dateFormatHyphen).parse(parts[0].toString());
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
    if (picked != null) {
      setState(() {
        selectedDate = picked;
       // String dateSlug = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
        //ordersExtendApi(allOrdersList?[id].id.toString() ?? "", dateSlug);
        final DateFormat formatter = DateFormat(dateFormatHyphen);
        final String formatted = formatter.format(selectedDate!);
        _selectTime(data.orderInfo!.id!.toString(), formatted);
      });
    }
  }

  void _selectTime(id, date) async {
   // TimeOfDay _time = TimeOfDay.now();

      DatePicker.showTime12hPicker(context,
          title: "Select Extend Time",
          showTitleActions: true,
          currentTime: DateTime.now(), onConfirm: (time) {

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
                        orderID: id,
                      )));
            });


          });


   /* final TimeOfDay? newTime = await showTimePicker(
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
                      orderID: id,
                    )));
      });
    }*/
  }

  showAlertDialog(
      BuildContext context, String title, NotificationProvider value) {
    Widget cancelButton = TextButton(
      child: Text(
        "No".tr(),
        style: const TextStyle(color: lightGreyColor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Yes".tr(),
        style: const TextStyle(color: lightGreyColor),
      ),
      onPressed: () {
        Navigator.of(context).pop();

        if (title == "Read") {
          value.notificationReadApi("", true, context);
        } else if (title == "UnRead") {
          value.notificationUnReadApi(true, context);
        } else {
          value.notificationDeleteApi("", context, true);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert".tr()),
      content: title == "Read"
          ? Text("NotificationsReadAlert".tr())
          : title == "UnRead"
              ? Text("alertUnreadAll".tr())
              : Text("NotificationsDeleteAlert".tr()),
      actions: [
        cancelButton,
        continueButton,
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

  Future<void> _pullRefresh() async {
    notificationProvider.notificationListingApi(context, true, false);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

// notificationListingApi() async {
//   setState(() {
//     isLoading = true;
//   });
//   apis.notificationListingApi().then((value) {
//     if (value?.status ?? false) {
//       setState(() {
//         data = value!.data;
//         isLoading = false;
//       });
//       //Fluttertoast.showToast(msg: value?.message ?? "");
//     } else {
//       setState(() {
//         data != null ? data!.clear() : data;
//         isLoading = false;
//       });
//       //Fluttertoast.showToast(msg: value?.message ?? "");
//     }
//   });
// }

// notificationDeleteApi(String notificationId,NotificationProvider value) async {
//   setState(() {
//     isLoading = true;
//   });
//   value.notificationDeleteApi(notificationId).then((data) {
//     if (data?.status ?? false) {
//       setState(() {
//         value.notificationListingApi();
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: data?.message ?? "");
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: data?.message ?? "");
//     }
//   });
// }

// notificationReadApi(String notificationId, isCall) async {
//   if (isCall) {
//     setState(() {
//       isLoading = true;
//     });
//   }
//
//   apis.notificationReadApi(notificationId).then((value) {
//     if (value?.status ?? false) {
//       setState(() {
//         if (isCall) {
//           value.notificationListingApi();
//         }
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: value?.message ?? "");
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: value?.message ?? "");
//     }
//   });
// }
}
