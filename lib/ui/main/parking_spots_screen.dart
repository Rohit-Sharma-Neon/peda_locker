import 'dart:io';
import 'dart:typed_data';
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:cycle_lock/ui/widgets/not_found_text.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:flutter/cupertino.dart' as Cupertino;
import 'dart:ui' as ui;

import 'package:cycle_lock/ui/main/parking_spot_details_screen.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:cycle_lock/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart' as Lottie;

import '../../main.dart';
import '../../network/api_provider.dart';
import '../../responses/parking_list_response.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/sizes.dart';
import '../widgets/tag.dart';

class ParkingSpotsScreen extends StatefulWidget {
  final String? bikeName;

  const ParkingSpotsScreen({Key? key, this.bikeName = ""}) : super(key: key);

  @override
  _ParkingSpotsScreenState createState() => _ParkingSpotsScreenState();
}

class _ParkingSpotsScreenState extends State<ParkingSpotsScreen> {
  late GoogleMapController mapController;
  LatLng? _center;

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

  TextEditingController editingController = TextEditingController();
  late CustomInfoWindowController _customInfoWindowController;
  Set<Marker> markers = {};
  List<Data> searchData = [];
  List<Data>? data;
  Apis apis = Apis();
  bool isLoading = false;
  bool isMapShow = false;
  bool isSearch = false;
  late String _mapStyle;

  @override
  void initState() {
    getUserLocation();
    _customInfoWindowController = CustomInfoWindowController();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
   // parkingSportListApi();

    super.initState();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  final Location? _location = Location();
  LocationData? _locationData;
  LatLng? _locationPosition;

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

   // isLoading = true;
    _locationData = await _location!.getLocation();
    _locationPosition =
        LatLng(_locationData!.latitude!, _locationData!.longitude!);
   // _center = LatLng(_locationData!.latitude!, _locationData!.longitude!);
    setState(() {
      _center = LatLng(_locationData!.latitude!, _locationData!.longitude!);
      if (_center != null) {
        spPreferences.setString(
            SpUtil.USER_LAT, _center?.latitude.toString() ?? "0");
        spPreferences.setString(
            SpUtil.USER_LANG, _center?.longitude.toString() ?? "0");
        parkingSportListApi();
      }
    });
  }

  onSearchTextChanged(String text) async {
    searchData.clear();
    if (text.isEmpty) {
      isSearch = false;
      setState(() {});
      return;
    } else {
      isSearch = true;
    }

    for (var userDetail in data!) {
      if (userDetail.name!
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        searchData.add(userDetail);
      } else {
        // searchData = [];
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppBar(title: "parkingSpots".tr(), actions: [
        InkWell(
            onTap: () {
              setState(() {
                isMapShow = true;
              });
            },
            child: data != null
                ? SvgPicture.asset(icMap,
                    color: isMapShow ? Colors.white : primaryDark2, width: 24)
                : const SizedBox()),
        const SizedBox(
          width: 15,
        ),
        InkWell(
          onTap: () {
            setState(() {
              isMapShow = false;
            });
          },
          child: data != null
              ? SvgPicture.asset(
                  icMenu,
                  color: isMapShow ? primaryDark2 : Colors.white,
                  width: 28,
                )
              : const SizedBox(),
        ),
        const SizedBox(
          width: 20,
        )
      ]),
      body: !isMapShow
          ? Column(
              children: [
                Expanded(
                  child: isLoading
                      ? Center(
                          child: Loader.load(),
                        )
                      : data != null
                          ? Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 25),
                                  decoration: const BoxDecoration(
                                    color: primaryDark2,
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: primaryDark),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: editingController,
                                    onChanged: onSearchTextChanged,
                                    decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: SvgPicture.asset(icSearch,
                                              color: Colors.white),
                                        ),
                                        // prefixIconConstraints: const BoxConstraints(maxHeight: 40),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: "search".tr(),
                                        hintStyle: const TextStyle(
                                            fontSize: 24, color: Colors.white)),
                                    style: const TextStyle(
                                        fontSize: ts24, color: Colors.white),
                                  ),
                                ),
                                isSearch
                                    ? Expanded(
                                        child:
                                            searchData.length != 0 ||
                                                    searchData.isNotEmpty
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        searchData.length,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (searchData[index].totalSpace != null && searchData[index].totalSpace != 0) {
                                                        return InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ParkingSpotDetailsScreen(
                                                                              soptId: searchData[index].container_id.toString(),
                                                                              bikeName: widget.bikeName,
                                                                            )));
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        22),
                                                            // width: width/1.2,
                                                            margin:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        14,
                                                                    vertical:
                                                                        6),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color:
                                                                        tileColor,
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
                                                                          searchData[index]
                                                                              .name
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize: ts22,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        (searchData[index].totalSpace ?? 0) /*- (searchData[index].containerCount ?? 0)*/ !=
                                                                                0
                                                                            ? Text(
                                                                                ("${(searchData[index].totalSpace ?? 0) /*- (searchData[index].containerCount ?? 0)*/} " + "Spots1".tr()),
                                                                                style: const TextStyle(fontSize: ts18, fontWeight: FontWeight.w500), //("${parkingSport?[index].containerCount}/${parkingSport?[index].totalSpace} Spots")
                                                                              )
                                                                            : const SizedBox(),
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      searchData[index]
                                                                              .distance
                                                                              ?.toString() ??
                                                                          "",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              ts18,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
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
                                                                        SvgPicture.asset(
                                                                            icStar),
                                                                        const SizedBox(
                                                                            width:
                                                                                10),
                                                                        Text(
                                                                            "${searchData[index].avg_rate?.toString()} ( ${searchData[index].total_rate?.toString()} ${"Review".tr()})",
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.w600, fontSize: ts18)),
                                                                      ],
                                                                    ),
                                                                    searchData[index].mark_parking_spot_as_featured ==
                                                                            "1"
                                                                        ? tag("FEATURED"
                                                                            .tr())
                                                                        : const SizedBox(),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      } else {
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
                                      )
                                    : Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: data!.length,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 20),
                                            itemBuilder: (context, index) {
                                              if (data![index].totalSpace != null &&
                                                  data![index].totalSpace !=
                                                      0) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParkingSpotDetailsScreen(
                                                                  soptId: data![
                                                                          index]
                                                                      .container_id
                                                                      .toString(),
                                                                  bikeName: widget
                                                                      .bikeName,
                                                                )));
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 22),
                                                    // width: width/1.2,
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
                                                                  data?[index]
                                                                          .name
                                                                          .toString() ??
                                                                      "",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          ts22,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                (data?[index].totalSpace ??
                                                                                0) /*-
                                                                            (data?[index].containerCount ??
                                                                                0)*/ !=
                                                                        0
                                                                    ? Text(
                                                                        ("${(data?[index].totalSpace ?? 0) /*- (data?[index].containerCount ?? 0)*/} " +
                                                                            "Spots1".tr()),
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                ts18,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      )
                                                                    : const SizedBox(),
                                                              ],
                                                            ),
                                                            Text(
                                                              data?[index]
                                                                      .distance
                                                                      ?.toString() ??
                                                                  "",
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      ts18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
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
                                                                    "${data?[index].avg_rate?.toString()} ( ${data?[index].total_rate?.toString()} ${"Review".tr()})",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            ts18)),
                                                              ],
                                                            ),
                                                            data?[index].mark_parking_spot_as_featured ==
                                                                    "1"
                                                                ? tag("FEATURED"
                                                                    .tr())
                                                                : const SizedBox(),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            }),
                                      ),
                              ],
                            )
                          : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Lottie.Lottie.network(animCycleUrl),
                        notFound(_center == null ? "locationFetching".tr() : "dataNotFound".tr())
                      ],
                    ),
                            ),
                ),
              ],
            )
          : Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: height,
                        child: _center != null
                            ? GoogleMap(
                                zoomGesturesEnabled: true,
                                mapType: MapType.normal,
                                markers: markers,
                                onTap: (position) {
                                  _customInfoWindowController.hideInfoWindow!();
                                },
                                onCameraMove: (position) {
                                  // _customInfoWindowController.hideInfoWindow!();
                                },
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
                    isLoading
                        ? Center(
                            child: Loader.load(),
                          )
                        : Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemCount: data!.length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  itemBuilder: (context, index) {
                                    if (data![index].totalSpace != null &&
                                        data![index].totalSpace != 0) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ParkingSpotDetailsScreen(
                                                        soptId: data![index]
                                                            .container_id
                                                            .toString(),
                                                        bikeName:
                                                            widget.bikeName,
                                                      )));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          width: width / 1.2,
                                          height: height / 6.1,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 6),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 0),
                                                    spreadRadius: 4),
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        data?[index]
                                                                .name
                                                                .toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: ts22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      (data?[index].totalSpace ??
                                                                      0) /*-
                                                                  (data?[index]
                                                                          .containerCount ??
                                                                      0) */!=
                                                              0
                                                          ? Text(
                                                              ("${(data?[index].totalSpace ?? 0)/* - (data?[index].containerCount ?? 0)*/} ${"spaces".tr()}"),
                                                              style: const TextStyle(
                                                                  fontSize:
                                                                      ts18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                  Text(
                                                    data?[index]
                                                            .distance
                                                            ?.toString() ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: ts18,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(icStar),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                          "${data?[index].avg_rate?.toString()} ( ${data?[index].total_rate?.toString()} ${"Review".tr()})",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      ts18)),
                                                    ],
                                                  ),
                                                  data?[index].mark_parking_spot_as_featured ==
                                                          "1"
                                                      ? tag("FEATURED".tr())
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox();
                                    }
                                  }),
                            ),
                          ),
                  ],
                ),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: 75,
                  width: 150,
                  offset: 50,
                ),
              ],
            ),
    );
  }

  parkingSportListApi() async {
    BitmapDescriptor icon;
    if (Platform.isIOS) {
      icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 3.2), markerImage1);
    } else {
      icon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 3.2), markerImage);
    }
    setState(() {
      isLoading = true;
    });
    apis.parkingSportListApi().then((value) async {
      if (value?.status ?? false) {
        setState(() {
          isLoading = false;
          data = value?.data!;
        });
        for (var v in data!) {
          if (v.totalSpace != null && v.totalSpace != 0) {
            // var markerCount="0";
            // if ((v.totalSpace ?? 0) - (v.containerCount ?? 0) != 0) {
            //   markerCount = "${(v.totalSpace ?? 0) - (v.containerCount ?? 0)}";
            // }
            // if (Platform.isIOS) {
            //   Uint8List? markerIcon =
            //       await getBytesFromCanvas(int.parse(markerCount), 120, 120);
            //   icon = BitmapDescriptor.fromBytes(markerIcon!);
            // } else {
            //   Uint8List? markerIcon =
            //       await getBytesFromCanvas(int.parse(markerCount), 120, 120);
            //   icon = BitmapDescriptor.fromBytes(markerIcon!);
            // }
            //
            // Marker resultMarker = Marker(
            //   markerId: MarkerId(v.name!),
            //   icon: icon,
            //   onTap: () {
            //     _customInfoWindowController.addInfoWindow!(
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => ParkingSpotDetailsScreen(
            //                         soptId: v.container_id.toString(),
            //                       )));
            //         },
            //         child: Column(
            //           children: [
            //             Container(
            //               width: 500,
            //               margin: const EdgeInsets.symmetric(horizontal: 50),
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 12),
            //               decoration:
            //                   BoxDecoration(color: Colors.white, boxShadow: [
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
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
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
            //                                       (v.containerCount ?? 0) !=
            //                                   0
            //                               ? Text(
            //                                   ("${(v.totalSpace ?? 0) - (v.containerCount ?? 0)} "+"Spots1".tr()),
            //                                   style: const TextStyle(
            //                                       fontSize: ts18,
            //                                       fontWeight: FontWeight
            //                                           .w500), //("${parkingSport?[index].containerCount}/${parkingSport?[index].totalSpace} Spots")
            //                                 )
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
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Row(
            //                         mainAxisSize: MainAxisSize.min,
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         children: [
            //                           SvgPicture.asset(icStar),
            //                           const SizedBox(width: 10),
            //                           Text(
            //                               "${v.avg_rate?.toString()} ( ${v.total_rate?.toString()} ${"Review".tr()})",
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
            //   position: LatLng(double.parse(v.lat!), double.parse(v.log!)),
            // );
            // markers.add(resultMarker);
            final Uint8List markerIcon = await getBytesFromAsset(
                'assets/images/marker2.png', Platform.isAndroid ? 100 : 70);
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                        ("${(v.totalSpace ?? 0) - (v.containerCount ?? 0)} "+"Spots1".tr()),
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(icStar),
                                      const SizedBox(width: 10),
                                      Text(
                                          "${v.avg_rate?.toString()} ( ${v.total_rate?.toString()} ${"Review".tr()})",
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
            //_center = LatLng(double.parse(v.lat!), double.parse(v.log!));
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });
        //Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

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
}
