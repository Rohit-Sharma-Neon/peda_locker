import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/providers/notification_provider.dart';
import 'package:cycle_lock/providers/user_data_provider.dart';
import 'package:cycle_lock/ui/main/coupon_screen.dart';
import 'package:cycle_lock/ui/main/home_screen.dart';
import 'package:cycle_lock/ui/main/my_account_screen.dart';
import 'package:cycle_lock/ui/main/mygear_screen.dart';
import 'package:cycle_lock/ui/main/notification_screen.dart';
import 'package:cycle_lock/ui/main/privacy_policy_screen.dart';
import 'package:cycle_lock/ui/main/terms_conditions_screen.dart';
import 'package:cycle_lock/ui/onboarding/service_Screen.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/custom_navigation_bar.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';


import '../../network/api_provider.dart';
import '../../responses/home_page_response.dart';
import '../../utils/images.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/sizes.dart';
import '../onboarding/bike_detail_screen.dart';
import '../onboarding/tutorial_screen.dart';
import 'add_accessories.dart';
import 'add_part.dart';
import 'edit_profile_Screen.dart';
import 'how_it_works_screen.dart';
import 'invite_friend_screen.dart';
import 'my_booking_main_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Location? _location = Location();
  LatLng? _locationPosition;
  Data userData = Data();
  LocationData? _locationData;
  Set<Marker> markers = {};
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late NotificationProvider notificationProvider;

  Future<Uint8List?> getBytesFromCanvas(
      int customNum, int width, int height) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = lightGreyColor;
    final Radius radius = Radius.circular(width / 2);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter =
        TextPainter(textDirection: Cupertino.TextDirection.ltr);
    painter.text = TextSpan(
      text: customNum.toString(), // your custom number here
      style: const TextStyle(fontSize: 65.0, color: Colors.white),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * .5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  // GetProfileResponse.Data userData = GetProfileResponse.Data();
  LatLng? _center;
  late GoogleMapController mapController;
  bool isActive = false;
  bool isGuest = false;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  buildDrawerItemTile(icon, text) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          height: 30,
          width: 30,
        ),
        const SizedBox(width: 20),
        Text(text,
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: ts18)),
      ],
    );
  }

  Apis apis = Apis();
  late UserDataProvider userDataProvider;
  bool isLoading = false;
  DateTime? currentBackPressTime;
  List<ParkingSportData>? parkingSport;
  List<HomeOrders>? orderList;
  bool isClose = false;

  Future<bool> onWillPop() {
    showAlertDialog(context);
    return Future.value(false);
  }

  @override
  void initState() {
    isGuest = spPreferences.getBool(SpUtil.IS_GUEST) ?? false;
    if (!isGuest) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        userDataProvider =
            Provider.of<UserDataProvider>(context, listen: false);
        userDataProvider.getProfileApi(true);
      });
    }
    getUserLocation();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    });

    super.initState();
  }

  createUniqueId() {
    var rng = Random();
    for (var i = 0; i < 10; i++) {
      print(rng.nextInt(100));
    }
    print("aaaaaaaaaaa" + rng.toString());

    return rng;
  }

  Future<void> createPlantFoodNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'jbhvnbv',
        body: 'Florist at 123 Main St. has 2 in stock.',
        bigPicture: 'assets/images/logo_white.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await _location!.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location!.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _location!.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location!.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        exit(0);
        return;
      } else {}
    }
    // for always getting user location
    // location!.onLocationChanged.listen((LocationData? currentLocation) {
    //   _locationPosition = LatLng(currentLocation!.latitude!, currentLocation.longitude!);
    //   print(_locationPosition);
    // });

    _locationData = await _location!.getLocation();
    _locationPosition =
        LatLng(_locationData!.latitude!, _locationData!.longitude!);
    setState(() {
      _center = LatLng(_locationData!.latitude!, _locationData!.longitude!);
      if (_center != null) {
        spPreferences.setString(
            SpUtil.USER_LAT, _center?.latitude.toString() ?? "0");
        spPreferences.setString(
            SpUtil.USER_LANG, _center?.longitude.toString() ?? "0");
      }
    });
  }

  @override
  void dispose() {
    setState(() {
      isClose = true;
    });
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset(
          home,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          order,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          settings,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Stack(
          overflow: Overflow.visible,
          children: [
            Image.asset(
              notificationBell,
              height: 30,
              width: 30,
              color: Colors.white,
            ),
            Consumer<NotificationProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return value.unReads > 0
                    ? Positioned(
                        top: -14,
                        right: -10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Text(
                            value.unReads > 9 ? "9+": value.unReads.toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            )
          ],
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset(
          more,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      MyBookingScreen(),
      const MyGearScreen(),
      const NotificationScreen(),
      const MyAccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          extendBody: true,
          /* drawer: buildDrawer(),*/
          // key: _scaffoldKey,
          appBar: buildAppBar(),
          /* body: PersistentTabView(
            context,
            controller: persistentTabController,
            screens: _buildScreens(),
            items: _navBarsItems(),
            onItemSelected: (int) async {
              var value = int;
              FocusScope.of(context).unfocus();
              setState(() {
                _selectedIndex = value;
              });
              if (value == 0) {
                !isGuest
                    ? Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ServiceScreen()),
                        (route) => false)
                    : _pageController.jumpToPage(value);
              }
              if (value == 1) {
                isGuest
                    ? Dialogs().errorDialog(context,
                        title: "guestError".tr(),
                        navLogin: true,
                        secondTitle: "viewOrderList".tr())
                    : _pageController.jumpToPage(value);
              }
              if (value == 2) {
                isGuest
                    ? Dialogs().errorDialog(context,
                        title: "guestError".tr(),
                        navLogin: true,
                        secondTitle: "viewBikeList".tr())
                    : _pageController.jumpToPage(value);
              }
              if (value == 3) {
                isGuest
                    ? Dialogs().errorDialog(context,
                        title: "guestError".tr(),
                        navLogin: true,
                        secondTitle: "viewNotificationList".tr())
                    : _pageController.jumpToPage(value);
              }
              if (value == 4) {
                isGuest
                    ? Dialogs().errorDialog(context,
                        title: "guestError".tr(),
                        navLogin: true,
                        secondTitle: "viewAccount".tr())
                    : _pageController.jumpToPage(value);
              }
            },

            confineInSafeArea: true,
            backgroundColor: buttonColor,
            // Default is Colors.white.
            handleAndroidBackButtonPress: true,
            // Default is true.
            resizeToAvoidBottomInset: true,
            // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true,
            navBarHeight: 60,
            // Default is true.
            hideNavigationBarWhenKeyboardShows: true,
            // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: NavBarDecoration(
              borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: buttonColor,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: ItemAnimationProperties(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle
                .style3, // Choose the nav bar style with this property.
          ),*/
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: <Widget>[
              const HomeScreen(),
              MyBookingScreen(),
              const MyGearScreen(),
              const NotificationScreen(),
              const MyAccountScreen(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigation(),
        ));
  }

  buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      actions: [
        /* isGuest
            ? GestureDetector(
                onTap: () {
                  Dialogs().errorDialog(context,
                      title: "guestError".tr(), navLogin: true);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          icNotification,
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  notificationProvider.notificationListingApi(context, true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          icNotification,
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                        ),
                      ),
                      Consumer<NotificationProvider>(
                        builder: (BuildContext context, value, Widget? child) {
                          return value.unReads == 0
                              ? const SizedBox()
                              : Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 10),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    value.unReads.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                        },
                      )
                    ],
                  ),
                ),
              ),*/
        _selectedIndex == 4
            ? !isGuest
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                    userType: "editProfile",
                                  )));

                      //_dialog("logoutAlert".tr());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 35,
                          color: buttonColor,
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
            : const SizedBox(),
        _selectedIndex == 2
            ? !isGuest
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15))),
                          builder: (context) {
                            return bottomSheet();
                          });

                      //_dialog("logoutAlert".tr());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Icon(
                          Icons.add_outlined,
                          size: 35,
                          color: buttonColor,
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
            : const SizedBox(),
        _selectedIndex == 3
            ? !isGuest
                ? PopupMenuButton(
                    color: Colors.black,
                    onSelected: (result) {
                      if (result == 0) {
                        showActionDialog(
                            context, "Delete", notificationProvider);
                      }
                      if (result == 1) {
                        showActionDialog(context, "Read", notificationProvider);
                      }
                      if (result == 2) {
                        showActionDialog(
                            context, "UnRead", notificationProvider);
                      }
                    },
                    offset: const Offset(0, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<int>(
                            value: 0,
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 15),
                              dense: true,
                              title: Text(
                                "clearAll".tr(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )),
                        PopupMenuItem<int>(
                            value: 1,
                            child: ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.only(left: 15),
                              title: Text("markAsAllRead".tr(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            )),
                        PopupMenuItem<int>(
                            value: 2,
                            child: ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.only(left: 15),
                              title: Text("markAsAllUnread".tr(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            )),
                      ];
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: SvgPicture.asset(icMore, color: buttonColor, colorBlendMode: BlendMode.srcIn),
                    ),
                  )
                : const SizedBox()
            : const SizedBox()
      ],
      backgroundColor: lightGreyColor,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () {},
        child: Image.asset(
          icSplashPedaLogo,
          height: 50,
         // color: Colors.white,
          alignment: Alignment.center,
        ),
      ),
      /*title: Text("bikeStorage".tr(),
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),*/
    );
  }

  showActionDialog(
      BuildContext context, String title, NotificationProvider value) {
    Dialogs().confirmationDialog(context, onContinue: () {
      Navigator.pop(context);
      if (title == "Read") {
        value.notificationReadApi("", true, context);
      } else if (title == "UnRead") {
        value.notificationUnReadApi(true, context);
      } else {
        value.notificationDeleteApi("", context, true);
      }
    },
        message: title == "Read"
            ? "NotificationsReadAlert".tr()
            : title == "UnRead"
                ? "Are you sure want to Unread all notifications?"
                : "NotificationsDeleteAlert".tr());
  }

  Widget bottomSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.directions_bike_rounded,
                size: 30, color: Colors.black),
            title: Text("bike".tr(),
                style: const TextStyle(
                    fontSize: ts22, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BikeDetailScreen(
                            isAdding: true,
                          ))).then((value) {
                _onTappedBar(2);
              });
            },
          ),
          ListTile(
            leading:  Image.asset(processing,height: 30,color: Colors.black,),
            title: Text('accessories'.tr(),
                style: const TextStyle(
                    fontSize: ts22, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddAccessories(
                            isAdding: true,
                          ))).then((value) {
                _onTappedBar(2);
              });
            },
          ),
          ListTile(
            leading: Image.asset(parts,height: 30,color: Colors.black,),
            title: Text('parts'.tr(),
                style: const TextStyle(
                    fontSize: ts22, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddPart(
                            isAdding: true,
                          ))).then((value) {
                _onTappedBar(2);
              });
            },
          ),
        ],
      ),
    );
  }

  _dialog(String Message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        //title: Text('Logout'),
        content: Text(
          "logoutAlert".tr(),
          style: const TextStyle(
            fontFamily: "Hind-SemiBold",
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.black, // background
                  onPrimary: Colors.white, // foreground
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                logoutApi();
              },
              child: Text(
                'Yes'.tr(),
                style: const TextStyle(fontSize: 18),
              )),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'.tr(),
                  style: const TextStyle(fontSize: 18, color: lightGreyColor)))
        ],
      ),
    );
  }

  logoutApi() async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    await apis.logoutApi().then((value) async {
      if (value?.status ?? false) {
        SpUtil().clearUserData();
        userData = Data();
        // final result = await FlutterRestart.restartApp();
        Fluttertoast.showToast(msg: value?.message ?? "");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TutorialScreen()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  buildDrawer() {
    return Drawer(
      child: Column(
        children: <Widget>[
          Consumer<UserDataProvider>(
            builder: (BuildContext context, userData, child) {
              return Container(
                color: lightGreyColor,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 50, bottom: 3),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          (userData.data?.imageUrl ?? "") +
                              "/" +
                              (userData.data?.image ?? ""),
                          height: 100,
                          width: 100,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return  Center(
                                child: Loader.load());
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              SvgPicture.asset(icDummyProfile),
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(userData.data?.name ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: ts24)),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ServiceScreen()),
                          (route) => false);
                    },
                    child: buildDrawerItemTile(icHome, "Home".tr())),
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      isGuest
                          ? Dialogs().errorDialog(context,
                              title: "guestError".tr(), navLogin: true)
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyAccountScreen()));
                    },
                    child: buildDrawerItemTile(icMyAccount, "MyAccount".tr())),
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      isGuest
                          ? Dialogs().errorDialog(context,
                              title: "guestError".tr(), navLogin: true)
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyBookingScreen()));
                    },
                    child: buildDrawerItemTile(icMyBooking, "MyBookings".tr())),
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      isGuest
                          ? Dialogs().errorDialog(context,
                              title: "guestError".tr(), navLogin: true)
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyGearScreen()));
                    },
                    child: buildDrawerItemTile(icGear, "MyGear".tr())),
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      isGuest
                          ? Dialogs().errorDialog(context,
                              title: "guestError".tr(), navLogin: true)
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CouponScreen()));
                    },
                    child: buildDrawerItemTile(coupon, "Coupon".tr())),
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HowItWorksScreen()));
                    },
                    child: buildDrawerItemTile(how, "HowItWorks".tr())),
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const InviteFriendScreen()));
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          invite,
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 20),
                        Text("InviteFriend".tr(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: ts18)),
                      ],
                    )),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 55,
            color: greyBgColor,
            alignment: Alignment.center,
            child: Text(
                "Version".tr() +
                    (spPreferences.getString(SpUtil.APP_VERSION) ?? ""),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: ts16)),
          ),
          Container(
            height: 55,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PrivacyPolicyScreen()));
                    },
                    child: Text("PrivacyPolicy".tr(),
                        style: const TextStyle(
                            color: lightGreyColor,
                            fontWeight: FontWeight.w500,
                            fontSize: ts16))),
                Container(
                  height: 20,
                  width: 2,
                  color: Colors.grey,
                  alignment: Alignment.center,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TermsConditionsScreen()));
                    },
                    child: Text("TermsConditions".tr(),
                        style: const TextStyle(
                            color: lightGreyColor,
                            fontWeight: FontWeight.w500,
                            fontSize: ts16))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  countDown(date) {
    var duration = const Duration(seconds: 1);
    late DateTime eventTime;
    late int days;
    late int hours;
    late int minutes;
    late int seconds;
    late int timeDiff;
    late Timer timer;
    eventTime = DateTime.parse(date);
    timeDiff = eventTime.difference(DateTime.now()).inSeconds;
    timer = Timer.periodic(duration, (Timer t) {
      //handleTick();
      setState(() {});
    });

    days = timeDiff ~/ (24 * 60 * 60) % 24;
    hours = timeDiff ~/ (60 * 60) % 24;
    minutes = (timeDiff ~/ 60) % 60;
    seconds = timeDiff % 60;
    if (!mounted) {
      timer.cancel();
    }
    return days.toString().padLeft(2, '0').toString() +
        "D " +
        hours.toString().padLeft(2, '0').toString() +
        "H " +
        minutes.toString().padLeft(2, '0').toString() +
        "M " +
        seconds.toString().padLeft(2, '0').toString() +
        "s ";
  }

  // handleTick(timeDiff) {
  //   if (timeDiff > 0) {
  //     if (isActive) {
  //       setState(() {
  //         if (eventTime != DateTime.now()) {
  //           timeDiff = timeDiff - 1;
  //           print('countDown');
  //         } else {
  //           print('Times up!');
  //           //Do something
  //         }
  //       });
  //bike_count: 0,
  //     }
  //   }
  // }

  showAlertDialog(BuildContext context) {
    Dialogs().confirmationDialog(context, message: "AreYouExit".tr(),
        onContinue: () {
      exit(0);
    });
  }

//{parking_sport_id: 8, lat: 25.2048, lang: 55.2708}//{lat: 23.4241, lang: 53.8478}

  _buildBottomBar() {
    return CurvedNavigationBar(
      // key: _scaffoldKey,
      height: 75.0,
      items: <Widget>[
        Image.asset(
          home,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        Image.asset(
          order,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        Image.asset(
          settings,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
        Stack(
          overflow: Overflow.visible,
          children: [
            Image.asset(
              notificationBell,
              height: 30,
              width: 30,
              color: Colors.white,
            ),
            Consumer<NotificationProvider>(
              builder: (BuildContext context, value, Widget? child) {
                return value.unReads > 0
                    ? Positioned(
                        top: -14,
                        right: -10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Text(
                            value.unReads.toString(),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            )
          ],
        ),
        Image.asset(
          more,
          height: 30,
          width: 30,
          color: Colors.white,
        ),
      ],
      color: buttonColor,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) => _onTappedBar(index),
      letIndexChange: (index) => true,
    );
  }

  _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: lightGreyColor,
      currentIndex: _selectedIndex,
      selectedItemColor: buttonColor,
      unselectedItemColor: Colors.white,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      //showUnselectedLabels: false,
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 10,
      ),
      selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w100,
         fontSize: 10
      ),
      onTap: (index) {
        _onTappedBar(index);
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: 'home'.tr(),
          backgroundColor: lightGreyColor,
          icon: Image.asset(
            home,
            height: 24,
            width: 24,
            color: _selectedIndex == 0 ? buttonColor : Colors.white,
          ),
        ),
        BottomNavigationBarItem(
            label: 'booking'.tr(),
            backgroundColor: lightGreyColor,
            icon: Image.asset(
              order,
              height: 24,
              width: 24,
              color: _selectedIndex == 1 ? buttonColor : Colors.white,
            )),
        BottomNavigationBarItem(
            label: 'settings'.tr(),
            backgroundColor: lightGreyColor,
            icon: Image.asset(
              settings,
              height: 24,
              width: 24,
              color: _selectedIndex == 2 ? buttonColor : Colors.white,
            )),
        BottomNavigationBarItem(
          label: 'notification'.tr(),
          backgroundColor: lightGreyColor,
          icon: Stack(
            overflow: Overflow.visible,
            children: [
              Image.asset(
                notificationBell,
                height: 24,
                width: 24,
                color: _selectedIndex == 3 ? buttonColor : Colors.white,
              ),
              Consumer<NotificationProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return value.unReads > 0 && _selectedIndex != 3
                      ? Positioned(
                          top: -14,
                          right: value.unReads > 9 ? -20 : -12,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: buttonColor,
                            ),
                            child: Text(
                                value.unReads > 9 ? "9+" : value.unReads.toString(),
                              style: const TextStyle(
                                  fontSize: 10.0, color: Colors.white),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              )
            ],
          ),
        ),
        BottomNavigationBarItem(
            label: 'profile'.tr(),
            backgroundColor: lightGreyColor,
            icon: Image.asset(
              more,
              height: 24,
              width: 24,
              color: _selectedIndex == 4 ? buttonColor : Colors.white,
            )),
      ],
    );
  }

  void _onTappedBar(int value) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = value;
    });
    if (value == 0) {
      !isGuest
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ServiceScreen()),
              (route) => false)
          : _pageController.jumpToPage(value);
    }
    if (value == 1) {
      isGuest
          ? Dialogs().errorDialog(context,
              title: "guestError".tr(),
              navLogin: true,
              secondTitle: "viewOrderList".tr())
          : _pageController.jumpToPage(value);
    }
    if (value == 2) {
      isGuest
          ? Dialogs().errorDialog(context,
              title: "guestError".tr(),
              navLogin: true,
              secondTitle: "viewBikeList".tr())
          : _pageController.jumpToPage(value);
    }
    if (value == 3) {
      isGuest
          ? Dialogs().errorDialog(context,
              title: "guestError".tr(),
              navLogin: true,
              secondTitle: "viewNotificationList".tr())
          : _pageController.jumpToPage(value);
    }
    if (value == 4) {
      isGuest
          ? Dialogs().errorDialog(context,
              title: "guestError".tr(),
              navLogin: true,
              secondTitle: "viewAccount".tr())
          : _pageController.jumpToPage(value);
    }
  }

  bookingSell(context, width) {}
// getProfileApi() async {
//   await spPreferences.remove(SpUtil.PROFILE_DATA);
//   isLoading = true;
//   await apis.getProfileApis().then((value) {
//     if (value?.status ?? false) {
//       setState(() {
//         isLoading = false;
//         userData = value!.data!;
//         spPreferences.setString(SpUtil.PROFILE_DATA, json.encode(value.data));
//       });
//       spPreferences.getString(SpUtil.PROFILE_DATA);
//     } else {
//       Fluttertoast.showToast(msg: value?.message ?? "");
//     }
//   });
// }
}
