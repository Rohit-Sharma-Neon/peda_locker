
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/network/webapi_constaint.dart';
import 'package:cycle_lock/responses/address_list_modal.dart';
import 'package:cycle_lock/responses/address_modal.dart';
import 'package:cycle_lock/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../responses/data_modal.dart';
import '../utils/colors.dart';
import '../utils/contextnavigation.dart';

class AddressProvider with ChangeNotifier {

  DataModal? defaultAddress;
  List dataList = <DataModal>[];
  Apis apis = Apis();
  bool isLoadings = true;

  LatLng lastMapPosition = const LatLng(0.0, 0.0);
  //LatLng get lastMapPosition => center;
  var loadedLocation = false;

  init(){
    isLoadings = true;
  }

  setDefaultAddress(defaultAddress){
    this.defaultAddress = defaultAddress;
  }

  setCenter(value){
    lastMapPosition = value;
    notifyListeners();
  }

  AddressModal? data;

  double? latitude;
  double? longitude;
  String? address;

  String? houseNumber;
  String? locationId;
  String? appartmentOffice;
  String? landmark;
  String? tag;
  String? otherTag;
  String? isDefault;

  setTagData(DataModal value){
    houseNumber = value.houseNumber;
    appartmentOffice = value.appartmentOffice;
    landmark = value.landmark;
    tag = value.tag;
    otherTag = value.otherTag;
    isDefault = value.isDefault;
    address = value.address;
    latitude = double.parse(value.latitude!);
    longitude = double.parse(value.longitude!);
    lastMapPosition = LatLng(latitude!, longitude!);
  }

  clearTag(){
    houseNumber="";
    appartmentOffice="";
    landmark="";
    tag="";
    otherTag="";
    address="";
    isDefault="";
    latitude = 0.0;
    longitude = 0.0;
    lastMapPosition= const LatLng(0.0, 0.0);
  }

  setData(LatLng center, address){
    latitude = center.latitude;
    longitude = center.longitude;
    this.address =  address;
    loadedLocation = true;
    setCenter(center);
  }

  /*addUpdateAddressApi(addressId, isDefault) async {
    var context = NavigationService.navigatorKey.currentContext;

    *//*await ApiBaseHelper().postApiCall(true, addressId == "" ? addAddress : updateAddress, body).then((value) {
      AddressModal modal = AddressModal.fromJson(value, false);
      if (modal.status == true) {
        appDialog(context!, modal.message!);
      }
    });*//*


  }*/

  Future<AddressModal?> addUpdateAddressApi(addressId, isDefault,locationId) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = addressId != "" ? {
      "id": addressId ,
      "address": address,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "is_default": isDefault,
      "tag": tag,
      "house_number": houseNumber,
      "appartment_office": appartmentOffice,
      "landmark": landmark,
      "other_tag": otherTag,
      "location_id":locationId,
    }: {
      "address": address,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "is_default": isDefault,
      "tag": tag,
      "house_number": houseNumber,
      "appartment_office": appartmentOffice,
      "landmark": landmark,
      "other_tag": otherTag,
      "location_id":locationId,
    };

    isLoadings = true;
    notifyListeners();
    apis.addUpdateAddressApi(addressId, body).then((value) {
      if (value?.status ?? false) {
        appDialog(context!, value?.message ?? "", "back");
      }else{
        appDialog(context!, value?.message ?? "", "");
      }
      isLoadings = false;
      notifyListeners();
    });
    //return data;
  }


  Future<AddressListModal?> getAddressApi(type) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body={};
    isLoadings = true;
    notifyListeners();
    apis.getAddressApi(body).then((value) {
      if (value?.status ?? false) {
        dataList = value!.data!;
      }
      isLoadings = false;
      getDefaultAddressApi();
      notifyListeners();
    });
    //return data;
  }



  // getAddressApi(type) async {
  //   var context = NavigationService.navigatorKey.currentContext;
  //   Map<String, dynamic> body = {};
  //   await ApiBaseHelper().postApiCall(true, getAddress, body, isPopup: false).then((value) {
  //     AddressModal modal = AddressModal.fromJson(value, true);
  //     if (modal.status == true) {
  //       dataList = modal.dataList!;
  //       if(type == "back"){
  //         Navigator.of(context!).pop();
  //       }
  //     }
  //     notifyListeners();
  //   });
  // }

  atRemove(index) {
    dataList.removeAt(index);
    notifyListeners();
  }

  deleteAddressApi(addressId, index) async {
    Map<String, dynamic> body = {"id": addressId};
    var context = NavigationService.navigatorKey.currentContext;
    isLoadings = true;
    notifyListeners();
    apis.commonApi(WebAPIConstant.deleteAddress, body).then((value) {
      if (value?.status ?? false) {
        atRemove(index);
      }
      isLoadings = false;
      notifyListeners();
    });
  }



  getDefaultAddressApi() async {
    Map<String, dynamic> body = {};
    var context = NavigationService.navigatorKey.currentContext;
    isLoadings = true;
    notifyListeners();
    apis.commonApi(WebAPIConstant.getDefaultAddress, body).then((value) {
      if (value?.status ?? false) {
        data = value;
        setDefaultAddress(data?.data);
      }
      isLoadings = false;
      notifyListeners();
    });
  }

  updateDefaultAddressApi(addressId) async {
    var context = NavigationService.navigatorKey.currentContext;
    Map<String, dynamic> body = {"id": addressId};
    apis.commonApi(WebAPIConstant.defaultAddress, body).then((value) {
      if (value?.status ?? false) {
        appDialog(context!, value?.message ?? "", "back");
      }
      isLoadings = false;

      notifyListeners();
    });
  }

  appDialog(BuildContext context, String message, type) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          title:  const Text(AppStrings.appTitle,
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w600)),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: blackColor, // background
                  onPrimary: whiteColor, // foreground
                ),
                onPressed: () {
                  if(type == "back"){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }else{
                    Navigator.of(context).pop();
                  }

                  getAddressApi("back");
                },
                child: const Text('OK')),
          ],
        ),
      ),
    );
  }
}
