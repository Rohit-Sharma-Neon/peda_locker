import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/terms_conditions_response.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/sizes.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {

  Apis apis = Apis();
  bool isLoading = true;
  TermsConditionsResponse data = TermsConditionsResponse();


  @override
  void initState() {
    super.initState();
    termsApi();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  BaseAppBar(title: "TermsAndConditions".tr()),
      body: isLoading ?  Center(child: Loader.load(),) : animatedColumn(crossAxisAlignment: CrossAxisAlignment.center,children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(data.data?.description??"",style: const TextStyle(fontSize: ts20)),
        ),
      ]),
    );
  }
  termsApi()async{
    await apis.termsConditionsApi().then((value) {
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
