import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/terms_conditions_response.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({Key? key}) : super(key: key);

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {

  Future<void> share() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    await FlutterShare.share(
        title: 'Pedalocker',
        text: 'For Download Pedalocker App Click On this link ',
        linkUrl: ' https://pedalocker.com',
        chooserTitle: 'Pedalocker');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(title: "InviteFriend".tr()),
        body: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: Text("shareWithFriends".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: lightGreyColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
            ),
            const SizedBox(height: 20),
            // SizedBox(
            //   width: double.infinity,
            //   child: Text("shareWithFriends".tr(),
            //       textAlign: TextAlign.center,
            //       style: const TextStyle(
            //           fontWeight: FontWeight.w400, fontSize: ts18)),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset(pedaLogo, width: MediaQuery.of(context).size.width - 150,),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 48),
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    share();
                  },
                  child: Text(
                    "Share".tr(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: ts20,
                        fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  )),
            ),
          ],
        ));
  }
}
