import 'package:cycle_lock/responses/orders_list_response.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../network/api_provider.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrdersData? ordersData;

  OrderDetailsScreen({Key? key, this.ordersData}) : super(key: key);

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Apis apis = Apis();
  bool isLoading = true;
  var tanNumber = "";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pullRefresh() async {}

/*
  ordersListApi() async {
    setState(() {
      isLoading = true;
    });
    apis.orderListApi("all").then((value) {
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
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            customAppbar(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("#${widget.ordersData?.orderId ?? ""}",
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
                                      widget.ordersData?.orderStatus
                                                  .toString() ==
                                              "complete"
                                          ? "Completed".tr()
                                          : widget.ordersData?.orderStatus
                                                      .toString() ==
                                                  "cancel"
                                              ? "Cancelled".tr()
                                              : widget.ordersData
                                                          ?.is_assgin_lock ==
                                                      1
                                                  ? "ActiveBooking".tr()
                                                  : "UpcomingBooking".tr(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: ts12)))
                            ],
                          ),
                        ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      SvgPicture.asset(
                        calendar,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                          //"${DateFormat(dateFormatSlash).format(DateTime.parse(widget.ordersData?.checkInDate.toString()??""))} - ${DateFormat(dateFormatSlash).format(DateTime.parse(widget.ordersData?.checkOutDate.toString()??""))}",
                          "${widget.ordersData?.checkInDate.toString() ?? ""}\n${widget.ordersData?.checkOutDate.toString() ?? ""}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: ts20)),
                    ]),
                    const SizedBox(height: 20),
                    Text(widget.ordersData?.parkingSport?.name.toString() ?? "",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: ts17)),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Text("Bikes".tr(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: ts22)),
                            const SizedBox(width: 10),
                          ]),
                          Text(
                              "AED ${double.parse(widget.ordersData?.totalAmount ?? "").toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ts22)),
                        ]),
                  ],
                ),
              ),
            ),
            widget.ordersData?.bike! != null
                ? Column(
                    children: List.generate(
                        widget.ordersData?.bike?.length ?? 0,
                        (index) => bike(index, context)),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          height: 70,
          width: double.infinity,
          color: lightGreyColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
              );
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: [
             // SvgPicture.asset(backArrow, height: 30),
              const Icon(Icons.arrow_back_ios_rounded, size: 28,color: Colors.white),
              const SizedBox(width: 20),
              Text("MyBookings".tr(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: ts22)),
            ]),
          )),
    );
  }

  showAlertDialog(BuildContext context, message, title, id) {
    Dialogs().confirmationDialog(context, onContinue: () {
      Navigator.pop(context);

      if (title == "unlock") {
        ordersUnlockApi(
          widget.ordersData?.id.toString(),
          widget.ordersData?.checkOutDate.toString(),
          widget.ordersData?.bike?[id].bikeId.toString(),
          widget.ordersData?.bike?[id].id.toString(),
          widget.ordersData?.bike?[id].isLock.toString() == "lock"
              ? "unlock"
              : "lock",
        );
      }
    }, message: message.toString());
  }

  ordersUnlockApi(orderId, dateSlug, bike_id, order_details_id, is_lock) async {
    setState(() {
      isLoading = true;
    });
    apis
        .orderUnlockApi(orderId, bike_id, order_details_id, is_lock)
        .then((value) {
      setState(() {
        isLoading = false;
      });

      if (value?.status ?? false) {
        tanNumber=value?.tanNumber??"";

        codeDialog(context);
        //showMessageDialog(context,  "Code for Unlock: $tanNumber");

      } else {
        showMessageDialog(context, value?.message?.toString() ?? "");
      }


      // if (value?.status ?? false) {
      //   if (value?.isPayment == "payment") {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => CartScreen(
      //                   check_out_date: dateSlug,
      //                   type: "complete",
      //                   orderID: orderId,
      //                 )));
      //   } else {
      //     Navigator.pop(context, "update");
      //     showMessageDialog(context, value?.message?.toString() ?? "");
      //   }
      // } else {
      //   showMessageDialog(context, value?.message?.toString() ?? "");
      // }
    });
  }

  bike(index, context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      padding: const EdgeInsets.all(15),
      color: greyColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Image.network(
                "${widget.ordersData?.imageUrl}/${widget.ordersData?.bike![index].bikeInfo?.bikeImage}",
                errorBuilder: (context, error, stackTrace) {
                  return SvgPicture.asset(
                    icSmallBicycle,
                    width: 30,
                    height: 30,
                    fit: BoxFit.fitWidth,
                    color: lightGreyColor,
                  ); //do something
                },
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 10),
              Text(
                  widget.ordersData?.bike![index].bikeInfo?.bikeName
                          ?.toString() ??
                      "",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ts20)),
            ]),
            widget.ordersData?.bike!.length == 1 &&
                widget.ordersData?.is_assgin_lock == 1
                ?  SizedBox(
              width: 100,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ordersUnlockApi(
                    widget.ordersData?.id.toString(),
                    widget.ordersData?.checkOutDate.toString(),
                    widget.ordersData?.bike?[index].bikeId.toString(),
                    widget.ordersData?.bike?[index].id.toString(),
                    widget.ordersData?.bike?[index].isLock.toString() == "lock"
                        ? "unlock"
                        : "lock",
                  );



                  // showAlertDialog(
                  //     context,
                  //     widget.ordersData?.bike?[index].isLock.toString() ==
                  //             "unlock"
                  //         ? "lockAlert".tr()
                  //         : "unlockAlert".tr(),
                  //     "unlock",
                  //     index);
                },
                child: const Text(
                    "Unlock",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: ts20)),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  primary: lightGreyColor,
                ),
              ),
            ):SizedBox()
          ]),
          widget.ordersData?.bike?[index].is_assign == 1
              ? Column(
                  children: [
                    Text(
                      "Locker No. #${widget.ordersData?.bike?[index].lockerNo?.toString() ?? ""}",
                      style: const TextStyle(
                        fontSize: ts22,
                      ),
                    ),
                    Text(
                      "Tan No. #${widget.ordersData?.bike?[index].tanNo?.toString() ?? ""}",
                      style: const TextStyle(
                        fontSize: ts22,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
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

  showMessageDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
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

  alertBoxBody(setState) {
    return;
  }
}

class TabItemModel {
  int id;
  bool isStatus;
  String name;

  TabItemModel({required this.id, required this.isStatus, required this.name});
}
