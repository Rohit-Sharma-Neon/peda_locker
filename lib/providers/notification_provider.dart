import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../responses/notification_list_response.dart';

class NotificationProvider extends ChangeNotifier {
  Apis apis = Apis();
  int unReads = 0;
  bool isLoadings = false;
  List<NotificationData>? data = [];
  @override
  notifyListeners();

  setUnReads(int unReadss){
    unReads = unReadss;
    notifyListeners();
  }

  readIncrement(){
    unReads++;
    notifyListeners();
  }

  readDecrement(){
    unReads--;
    notifyListeners();
  }

  notificationListingApi(BuildContext context,bool isLoading,isSet) async {
    if (isLoading) {
      isLoadings = true;
      notifyListeners();
    }
    apis.notificationListingApi().then((value) {
      if (value?.status ?? false) {
        data = value!.data;
        notifyListeners();
        if(isSet){
          setUnReads(data?.length??0);
        }
        if (isLoading) {
          isLoadings = false;
          notifyListeners();
        }

      } else {
        if (isLoading) {
          isLoadings = false;
          notifyListeners();
        }
          data != null ? data?.clear() : data;
      }
    });
    notifyListeners();
  }

  notificationReadApi(String notificationId,bool isAll,BuildContext context) async {
    apis.notificationReadApi(notificationId).then((value) {
      if (value?.status ?? false) {
        if (isAll) {
          setUnReads(0);
          notificationListingApi(context,true,false);
        }
      } else {
      }
    });
  }
  notificationUnReadApi(bool isAll,BuildContext context) async {
    apis.notificationUnReadApi().then((value) {
      if (value?.status ?? false) {
        if (isAll) {
         // setUnReads(0);
          notificationListingApi(context,true,true);
        }
      } else {
      }
    });
  }

  notificationDeleteApi(String notificationId,BuildContext context,bool isAll) async {
    apis.notificationDeleteApi(notificationId).then((value) {
      if (value?.status ?? false) {
        if (isAll) {
          setUnReads(0);
          notificationListingApi(context,true,false);
        }
      } else {
      }
    });
  }


}