import 'package:cycle_lock/responses/profile_response.dart';

class ProfileCalculator {
  static var getPercent = 0;

  static calculate(ProfileData? data) {
    int percent = 0;
    if (data?.image != null && data?.image != "" && data?.image != "no_image.jpg") {
      percent += 10;
    }
    if (data?.name != null && data?.name != ""  && (data?.is_name_update ?? 0) == 1) {
      percent += 15;
    }
    if (data?.email != null && data?.email != "") {
      percent += 15;
    }
    if (data?.phone != null && data?.phone != "") {
      percent += 15;
    }
    if (data?.dob != null && data?.image != "") {
      percent += 15;
    }
    if (data?.height != null && data?.height != "" && data?.height != "0") {
      percent += 15;
    }
    if (data?.gender != null && data?.gender != "") {
      percent += 15;
    }
    getPercent = percent;
  }
}
