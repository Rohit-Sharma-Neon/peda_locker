/*
* ©️  2021 Inventcolabs Pvt. Ltd. ,  All rights reserved.
*/
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cycle_lock/ui/main/share_screen.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import '../../main.dart';
import '../../network/api_provider.dart';
import '../../responses/share_data_response.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import 'dashboard_screen.dart';

class BookingShareScreen extends StatefulWidget {
  final String orderId;
  final String? checkIn;
  final String? checkOut;

  const BookingShareScreen({Key? key, required this.orderId, this.checkIn, this.checkOut}) : super(key: key);

  @override
  BookingShareScreenState createState() => BookingShareScreenState();
}

class BookingShareScreenState extends State<BookingShareScreen> {
  Apis apis = Apis();
  bool isLoading = false;
  List<ShareBike>? shareDataList;
  List<String> tabItem = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getShareData(widget.orderId);
    });
  }

  getShareData(order_id) async {
    setState(() {
      isLoading = true;
    });
    apis.getShareDataApi(order_id).then((value) {
      if (value?.status ?? false) {
        setState(() {
          shareDataList = value?.data?.shareBike;
          for (var a in shareDataList!) {
            tabItem.add(a.bike?.bikeName?.toString() ?? "");
          }

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabItem.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: lightGreyColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
              );
            },
            child: Container(
                padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
                child: /*SvgPicture.asset(backArrow, height: 10)*/  const Icon(Icons.arrow_back_ios_rounded, size: 24,color: Colors.white)
            ), // handle your image tap here
          ),
          // handle your image tap here
          title:  Text("ShareBike".tr(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: ts22)),
          actions: [GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashBoardScreen()),
                        (route) => false);
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.home_outlined, size: 40, color: buttonColor,),
              ))],
        ),
        body: isLoading
            ?  Center(
                child: Loader.load(),
              )
            : Column(
                children: [
                  Container(
                    color: greyColor,
                    height: kToolbarHeight,
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: greyColor,
                      bottom: TabBar(
                        isScrollable: false,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: buttonColor,
                        indicatorWeight: 2,
                        labelColor: lightGreyColor,
                        labelStyle: const TextStyle(
                            fontSize: ts18, fontWeight: FontWeight.w500),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                        unselectedLabelColor: primaryDark2,
                        tabs: [
                          ...tabItem.map((e) {
                            return Tab(text: e.toString());
                          }),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ...shareDataList!.map((e) {
                          return ShareScreen(shareData: e, checkIn: widget.checkIn, checkOut: widget.checkOut,);
                        }),

                        //IranianShareScreen(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
