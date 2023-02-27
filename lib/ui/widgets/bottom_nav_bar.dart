import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cycle_lock/responses/profile_response.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/main/home_screen.dart';
import 'package:cycle_lock/ui/main/my_account_screen.dart';
import 'package:cycle_lock/ui/main/my_booking_main_screen.dart';
import 'package:cycle_lock/ui/main/mygear_screen.dart';
import 'package:cycle_lock/ui/main/notification_screen.dart';
import 'package:cycle_lock/ui/onboarding/service_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController _pageController = new PageController();
  List<Widget> _screens = [
    const HomeScreen(),
     MyBookingScreen(),
    const MyGearScreen(),
    const NotificationScreen(),
    const MyAccountScreen() ,
  ];

  int _selectedIndex = 0;
  void _onPagedChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }
  @override
  Widget build(BuildContext context) {
    return
             CurvedNavigationBar(
              index: _selectedIndex,
              // onTap: _onItemTapped,

              key: _bottomNavigationKey,


              height: 75.0,

              items: const <Widget>[
                Icon(Icons.home_outlined, size: 40, color: Colors.white,),
                Icon(Icons.event_outlined, size: 40,color: Colors.white),
                Icon(Icons.settings_outlined, size: 40,color: Colors.white),
                Icon(Icons.notifications_outlined, size: 40,color: Colors.white),
                Icon(Icons.category_outlined, size: 40,color: Colors.white),
              ],color: Colors.greenAccent,
              buttonBackgroundColor: Colors.greenAccent,
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              onTap:
                  (index) {
                setState(() {
                });
              },
              letIndexChange: (index) => true,



    );
  }
}
