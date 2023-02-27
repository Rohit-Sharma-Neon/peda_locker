/*
* ©️  2021 Inventcolabs Pvt. Ltd. ,  All rights reserved.
*/
import 'package:cycle_lock/ui/main/acitve_order.dart';
import 'package:cycle_lock/ui/main/cancel_order.dart';
import 'package:cycle_lock/ui/main/complete_order.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import 'all_order.dart';

class MyBookingScreen extends StatefulWidget {
  bool isBarShow;
  int type;
  bool isUnlock;

  MyBookingScreen(
      {Key? key, this.type = 0, this.isUnlock = false, this.isBarShow = false})
      : super(key: key);
  static const routeName = "/my-booking-main";

  //int whereToComenew;
  //GiftorderScreen(this.whereToComenew);
  @override
  MyBookingScreenState createState() => MyBookingScreenState();
}

class MyBookingScreenState extends State<MyBookingScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: widget.type == 1
          ? 1
          : widget.type == 2
              ? 3
              : widget.type == 3
                  ? 2
                  : 0,
      length: 4,
      vsync: this,
    );
    Future.delayed(Duration.zero, () {});
  }

  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: <Widget>[
            widget.isBarShow ? customAppbar() : const SizedBox(),
            Container(
              height: 60,
              width: double.infinity,
              padding: EdgeInsets.zero,
              // constraints: BoxConstraints(maxHeight: 50.0),
              child: Material(
                color: greyBgColor,
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  labelColor: buttonColor,
                  unselectedLabelColor: primaryDark2,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: buttonColor,
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  // indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                  labelStyle: const TextStyle(
                      fontSize: ts18, fontWeight: FontWeight.w500),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                  tabs: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Tab(text: "All".tr(), iconMargin: EdgeInsets.zero),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Tab(
                        child: Text(
                          "ActiveBooking".tr(),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Tab(
                          text: "Completed".tr(), iconMargin: EdgeInsets.zero),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Tab(
                          text: "Cancelled".tr(), iconMargin: EdgeInsets.zero),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  AllOrdersScreen(
                    type: widget.type,
                    isUnlock: widget.isUnlock,
                  ),
                  ActiveOrdersScreen(
                    type: widget.type,
                    isUnlock: widget.isUnlock,
                  ),
                  const CompleteOrdersScreen(),
                  const CancelOrdersScreen(),
                ],
              ),
            ),
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

  Future<void> _pullRefresh() async {}

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
