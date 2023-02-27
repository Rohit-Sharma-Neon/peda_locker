import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/profile_response.dart';
import 'package:cycle_lock/ui/onboarding/bike_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../utils/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  Apis apis = Apis();
  ProfileData? data;
  bool isLoadings = false;
  @override
  notifyListeners();



  Future<ProfileData?>getProfileApi(bool isLoading) async {
    if (isLoading) {
      isLoadings = true;
      notifyListeners();
    }
    // await spPreferences.remove(SpUtil.PROFILE_DATA);
    await apis.getProfileApis().then((value) {
      if (value?.status ?? false) {
        spPreferences.remove(SpUtil.PREFERENCES_NAMES);
        spPreferences.remove(SpUtil.PREFERENCES_ID);
        data = value!.data!;
        if (isLoading) {
          isLoadings = false;
          notifyListeners();
        }
        spPreferences.setString(SpUtil.PREFERENCES_ID,data?.preferences_id??"");
        spPreferences.setString(SpUtil.PREFERENCES_NAMES,data?.preferences_name??"");
        spPreferences.setString(SpUtil.EMAIL,data?.email??"");
        spPreferences.setString(SpUtil.MOBILE,data?.phone??"");
        spPreferences.setString(SpUtil.NAME,data?.name??"");
      } else {
        if (isLoading) {
          isLoadings = false;
          notifyListeners();
        }
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
    notifyListeners();
    return data;
  }

  updateProfileApi(
      {required String dob,
      required String gender,
      required String name,
      required String image,
      required String height,
      required String heightType,
        String? userType,
      required BuildContext context,
      required String email}) async {
    await apis.updateProfileApi(
            dob: dob, gender: gender, name: name, image: image, email: email,height: height,heightType: heightType)
        .then((value) async {
      if (value?.status ?? false) {
        data = value!.data!;
        getProfileApi(true);
        Fluttertoast.showToast(msg: value.message ?? "");
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
      Navigator.pop(context);
      if (userType == "Registering") {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const BikeDetailScreen(isRegistering: true,)));
      }else{

        Navigator.pop(context,"update");
      }
    });
    notifyListeners();
  }
// getUserData(){
//   if(spPreferences.getString(SpUtil.PROFILE_DATA) != null){
//     data = Data.fromJson(json.decode(spPreferences.getString(SpUtil.PROFILE_DATA)??""));
//     notifyListeners();
//   }
// }
}
