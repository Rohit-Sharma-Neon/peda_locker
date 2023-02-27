import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:animations/animations.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/tt_api_provider.dart';
import 'package:cycle_lock/providers/notification_provider.dart';
import 'package:cycle_lock/providers/timer_provider.dart';
import 'package:cycle_lock/providers/user_data_provider.dart';
import 'package:cycle_lock/ui/main/coupon_screen.dart';
import 'package:cycle_lock/ui/main/my_account_screen.dart';
import 'package:cycle_lock/ui/main/mygear_screen.dart';
import 'package:cycle_lock/ui/main/notification_screen.dart';
import 'package:cycle_lock/ui/main/parking_spot_details_screen.dart';
import 'package:cycle_lock/ui/main/parking_spots_screen.dart';
import 'package:cycle_lock/ui/main/privacy_policy_screen.dart';
import 'package:cycle_lock/ui/main/terms_conditions_screen.dart';
import 'package:cycle_lock/ui/onboarding/service_Screen.dart';
import 'package:cycle_lock/ui/widgets/heading_medium.dart';
import 'package:cycle_lock/ui/widgets/not_found_text.dart';
import 'package:cycle_lock/ui/widgets/tag.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/custom_navigation_bar.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';


import '../../network/api_provider.dart';
import '../../responses/home_page_response.dart';
import '../../utils/images.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/sizes.dart';
import 'how_it_works_screen.dart';
import 'invite_friend_screen.dart';
import 'my_booking_main_screen.dart';
import 'package:custom_info_window/custom_info_window.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TimerProvider timerProvider;
  final Location? _location = Location();
  LatLng? _locationPosition;
  LocationData? _locationData;
  Set<Marker> markers = {};
  int? _selectedIndex;
  final PageController _pageController = PageController();

  late CustomInfoWindowController _customInfoWindowController;

  final LatLng _latLng = const LatLng(28.7041, 77.1025);
  final double _zoom = 15.0;

  Future<Uint8List?> getBytesFromCanvas(
      int customNum, int width, int height) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.black;
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
  late String _mapStyle;

  bool isActive = false;
  bool isGuest = false;
  late NotificationProvider notificationProvider;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _customInfoWindowController.googleMapController = controller;
    var newPosition = CameraPosition(
        target: LatLng(_locationData!.latitude!, _locationData!.longitude!),
        zoom: 11);
    CameraUpdate update = CameraUpdate.newCameraPosition(newPosition);
    mapController.moveCamera(update);
    mapController.setMapStyle(_mapStyle);
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
  //TTApis _ttApis = TTApis();
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
    _customInfoWindowController = CustomInfoWindowController();
    timerProvider = Provider.of<TimerProvider>(context, listen: false);
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
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
      notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
    });
    super.initState();
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
        homePageDataApi();
      }
    });
  }

  Future<void> _pullRefresh() async {
    homePageDataApi();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;



    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Scaffold(
        body: _center != null
            ? Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: _center != null
                              ? GoogleMap(
                                  myLocationButtonEnabled: false,
                                  zoomGesturesEnabled: true,
                                  markers: markers,
                                  
                                  onTap: (position) {
                                    _customInfoWindowController
                                        .hideInfoWindow!();
                                  },
                                  onCameraMove: (position) {
                                    // _customInfoWindowController
                                    //     .hideInfoWindow!();
                                  },
                                  mapType: MapType.normal,
                                  myLocationEnabled: true,
                                  onMapCreated: _onMapCreated,
                                  initialCameraPosition: CameraPosition(
                                    target: _center!,
                                    zoom: 11.0,
                                  ),
                                )
                              : Center(
                                  child: Loader.load(),
                                ),
                        ),
                      ),
                      Expanded(
                        flex:
                            orderList != null && orderList!.isNotEmpty ? 4 : 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    headingMedium("parkingSpots".tr()),
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ParkingSpotsScreen()));
                                        },
                                        child: Text(
                                          parkingSport != null
                                              ? "seeAll".tr()
                                              : "",
                                          style: const TextStyle(
                                              decorationThickness: 1,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.bold,
                                              fontSize: ts18,
                                              color: buttonColor),
                                        )),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 0),
                              SizedBox(
                                height: 120,
                                child: isLoading
                                    ?  Center(
                                        child: Loader.load(),
                                      )
                                    : parkingSport != null
                                        ? ListView.builder(
                                            itemCount: parkingSport?.length,
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              if(parkingSport![index].totalSpace!=null && parkingSport![index].totalSpace!=0  ){
                                                return OpenContainer(
                                                  closedColor: Colors.transparent,
                                                  openColor: Colors.transparent,
                                                  closedElevation: 0,
                                                  openElevation: 0,
                                                  transitionType:
                                                  ContainerTransitionType.fade,
                                                  // transitionDuration: const Duration(milliseconds: 500),
                                                  openBuilder: (context, action) {
                                                    return ParkingSpotDetailsScreen(
                                                        soptId:
                                                        parkingSport?[index]
                                                            .container_id
                                                            .toString() ??
                                                            "");
                                                  },
                                                  closedBuilder: (context, action) {
                                                    return Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 12),
                                                      width: width / 1.2,
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                    0.3),
                                                                blurRadius: 8,
                                                                offset:
                                                                const Offset(
                                                                    0, 0),
                                                                spreadRadius: 4),
                                                          ]),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    (parkingSport?[
                                                                    index]
                                                                        .name
                                                                        .toString() ??
                                                                        ""),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                        ts22,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold), //
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  (parkingSport?[index].totalSpace ?? 0) /*- (parkingSport?[index].containerCount ?? 0)*/ != 0
                                                                      ? Text(("${(parkingSport?[index].totalSpace ?? 0) 
                                                                  } "+"Spots1".tr()),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                        ts18,
                                                                        fontWeight:
                                                                        FontWeight.w500), //("${parkingSport?[index].containerCount}/${parkingSport?[index].totalSpace} Spots")
                                                                  )
                                                                      : const SizedBox(),
                                                                ],
                                                              ),
                                                              Text(
                                                                parkingSport?[
                                                                index]
                                                                    .distance
                                                                    ?.toString() ??
                                                                    "" "km",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                    ts18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  SvgPicture
                                                                      .asset(
                                                                      icStar),
                                                                  const SizedBox(
                                                                      width: 10),
                                                                  Text(
                                                                      "${parkingSport?[index].avgRate?.toString()} ( ${parkingSport?[index].totalRate?.toString()} ${"Review".tr()})",
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                          ts18)),
                                                                ],
                                                              ),
                                                              parkingSport?[index]
                                                                  .markParkingSpotAsFeatured ==
                                                                  "1"
                                                                  ? tag("FEATURED"
                                                                  .tr())
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );

                                              }else{
                                                return SizedBox();
                                              }
                                            })
                                        : Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                     // Lottie.Lottie.network(animCycleUrl),
                                      notFound("dataNotFound".tr())
                                    ],
                                  ),
                                          ),
                              ),
                              orderList != null && orderList!.isNotEmpty
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              headingMedium("parkedBikes".tr()),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyBookingScreen(
                                                                  isBarShow:
                                                                      true)));
                                                },
                                                child: Text(
                                                  orderList != null &&
                                                          orderList!.isNotEmpty
                                                      ? "myBookings".tr()
                                                      : "",
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: ts18,
                                                      color: buttonColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 142,
                                          child: isLoading
                                              ?  Center(
                                                  child:
                                                      Loader.load(),
                                                )
                                              : orderList != null &&
                                                      orderList!.isNotEmpty
                                                  ? ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          orderList?.length ??
                                                              0,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {

                                                        return Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        6),
                                                            width: width / 1.34,
                                                            margin: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14,
                                                                    vertical:
                                                                        6),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.3),
                                                                      blurRadius:
                                                                          8,
                                                                      offset:
                                                                          const Offset(
                                                                              0,
                                                                              0),
                                                                      spreadRadius:
                                                                          4),
                                                                ]),
                                                            child: Row(
                                                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Image
                                                                              .network(
                                                                            "${orderList![index].bikeData!.imageUrl.toString()}/${orderList![index].bikeData!.bike_image.toString()}",
                                                                            errorBuilder: (context,
                                                                                error,
                                                                                stackTrace) {
                                                                              return SvgPicture.asset(
                                                                                icSmallBicycle,
                                                                                width: 25,
                                                                                height: 25,
                                                                                fit: BoxFit.fitWidth,
                                                                                color: lightGreyColor,
                                                                              ); //do something
                                                                            },
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                25,
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          Text(
                                                                            orderList?[index].bikeData?.bikeName ??
                                                                                "",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(fontSize: ts22, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(

                                                                          orderList?[index].parkingSport?.name ??
                                                                              "",
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: ts18)),
                                                                      Text(
                                                                          orderList?[index].parkingSport?.distance.toString() ??
                                                                              "",
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: ts18)),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Container(
                                                                    height: double
                                                                        .infinity,
                                                                    width: 4,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                    margin: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            6)),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Text(
                                                                          orderList?[index].is_assgin_lock==1? "expiringIn".tr():"startIn".tr(),
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: ts14)
                                                                      ),
                                                                      Consumer<TimerProvider>(
                                                                        builder: (BuildContext context, value, Widget? child) {
                                                                          return Text(
                                                                            orderList?[index].is_assgin_lock == 1
                                                                                ? (orderList?[index].extend_date_time != null
                                                                                ? value.getRemainingTime(checkOutDate: orderList?[index].extend_date_time ?? "")
                                                                                : value.getRemainingTime(checkOutDate: orderList?[index].check_out ?? ""))
                                                                                :value.getRemainingTime(checkOutDate: orderList?[index].check_in ?? ""),
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: const TextStyle(fontSize: 0, fontWeight: FontWeight.w400),
                                                                          );
                                                                        },
                                                                      ),
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        color:
                                                                            lightGreyColor,
                                                                        child: Text(
                                                                            "${orderList?[index].container_id?.toString() ?? ""}",
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ));
                                                      })
                                                  : Center(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                               // Lottie.Lottie.network(animCycleUrl),
                                                notFound("dataNotFound".tr())
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 40),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                       Platform.isAndroid ? const SizedBox(height: 48) : const SizedBox(height: 85),
                    ],
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 75,
                    width: 150,
                    offset: 50,
                  ),
                ],
              )
            :  Center(
                child: Loader.load(),
              ),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      leading: InkWell(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(icMenu),
        ),
      ),
      actions: [
        isGuest
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
                  // notificationProvider.notificationListingApi(context, true);
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
                                  margin: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    value.unReads.toString(),
                                    style: const TextStyle(
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
              ),
      ],
      backgroundColor: lightGreyColor,
      title: Text("bikeStorage".tr(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20)),
    );
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

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    setState(() {
      isClose = true;
    });
    super.dispose();
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
      // handleTick(timer);
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
  //        bike_count: 0,
  //     }
  //   }
  // }

  showAlertDialog(BuildContext context) {
    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black, // background
          onPrimary: Colors.white, // foreground
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      child: const Text("Yes",
          style: TextStyle(color: Colors.white, fontSize: 18)),
      onPressed: () {
        exit(0);
        //Navigator.pop(context, true);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("No".tr(),
          style: const TextStyle(color: lightGreyColor, fontSize: 18)),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      titleTextStyle:
          const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
      title: Text("Alert".tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      content: Text("AreYouSure".tr(),
          style: const TextStyle(fontSize: 18)),
      actions: [
        continueButton,
        cancelButton,
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

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

//{parking_sport_id: 8, lat: 25.2048, lang: 55.2708}//{lat: 23.4241, lang: 53.8478}
  homePageDataApi() async {
    var width = MediaQuery.of(context).size.width;
    // setState(() {
    //   // final coordinates = Coordinates(_center.latitude, _center.longitude);
    //   // var addresses =  Geocoder.local.findAddressesFromCoordinates(coordinates);
    //   spPreferences.setString(SpUtil.USER_LAT, _center.latitude.toString());
    //   spPreferences.setString(SpUtil.USER_LANG, _center.longitude.toString());
    // });
    BitmapDescriptor? customIcon;

    setState(() {
      isLoading = true;
    });
    apis.homePageDataApi().then((value) async {
      if (value?.status ?? false) {
        notificationProvider.setUnReads(
            int.parse(value?.data?.notificationCount.toString() ?? "0"));
        setState(() {
          parkingSport = value?.data?.parkingSport;
          orderList = value?.data?.order;
        });
        //spPreferences.setString(SpUtil.NOTIFICATION_COUNT, value?.notificationCount.toString() ?? "0");
        // late BitmapDescriptor customIcon;
        // BitmapDescriptor.fromAssetImage(
        //         ImageConfiguration(size: Size(12, 12)), markerImage)
        //     .then((d) {
        //   customIcon = d;
        // });

        for (var v in parkingSport!) {
          if(v.totalSpace!=null && v.totalSpace!=0  ){
            // var markerCount = "0";
            // if ((v.totalSpace ?? 0) - (v.containerCount ?? 0) != 0) {
            //   markerCount = "${(v.totalSpace ?? 0) - (v.containerCount ?? 0)}";
            // }
            // if (Platform.isIOS) {
            //   Uint8List? markerIcon =
            //   await getBytesFromCanvas(int.parse(markerCount), 120, 120);
            //   icon = BitmapDescriptor.fromBytes(markerIcon!);
            // } else {
            //   Uint8List? markerIcon =
            //   await getBytesFromCanvas(int.parse(markerCount), 120, 120);
            //   icon = BitmapDescriptor.fromBytes(markerIcon!);
            // }

         /*   Marker(
              consumeTapEvents: true,
              markerId: MarkerId(v.id!.toString()),
              position: LatLng(double.parse(v.lat!), double.parse(v.log!)),
              onTap: () {
                _customInfoWindowController.addInfoWindow!(
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingSpotDetailsScreen(
                                soptId: v.container_id.toString(),
                              )));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 500,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                                spreadRadius: 4),
                          ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        (v.name.toString()),
                                        style: const TextStyle(
                                            fontSize: ts22,
                                            fontWeight: FontWeight.bold), //
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      (v.totalSpace ?? 0) -
                                          (v.containerCount ?? 0) !=
                                          0
                                          ? Text(
                                        ("${(v.totalSpace ?? 0) - (v.containerCount ?? 0)} ${"spaces".tr()}"),
                                        style: const TextStyle(
                                            fontSize: ts18,
                                            fontWeight: FontWeight
                                                .w500), //("${parkingSport?[index].containerCount}/${parkingSport?[index].totalSpace} Spots")
                                      )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Text(
                                    v.distance?.toString() ?? "" "km",
                                    style: const TextStyle(
                                        fontSize: ts18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(icStar),
                                      const SizedBox(width: 10),
                                      Text(
                                          "${v.avgRate?.toString()} ( ${v.totalRate?.toString()} ${"Review".tr()})",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: ts18)),
                                    ],
                                  ),
                                  v.markParkingSpotAsFeatured == "1"
                                      ? tag("FEATURED".tr())
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Triangle.isosceles(
                          edge: Edge.BOTTOM,
                          child: Container(
                            color: Colors.white,
                            width: 20.0,
                            height: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  LatLng(double.parse(v.lat!), double.parse(v.log!)),
                );
              },
              icon: await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(24, 24)), 'assets/images/marker2.png'),
              anchor: const Offset(0.5, 0.5),
              infoWindow: const InfoWindow(title: ""),
            );*/



            final Uint8List markerIcon = await getBytesFromAsset('assets/images/marker2.png', Platform.isAndroid ? 100 : 70);
            Marker resultMarker = Marker(
              markerId: MarkerId(v.id!.toString()),
              icon: BitmapDescriptor.fromBytes(markerIcon),
              anchor: const Offset(0.5, 0.5),
              onTap: () {
                _customInfoWindowController.addInfoWindow!(
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingSpotDetailsScreen(
                                soptId: v.container_id.toString(),
                              )));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 500,
                          margin: const EdgeInsets.symmetric(horizontal: 50),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                                spreadRadius: 4),
                          ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        (v.name.toString()),
                                        style: const TextStyle(
                                            fontSize: ts22,
                                            fontWeight: FontWeight.bold), //
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      (v.totalSpace ?? 0) -
                                          (v.containerCount ?? 0) !=
                                          0
                                          ? Text(
                                        ("${(v.totalSpace ?? 0) - (v.containerCount ?? 0)} ${"spaces".tr()}"),
                                        style: const TextStyle(
                                            fontSize: ts18,
                                            fontWeight: FontWeight
                                                .w500), //("${parkingSport?[index].containerCount}/${parkingSport?[index].totalSpace} Spots")
                                      )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  Text(
                                    v.distance?.toString() ?? "" "km",
                                    style: const TextStyle(
                                        fontSize: ts18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(icStar),
                                      const SizedBox(width: 10),
                                      Text(
                                          "${v.avgRate?.toString()} ( ${v.totalRate?.toString()} ${"Review".tr()})",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: ts18)),
                                    ],
                                  ),
                                  v.markParkingSpotAsFeatured == "1"
                                      ? tag("FEATURED".tr())
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                       /* Triangle.isosceles(
                          edge: Edge.BOTTOM,
                          child: Container(
                            color: Colors.white,
                            width: 20.0,
                            height: 10.0,
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  LatLng(double.parse(v.lat!), double.parse(v.log!)),
                );
              },
              // infoWindow: InfoWindow(title: v.name!, snippet: v.descriptions!),
              position: LatLng(double.parse(v.lat!), double.parse(v.log!)),
            );
            markers.add(resultMarker);
            /*BitmapDescriptor.fromBytes(ImageConfiguration.empty,
                'assets/images/marker2.png')
                .then((d) {
              Marker resultMarker = Marker(
                markerId: MarkerId(v.id!.toString()),
                icon: d,
                anchor: const Offset(0.5, 0.5),
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParkingSpotDetailsScreen(
                                  soptId: v.container_id.toString(),
                                )));
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 500,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 0),
                                  spreadRadius: 4),
                            ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          (v.name.toString()),
                                          style: const TextStyle(
                                              fontSize: ts22,
                                              fontWeight: FontWeight.bold), //
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        (v.totalSpace ?? 0) -
                                            (v.containerCount ?? 0) !=
                                            0
                                            ? Text(
                                          ("${(v.totalSpace ?? 0) - (v.containerCount ?? 0)} ${"spaces".tr()}"),
                                          style: const TextStyle(
                                              fontSize: ts18,
                                              fontWeight: FontWeight
                                                  .w500), //("${parkingSport?[index].containerCount}/${parkingSport?[index].totalSpace} Spots")
                                        )
                                            : const SizedBox(),
                                      ],
                                    ),
                                    Text(
                                      v.distance?.toString() ?? "" "km",
                                      style: const TextStyle(
                                          fontSize: ts18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(icStar),
                                        const SizedBox(width: 10),
                                        Text(
                                            "${v.avgRate?.toString()} ( ${v.totalRate?.toString()} ${"Review".tr()})",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: ts18)),
                                      ],
                                    ),
                                    v.markParkingSpotAsFeatured == "1"
                                        ? tag("FEATURED".tr())
                                        : const SizedBox(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Triangle.isosceles(
                            edge: Edge.BOTTOM,
                            child: Container(
                              color: Colors.white,
                              width: 20.0,
                              height: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LatLng(double.parse(v.lat!), double.parse(v.log!)),
                  );
                },
                // infoWindow: InfoWindow(title: v.name!, snippet: v.descriptions!),
                position: LatLng(double.parse(v.lat!), double.parse(v.log!)),
              );
              markers.add(resultMarker);
              print("Asfceasgfagfcafw");
            });*/

            //_center = LatLng(double.parse(v.lat!), double.parse(v.log!));
          }
          else{
            // var markerCount=0;
            //
            // if (Platform.isIOS) {
            //   Uint8List? markerIcon =
            //   await getBytesFromCanvas(markerCount, 120, 120);
            //   icon = BitmapDescriptor.fromBytes(markerIcon!);
            // } else {
            //   Uint8List? markerIcon =
            //   await getBytesFromCanvas(markerCount, 120, 120);
            //   icon = BitmapDescriptor.fromBytes(markerIcon!);
            // }
            //
            // Marker resultMarker = Marker(
            //   markerId: MarkerId(v.id!.toString()),
            //   icon: icon,
            //   onTap: () {
            //     _customInfoWindowController.addInfoWindow!(
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => ParkingSpotDetailsScreen(
            //                     soptId: v.container_id.toString(),
            //                   )));
            //         },
            //         child: Column(
            //           children: [
            //             Container(
            //               width: 500,
            //               margin: const EdgeInsets.symmetric(horizontal: 50),
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 12),
            //               decoration:
            //               BoxDecoration(color: Colors.white, boxShadow: [
            //                 BoxShadow(
            //                     color: Colors.grey.withOpacity(0.3),
            //                     blurRadius: 8,
            //                     offset: const Offset(0, 0),
            //                     spreadRadius: 4),
            //               ]),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Text(
            //                             (v.name.toString()),
            //                             style: const TextStyle(
            //                                 fontSize: ts22,
            //                                 fontWeight: FontWeight.bold), //
            //                           ),
            //                           const SizedBox(
            //                             width: 10,
            //                           ),
            //                           (v.totalSpace ?? 0) -
            //                               (v.containerCount ?? 0) !=
            //                               0
            //                               ? Text(
            //                             ("${(v.totalSpace ?? 0) - (v.containerCount ?? 0)} ${"spaces".tr()}"),
            //                             style: const TextStyle(
            //                                 fontSize: ts18,
            //                                 fontWeight: FontWeight
            //                                     .w500), //("${parkingSport?[index].containerCount}/${parkingSport?[index].totalSpace} Spots")
            //                           )
            //                               : const SizedBox(),
            //                         ],
            //                       ),
            //                       Text(
            //                         v.distance?.toString() ?? "" "km",
            //                         style: const TextStyle(
            //                             fontSize: ts18,
            //                             fontWeight: FontWeight.w700),
            //                       ),
            //                     ],
            //                   ),
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Row(
            //                         mainAxisSize: MainAxisSize.min,
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: [
            //                           SvgPicture.asset(icStar),
            //                           const SizedBox(width: 10),
            //                           Text(
            //                               "${v.avgRate?.toString()} ( ${v.totalRate?.toString()} ${"Review".tr()})",
            //                               style: const TextStyle(
            //                                   fontWeight: FontWeight.w600,
            //                                   fontSize: ts18)),
            //                         ],
            //                       ),
            //                       v.markParkingSpotAsFeatured == "1"
            //                           ? tag("FEATURED".tr())
            //                           : const SizedBox(),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             Triangle.isosceles(
            //               edge: Edge.BOTTOM,
            //               child: Container(
            //                 color: Colors.white,
            //                 width: 20.0,
            //                 height: 10.0,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       LatLng(double.parse(v.lat!), double.parse(v.log!)),
            //     );
            //   },
            //   // infoWindow: InfoWindow(title: v.name!, snippet: v.descriptions!),
            //   position: LatLng(double.parse(v.lat!), double.parse(v.log!)),
            // );
            // markers.add(resultMarker);
            //_center = LatLng(double.parse(v.lat!), double.parse(v.log!));
          }

        }

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        //Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  _buildBottomBar() {
    return CurvedNavigationBar(
      key: _scaffoldKey,
      height: 70.0,
      items: <Widget>[
        Image.asset(
          illBikes,
          height: 25,
          width: 25,
          color: lightGreyColor,
        ),
        Image.asset(
          illBikes,
          height: 25,
          width: 25,
          color: lightGreyColor,
        ),
        Image.asset(
          illBikes,
          height: 25,
          width: 25,
          color: lightGreyColor,
        ),
        Image.asset(
          illBikes,
          height: 25,
          width: 25,
          color: lightGreyColor,
        ),
        Image.asset(
          illBikes,
          height: 25,
          width: 25,
          color: lightGreyColor,
        ),
      ],
      color: lightGreyColor,
      buttonBackgroundColor: lightGreyColor,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: (index) => _onTappedBar(index),
      letIndexChange: (index) => true,
    );
  }

  void _onTappedBar(int value) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  bookingSell(context, width) {}

  @override
  bool get wantKeepAlive => true;
}
