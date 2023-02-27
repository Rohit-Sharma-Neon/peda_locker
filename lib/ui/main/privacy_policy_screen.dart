import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/privacy_policy_response.dart';
import 'package:cycle_lock/responses/terms_conditions_response.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/sizes.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

  Apis apis = Apis();
  bool isLoading = true;
  PrivacyPolicyResponse data = PrivacyPolicyResponse();


  @override
  void initState() {
    super.initState();
    privacyApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  BaseAppBar(title: "PrivacyPolicy".tr()),
      body: isLoading ?  Center(child: Loader.load(),) : animatedColumn(padding: const EdgeInsets.all(12),crossAxisAlignment: CrossAxisAlignment.center,children: [
        Text(data.data?.description??"",style: const TextStyle(fontSize: ts20)),
      ]),
    );
  }
  privacyApi()async{
    await apis.privacyPolicyApi().then((value) {
      if (value?.status??false) {
        data = value!;
        setState(() {
          isLoading = false;
        });
      }else{
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: value?.message??"");
      }
    });
  }
}
