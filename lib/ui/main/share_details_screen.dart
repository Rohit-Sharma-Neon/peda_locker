import 'package:clippy_flutter/arc.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/heading_medium.dart';
import 'package:cycle_lock/ui/widgets/not_found_text.dart';
import 'package:cycle_lock/ui/widgets/primary_button.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../network/api_provider.dart';
import '../../responses/sahre_bike_details_response.dart';
import '../../utils/dialogs.dart';
import '../../utils/strings.dart';

class ShareBikeDetailScreen extends StatefulWidget {
  String? shareId;

  ShareBikeDetailScreen({Key? key, this.shareId}) : super(key: key);

  @override
  State<ShareBikeDetailScreen> createState() => _ShareBikeDetailScreenState();
}

class _ShareBikeDetailScreenState extends State<ShareBikeDetailScreen> {
  Apis apis = Apis();
  bool isLoading = false;
  List<BikeAccessories>? bikeAccessories;
  List<BikeParts>? bikeParts;
  ShareBikeDetailsResponse? shareBikeDetailsResponse;

  @override
  void initState() {
    shareDetailsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "shareBike".tr()),
      body: isLoading
          ?  Center(
              child: Loader.load(),
            )
          : shareBikeDetailsResponse != null
              ? ListView(
                  children: [
                    Container(
                      color: greyBgColor,
                      margin: const EdgeInsets.symmetric(
                          horizontal: scaffoldHorizontalPadding, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(
                                      "${shareBikeDetailsResponse?.data?.imageUrl}/${shareBikeDetailsResponse?.data?.bikeImage}",
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return SvgPicture.asset(
                                          icSmallBicycle,
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.fitWidth,
                                          color: lightGreyColor,
                                        ); //do something
                                      },
                                      height: 24,
                                      width: 24,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                        shareBikeDetailsResponse
                                                ?.data?.bikeName ??
                                            "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: ts30,
                                        )),
                                  ],
                                ),
                                SvgPicture.asset(icLockShare, height: 32),
                              ],
                            ),
                          ),
                          const Divider(
                              endIndent: 0, indent: 0, color: Colors.black),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                bikeAccessories != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Locker No. #${shareBikeDetailsResponse?.data?.lockerNo?.toString() ?? ""}",
                                            style: const TextStyle(
                                              fontSize: ts22,
                                            ),
                                          ),
                                          Text("accessories".tr(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: ts28)),
                                          Wrap(children: [
                                            for (var i in bikeAccessories!)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(i.name ?? "",
                                                    style: const TextStyle(
                                                        fontSize: ts20,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )
                                          ]),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 10),
                                bikeParts != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("parts".tr(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: ts28)),
                                          Wrap(children: [
                                            for (var i in bikeParts!)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 14,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(i.name ?? "",
                                                    style: const TextStyle(
                                                        fontSize: ts20,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )
                                          ]),
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Container(
                      color: greyBgColor,
                      margin: const EdgeInsets.symmetric(
                          horizontal: scaffoldHorizontalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("address".tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: ts28)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(icMapGroup,
                                            height: 36),
                                        const SizedBox(width: 16),
                                        Text(
                                            shareBikeDetailsResponse
                                                    ?.data?.location ??
                                                "",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontSize: ts28)),
                                      ],
                                    ),
                                    Text(
                                        shareBikeDetailsResponse
                                                ?.data?.distance ??
                                            "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: ts28)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    shareBikeDetailsResponse?.data?.startDateTime != null
                        ? Container(
                            width: double.infinity,
                            color: greyBgColor,
                            margin: const EdgeInsets.only(
                                left: scaffoldHorizontalPadding,
                                right: scaffoldHorizontalPadding,
                                top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("date".tr(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: ts28)),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(icCalendar,
                                              height: 36),
                                          const SizedBox(width: 16),
                                          Text(
                                              "${shareBikeDetailsResponse?.data?.startDateTime.toString() ?? ""}\n"
                                              "${shareBikeDetailsResponse?.data?.endDateTime.toString() ?? ""}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: ts28)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    Container(
                      color: greyBgColor,
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: scaffoldHorizontalPadding,
                          right: scaffoldHorizontalPadding,
                          top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("containerDetail".tr(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: ts28)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        "#${shareBikeDetailsResponse?.data?.containerDetails?.containerNo?.toString() ?? ""}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 36)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("pin".tr(),
                                    style: const TextStyle(
                                      fontSize: ts28,
                                    )),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("0123".tr(),
                                        style: const TextStyle(
                                            fontSize: ts28,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 16),
                                    SvgPicture.asset(icCopy)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: scaffoldHorizontalPadding),
                      child: PrimaryButton(
                          onPressed: () {

                            showAlertDialog(
                                context,
                                shareBikeDetailsResponse?.data?.isLock.toString() ==
                                    "unlock"
                                    ? "lockAlert".tr()
                                    : "unlockAlert".tr(),
                                "unlock",
                            );



                          },
                          title: Text(
                            "${shareBikeDetailsResponse?.data?.isLock?.toString()[0].toUpperCase()}${shareBikeDetailsResponse?.data?.isLock?.toString().substring(1)}",
                            style: const TextStyle(fontSize: 28),
                          )),
                    )
                  ],
                )
              : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           // Lottie.network(animCycleUrl),
            notFound("dataNotFound".tr())
          ],
        ),
                ),
    );
  }

  Widget parts() {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text("dsadas",
          style: TextStyle(fontSize: ts20, fontWeight: FontWeight.w500)),
    );
  }
  showAlertDialog(BuildContext context, message, title) {
    Dialogs().confirmationDialog(context, onContinue: () {
      Navigator.pop(context);

      if (title == "unlock") {
        ordersUnlockApi(
          shareBikeDetailsResponse?.data?.orderId.toString(),
          shareBikeDetailsResponse?.data?.bikeId.toString(),
          shareBikeDetailsResponse?.data?.isLock.toString() == "lock"
              ? "unlock"
              : "lock",
          shareBikeDetailsResponse?.data?.id.toString(),

        );
      }
    }, message: message.toString());
  }
  ordersUnlockApi(orderId, bike_id, is_lock,share_id) async {
    setState(() {
      isLoading = true;
    });
    apis
        .shareOrderUnlockApi(orderId, bike_id, share_id,is_lock)
        .then((value) {
      setState(() {
        isLoading = false;
      });
      if (value?.status ?? false) {
        Navigator.pop(context);
        showMessageDialog(context, value?.message?.toString() ?? "");
      } else {
        showMessageDialog(context, value?.message?.toString() ?? "");
      }
    });
  }
  showMessageDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }

  shareDetailsApi() async {
    setState(() {
      isLoading = true;
    });
    apis.shareDetailsApi(widget.shareId, context).then((value) {
      setState(() {
        if (value?.status ?? false) {
          shareBikeDetailsResponse = value!;
          if (value.data?.bikeAccessories != null) {
            bikeAccessories = value.data!.bikeAccessories!;
          }
          if (value.data?.bikeParts != null) {
            bikeParts = value.data!.bikeParts!;
          }
          bikeParts;
          isLoading = false;
        } else {
          isLoading = false;
        }
      });
    });
  }
}
