import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';

import '../../../providers/address_provider.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/colors.dart';


const kGoogleApiKey = "AIzaSyCrfZW4Yn9i6Fk9zq_YEsCwW-sbdXyVCzs";

class AutoCompleteScreen extends StatefulWidget {
  static const routeName = "/auto_complete_screen";

  const AutoCompleteScreen({Key? key}) : super(key: key);

  @override
  State<AutoCompleteScreen> createState() => _AutoCompleteScreen();
}

class _AutoCompleteScreen extends State<AutoCompleteScreen> {
  TextEditingController controller = TextEditingController();
  String _currentAddress = "";
  final Completer<GoogleMapController> _controller = Completer();
  LatLng current = const LatLng(0.0, 0.0);
  CameraPosition? _cameraPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: lightGreyColor,
        elevation: 0,
        title: const Text("Search Address").tr(),
      ),
      body: Stack(
        children: [
          _buildGoogleMap(),
          placesAutoCompleteTextField(),
          Positioned(
            bottom: 110,
            right: 12,
            child: _gpsButton(),
          ),
          Positioned(
            bottom: 20,
            right: 80,
            left: 80,
            child: _doneButton(),
          )
        ],
      ),
    );
  }

  _gpsButton() {
    return InkWell(
      onTap: () async {
        Position position = await _getGeoLocationPosition();
        moveCamera(LatLng(position.latitude, position.longitude), "");
       // getAddressFromLatLong(position);
      },
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(2)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              offset: Offset(2, 2), // Shadow position
            ),
          ],
        ),
        child: const Icon(
          Icons.gps_fixed,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  _doneButton() {
    return InkWell(
      onTap: () async {
        if(_currentAddress == ""){
          String? address = await getAddress(_cameraPosition?.target ?? current);
          context
              .read<AddressProvider>()
              .setData(_cameraPosition?.target ?? current, address);
        }else {
          context
              .read<AddressProvider>()
              .setData(_cameraPosition?.target ?? current, _currentAddress);
        }
        Navigator.of(context).pop();
      },
      child: Container(
        height: 44,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(7),
        decoration: const BoxDecoration(
          color: blackColor,
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              offset: Offset(2, 2), // Shadow position
            ),
          ],
        ),
        child: Center(
            child: Text(
          "Confirm Address".tr(),
          style: AppTextStyles.regularStyle(18, Colors.white),
        )),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(4, 4), // Shadow position
          ),
        ],
      ),
      child: GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: kGoogleApiKey,
          // textStyle: const TextStyle(height: 1.0),
          inputDecoration: const InputDecoration(
            hintText: "Search your location",
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          debounceTime: 600,
          // countries: const ["in", "fr"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            LatLng center = LatLng(
                double.parse(prediction.lat!), double.parse(prediction.lng!));
            moveCamera(center, prediction.description);
          },
          itmClick: (Prediction prediction) {
            controller.text = prediction.description!;
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description!.length));
          }),
    );
  }

  _buildGoogleMap() {
    return Container(
      color: whiteColor,
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          GoogleMap(
            compassEnabled: false,
            onMapCreated: (controller) async {
              _controller.complete(controller);
              Position position = await _getGeoLocationPosition();
              moveCamera(LatLng(position.latitude, position.longitude), "");
             // getAddressFromLatLong(position);
            },
            initialCameraPosition: CameraPosition(
              target: current,
              zoom: 15,
            ),
            onCameraMove:(CameraPosition position) {
              _cameraPosition = position;
            },
            onCameraIdle:(){
              if(_cameraPosition != null) {
                getAddressFromLatLong(_cameraPosition?.target ?? current);
              }
            } ,
          ),
          // Center(
          //     child: Image.asset(
          //   AssetImage.pinBlack,
          //   width: 40,
          //   height: 40,
          //   color: AppColors.carModelColor1,
          // )),
        ],
      ),
    );
  }

  Future<void> moveCamera(LatLng latLng, String? address) async {
    _currentAddress = address ?? "";
    current = latLng;
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15)));
  }

  Future<void> getAddressFromLatLong(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];

    setState(() { controller.text = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';});
  }

  Future<String?> getAddress(LatLng position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    return '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }



}
