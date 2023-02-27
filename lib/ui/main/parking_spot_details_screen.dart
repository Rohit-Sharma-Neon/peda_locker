import 'dart:async';

import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/ui/main/thankyou_screen.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/heading_medium.dart';
import 'package:cycle_lock/ui/widgets/primary_button.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/api_provider.dart';
import '../../responses/parking_spots_details_response.dart';
import '../../utils/dialogs.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import '../onboarding/bike_detail_screen.dart';
import '../widgets/tag.dart';
import 'book_now_screen.dart';

class ParkingSpotDetailsScreen extends StatefulWidget {
  final String? soptId;
  final String? bikeName;

  const ParkingSpotDetailsScreen(
      {Key? key, this.soptId,this.bikeName = ""})
      : super(key: key);

  @override
  _ParkingSpotDetailsScreenState createState() => _ParkingSpotDetailsScreenState();
}

class _ParkingSpotDetailsScreenState extends State<ParkingSpotDetailsScreen> {
  List<String> images = [];
  List<String> title = [];

  Data? spotsDetail;
  Data? data = Data();

  Apis apis = Apis();
  bool isLoading = false;
  int? bike_count = 0;
  bool isGuest = false;

  @override
  void initState() {
    isGuest = spPreferences.getBool(SpUtil.IS_GUEST) ?? false;
    parkingSportDetailsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(
          title: spotsDetail != null ? spotsDetail!.name!.toString() : "",
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: (spotsDetail?.totalSpace ?? 0) /*- (spotsDetail?.containerCount ?? 0)*/ !=
                          0
                      ? Text(
                          ("${(spotsDetail?.totalSpace ?? 0) /*- (spotsDetail?.containerCount ?? 0)*/} ${"spaces".tr()}"),
                          style: const TextStyle(fontSize: ts20),
                        )
                      : const SizedBox(),
                ),
              ],
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: scaffoldHorizontalPadding, vertical: 30),
        child: isLoading
            ?  Center(
                child: Loader.load(),
              )
            : ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            icStar,
                            height: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                              "${spotsDetail?.avgRate?.toString()} ( ${spotsDetail?.totalRate?.toString()} ${"Review".tr()})",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: ts20)),
                        ],
                      ),
                      spotsDetail?.markParkingSpotAsFeatured == "1"
                          ? tag("FEATURED".tr())
                          : const SizedBox(),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    color: greyColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headingMedium("address".tr()),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            launchMap(
                                lat: spotsDetail?.lat.toString() ?? "",
                                long: spotsDetail?.log.toString() ?? "");
                          },
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(icLocation, height: 36,),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: width - 140,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            spotsDetail?.location?.toString() ??
                                                "",
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: ts22,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          spotsDetail?.distance?.toString() ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: ts23,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  title.length != 0
                      ?
                  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headingMedium("amenities".tr()),
                            const SizedBox(height: 15),
                            GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: title.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5, childAspectRatio: 1.1),
                              itemBuilder: (BuildContext context, int index) {
                                return
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      color: greyColor,
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.network(images[index], height: 24),
                                          RichText(
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                            text: title[index],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                  fontSize: ts14,
                                                  fontWeight: FontWeight.w500)
                                            ),
                                          )
                                         /* Text(title[index],
                                              overflow: TextOverflow.ellipsis,
                                              textAlign:
                                              TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: ts14,
                                                  fontWeight: FontWeight.w500)),*/
                                        ],
                                      ),

                                ),
                                  );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        )
                      : const SizedBox(),
                  headingMedium("description".tr()),
                  const SizedBox(height: 10),
                  Text(
                    spotsDetail!.descriptions!.toString(),
                    textAlign: TextAlign.justify,
                    style:
                        const TextStyle(fontSize: ts18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                      onPressed: () {
                        isGuest
                            ? Dialogs().errorDialog(context,
                                title: "guestError".tr(), navLogin: true)
                            : bike_count != 0
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookNowScreen(
                                              soptId:
                                                  spotsDetail?.id.toString() ??
                                                      ""
                                                          "",

                                              bikeName: widget.bikeName,
                                            )))
                                : addBikeDialog(context);
                      },
                      title: Text(
                        "bookNow".tr(),
                        style: const TextStyle(fontSize: ts22),
                      )),
                  const SizedBox(height: 30),
                  Container(
                    child: primaryCarousel(spotsDetail?.banner)
                    /*Image.asset(
                      "assets/images/banner.jpeg",
                      height: 250,
                      fit: BoxFit.fill,
                    ),*/
                  ),
                  const SizedBox(height: 30),
                ],
              ),
      ),
    );
  }

  Widget primaryCarousel(List<BannerBottom>? banner) {
    return Column(
      children: [
        CarouselSlider(
          items: banner?.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Column(
                  children: [
                    Image.network(
                      (i.image ?? ""),
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.fill,
                    ),
                  ],
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
              autoPlay: true,
              autoPlayAnimationDuration:
              const Duration(milliseconds: 800),
              enlargeCenterPage: false,
              height: 250,
              viewportFraction: 1.0,
              disableCenter: true,
              onPageChanged: (index, reason) {
                setState(() {});
              }),
        ),

        const SizedBox(height: 10),
      ],
    );
  }

  addBikeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: const Text("Error!", style: TextStyle(fontSize: 28)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Lottie.network(bike)),
              const SizedBox(height: 8),
              Text("addBikeAlert".tr(),
                  style: const TextStyle(fontSize: 25), textAlign: TextAlign.center),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 15, top: 5),
              child: PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BikeDetailScreen(
                                  isAdding: true,
                                ))).then((value) {
                      if (value == "update") {
                        parkingSportDetailsApi();
                      }
                    });
                  },
                  title: Text("AddBike".tr(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500))),
            ),
          ],
        );
      },
    );
  }

  launchMap({required String lat, required String long}) async {
    var mapSchema = 'geo:$lat,$long';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not launch $mapSchema';
    }
  }

  parkingSportDetailsApi() async {
    setState(() {
      isLoading = true;
    });
    apis
        .parkingSportDetailsApi(widget.soptId ??  "")
        .then((value) {
      if (value?.status ?? false) {
        setState(() {
          spotsDetail = value?.data!;
          bike_count = value?.data?.bikeCount ?? 0;
          title.clear();
          images.clear();
          for (var a in spotsDetail!.amenity!) {
            title.add(a.name.toString());
            images.add("${a.imageUrl}/${a.logo}");
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }
}
