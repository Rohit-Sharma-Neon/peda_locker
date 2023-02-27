import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../network/api_provider.dart';
import '../../responses/coupon_list.dart';
import '../../utils/dialogs.dart';
import '../../utils/sizes.dart';
import '../widgets/primary_button.dart';

class FeedbackScreen extends StatefulWidget {
  final bool isShow;

  const FeedbackScreen({Key? key, this.isShow = false}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<Coupon>? couponList;
  final TextEditingController messageController = TextEditingController();
  Apis apis = Apis();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(title: "SendUsAppFeedback".tr()),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Column(
              children: [
                TextField(
                    maxLines: 4,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      counterText: '',
                      // labelText: '',
                      hintText: "enterFeedback".tr(),
                      hintStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: hintColor,
                          fontSize: 24),
                    ),
                    maxLength: 200,
                    controller: messageController),
                const SizedBox(height: 70),
                PrimaryButton(
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      sendFeedbackApi(messageController.text.toString());
                    }
                  },
                  title: Text("send".tr(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: ts20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildCouponCard(position) {
    String firstHalf = "";
    String secondHalf = "";
    bool flag = true;
    if (couponList?[position].descriptions != null) {
      var descriptions = couponList?[position].descriptions;

      if (descriptions!.length > 50) {
        firstHalf = descriptions.substring(0, 50);
        secondHalf = descriptions.substring(50, descriptions.length);
      } else {
        firstHalf = descriptions;
        secondHalf = "";
      }
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.isShow) {
                Navigator.pop(context, couponList?[position].id);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DottedBorder(
                padding: const EdgeInsets.all(15),
                color: lightGreyColor,
                strokeWidth: 2,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(couponList?[position].name ?? "",
                            style: const TextStyle(
                                color: lightGreyColor,
                                fontWeight: FontWeight.w500,
                                fontSize: ts20)),
                        widget.isShow
                            ? Row(
                                children: [
                                  Text("Apply".tr(),
                                      style: const TextStyle(
                                          color: lightGreyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: ts20)),
                                  const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 18,
                                    color: lightGreyColor,
                                  )
                                ],
                              )
                            : const SizedBox()
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
              "${"Get".tr()} ${couponList?[position].discount ?? ""}% Off".tr(),
              style: const TextStyle(
                  color: buttonColor,
                  fontWeight: FontWeight.bold,
                  fontSize: ts16)),
          const SizedBox(height: 15),
          /* Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf)),
          InkWell(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                 InkWell(
                   onTap: (){
                     setState(() {
                       if(flag){
                         flag=false;
                       }
                     });
                   },
                   child: Text(
                    flag ? "show more" : "show less",
                    style: new TextStyle(color: Colors.blue),
                ),
                 ),
              ],
            ),
            onTap: () {

            },
          ),*/

          Text(
            couponList?[position].descriptions ?? "",
            textAlign: TextAlign.justify,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black,
                fontSize: ts18,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 15),
          /* couponList![position].descriptions!.length>50?
          InkWell(
            onTap: (){

            },
            child: Text("More",
                style: TextStyle(
                    color: lightGreyColor,
                    fontWeight: FontWeight.bold,
                    fontSize: ts16)),
          )
          :SizedBox(),*/
        ],
      ),
      margin: const EdgeInsets.only(bottom: 16, top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: greyBgColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  setDescriptions(descriptions) {
    String firstHalf;
    String secondHalf;

    bool flag = true;
    if (descriptions.length > 50) {
      firstHalf = descriptions.substring(0, 50);
      secondHalf = descriptions.substring(50, descriptions.length);
    } else {
      firstHalf = descriptions;
      secondHalf = "";
    }
  }

  showAlertDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }

  couponListApi() async {
    setState(() {
      isLoading = true;
    });
    apis.couponListApi().then((value) {
      if (value?.status ?? false) {
        setState(() {
          couponList = value?.data!;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  sendFeedbackApi(message) async {
    Loaders().loader(context);
    apis.sendFeedbackApi(message).then((value) {
      Navigator.of(context).pop();
      if (value!.status == true) {
        Navigator.pop(context);
        showAlertDialog(context, value.message ?? "");
      } else {
        messageController.text = "";
        setState(() {
          showAlertDialog(context, value.message ?? "");
        });
      }
    });
  }
}
