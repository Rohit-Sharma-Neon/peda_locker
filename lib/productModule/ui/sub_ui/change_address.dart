import 'dart:async';
import 'package:cycle_lock/responses/loction_list_modal.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:easy_localization/easy_localization.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../network/api_provider.dart';
import '../../../providers/address_provider.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/colors.dart';
import '../../../utils/contextnavigation.dart';
import '../../../utils/custom_textfield.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/submit_button.dart';
import 'autocomplite_screen.dart';


const kGoogleApiKey = "AIzaSyArqlT_3Q9fHcisw6lvvUGTcObXGz3GEJkY";

class ChangeAddressScreen extends StatefulWidget {
  static const routeName = "/change-address";
  String? addressId = "";
  int? length = 0;

  ChangeAddressScreen({Key? key, this.addressId, this.length})
      : super(key: key);

  @override
  _ChangeAddressScreenState createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  TextEditingController apartmentController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController other = TextEditingController();
  TextEditingController address = TextEditingController();
  FocusNode apartmentFocusNode = FocusNode();
  FocusNode buildingFocusNode = FocusNode();
  Apis apis = Apis();
  List<LocationData> loctionList = [];
  var loctionId;

  List addressData = <String>['Home', 'Office', 'Other'];
  int? currentTagIndex = 0;

  @override
  void initState() {
    context.read<AddressProvider>().loadedLocation = false;
    if (context.read<AddressProvider>().tag == "home") {
      currentTagIndex = 0;
    } else if (context.read<AddressProvider>().tag == "office") {
      currentTagIndex = 1;
    } else if (context.read<AddressProvider>().tag == "other") {
      currentTagIndex = 2;
    }
    listLocationApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, value, child) {
        if (value.loadedLocation) {
          moveCamera(value);
        }
        return Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: lightGreyColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    size: 24, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text('Add_Address'.tr(),
                  style: AppTextStyles.mediumStyle(
                      AppFontSize.font_18, whiteColor)),
              //backgroundColor: bgColor,
            ),
            body: buildBody(value));
      },
    );
  }

  buildBody(AddressProvider value) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(
          height: 30,
        ),
/*        Text('changeyourAddress'.tr(),
            style: AppTextStyles.extraBoldStyle(
                AppFontSize.font_22, AppColors.blackColor)),*/
        const SizedBox(
          height: 10,
        ),
        _buildTextField(value),
        const SizedBox(
          height: 20,
        ),
        _buildAddressButton(),
        const SizedBox(
          height: 40,
        ),
        _buildGoogleMap(value),
        const SizedBox(
          height: 40,
        ),
        Column(
          children: [
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                addressValidation();
              },
              child: SubmitButton(
                height: 40,
                color: blackColor,
                value: "Submit".tr(),
                textColor: Colors.white,
                textStyle: AppTextStyles.mediumStyle(
                    AppFontSize.font_18, whiteColor),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /*
  void _setMapController(GoogleMapController controller) {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      // _getAddressFromLatLng();
      setState(() {
        Future.delayed(Duration(milliseconds: 3000)).then((onValue) =>
            controller.moveCamera(CameraUpdate.newLatLngZoom(
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
                17)));
      });

    });
  }*/
  _buildTextField(AddressProvider value) {
    return Column(
      children: [
        CustomRoundTextField(
          hintText: "Apartment".tr(),
          //icon: Icon(Icons.lock, color: Colors.black54),
          fillColor: whiteColor,
          controller: apartmentController..text = value.houseNumber ?? "",
          focusNode: apartmentFocusNode,
          onChanged: (text) {
            value.houseNumber = text.toString().trim();
          },
        ),
        CustomRoundTextField(
          hintText: "Building".tr(),
          //icon: Icon(Icons.lock, color: Colors.black54),
          fillColor: whiteColor,
          controller: buildingController..text = value.appartmentOffice ?? "",
          focusNode: buildingFocusNode,
          onChanged: (text) {
            value.appartmentOffice = text.toString().trim();
          },
        ),
        CustomRoundTextField(
          hintText: "Landmark".tr(),
          //icon: Icon(Icons.lock, color: Colors.black54),
          fillColor: whiteColor,
          controller: landmark..text = value.landmark ?? "",
          onChanged: (text) {
            value.landmark = text.toString().trim();
          },
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 4,right: 4),

          child: DropdownButtonFormField<LocationData>(
            decoration:  InputDecoration(
                hintText: 'Location'.tr(),labelStyle: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500)),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_sharp,size: 35,),
            items: loctionList.map((LocationData valuename) =>
                DropdownMenuItem<LocationData>(
                  value: valuename,
                  child: Text(
                    '${valuename.locationName}',
                    softWrap: true,
                  ),
                ),)
                .toList(),
            // hint: Text(
            //     '${selectedSetorTemp.nome} (${selectedSetorTemp.sigla})'),
            onChanged: (LocationData? newValue) {
              setState(() {
                // do your logic here!
                loctionId = newValue!.id;
                print(newValue.id);
                print("hello");
              });
            },
          ),
        ),
const SizedBox(height: 15,),
        CustomRoundTextField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          //Normal textInputField will be displayed
          maxLines: 5,
          // when user presses enter it will adapt to it
          hintText: "Street".tr(),
          //icon: Icon(Icons.lock, color: Colors.black54),
          fillColor: whiteColor,
          readOnly: true,
          controller: address..text = value.address ?? "",
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AutoCompleteScreen()));
          },
          /* onChanged: (text) {
            value.address = text.toString().trim();
          },*/
        ),
        currentTagIndex == 2
            ? CustomRoundTextField(
                hintText: "Other tag".tr(),
                //icon: Icon(Icons.lock, color: Colors.black54),
                fillColor: whiteColor,
                controller: other..text = value.otherTag ?? "",
                onChanged: (text) {
                  value.otherTag = text.toString().trim();
                },
              )
            : const SizedBox(),
      ],
    );
  }

  _buildAddressButton() {
    context.read<AddressProvider>().tag = addressData[currentTagIndex!];
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 0),
              ...List.generate(addressData.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentTagIndex = index;
                    });
                    context.read<AddressProvider>().tag =
                        addressData[currentTagIndex!];
                  },
                  child: Container(
                      margin: const EdgeInsets.all(5),
                      height: 45,
                      width: 110,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          border: Border.all(
                              color: currentTagIndex == index
                                  ? greenColor1
                                  : blackColor,
                              width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(addressData[index],
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.boldStyle(
                                    AppFontSize.font_18,
                                    currentTagIndex == index
                                        ? blackColor
                                        : greyColor)),
                          ])),
                );
              }),
            ]));
  }

  addressValidation() async {
    if (apartmentController.text.isEmpty) {
      appDialog(context, "Please enter apartment name.");
      /*setState(() {
        FocusScope.of(context).requestFocus(apartmentFocusNode);
      });*/
    } else if (buildingController.text.isEmpty) {
      appDialog(context, "Please enter building name.");
      /*setState(() {
        FocusScope.of(context).requestFocus(buildingFocusNode);
      });*/
    } else if (address.text.isEmpty) {
      appDialog(context, "Please select address.");
      /* setState(() {
        FocusScope.of(context).requestFocus(buildingFocusNode);
      });*/
    } else {
      FocusScope.of(context).unfocus();
      context.read<AddressProvider>().addUpdateAddressApi(
            widget.addressId,
            widget.addressId == ""
                ? widget.length == 0
                    ? "1"
                    : "0"
                : context.read<AddressProvider>().isDefault == "1"
                    ? "1"
                    : "0",loctionId
          );
      //listLocationApi();

    }
  }

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  _buildGoogleMap(AddressProvider value) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                  color: whiteColor,
                  height: 400,
                  width: 400,
                  child: GoogleMap(
                    //myLocationEnabled: true,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                      _setMarker(value.lastMapPosition, value.address);
                    },
                    initialCameraPosition: CameraPosition(
                      target: value.lastMapPosition,
                      zoom: 15,
                    ),
                    markers: _markers,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> moveCamera(AddressProvider value) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: value.lastMapPosition, zoom: 15)));
    _setMarker(value.lastMapPosition, value.address);
    value.loadedLocation = false;
  }

  _setMarker(LatLng latLng, String? address) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(latLng.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: address ?? "",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }


  listLocationApi() async {
    var context = NavigationService.navigatorKey.currentContext;
    apis.listLocationApi().then((value) {
      if (value?.status ?? false) {
        setState(() {
          loctionList =  value!.data!;
        });

      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }
}
