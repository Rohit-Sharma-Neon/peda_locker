import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/added_bike_list_response.dart';
import 'package:flutter/cupertino.dart';

class BikeListingProvider extends ChangeNotifier{
  Apis apis = Apis();
  bool isLoadings = false;
  List<BikeData>? data;
  @override
  notifyListeners();


  Future<List<BikeData>?>addBikeListing() async {
      isLoadings = true;
      notifyListeners();
    apis.addBikeListingApi().then((value) {
      if (value?.status ?? false) {
          data = value!.data;
        } else {
        data = null;
      }
      isLoadings = false;
      notifyListeners();
    });
    return data;
  }
  Future<List<BikeData>?>addedBikeListing() async {
      isLoadings = true;
      notifyListeners();
    apis.addedBikeListingApi().then((value) {
      if (value?.status ?? false) {
          data = value!.data;
        } else {
        data = null;
      }
      isLoadings = false;
      notifyListeners();
    });
    return data;
  }
}