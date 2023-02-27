import 'package:cycle_lock/providers/bike_listing_provider.dart';
import 'package:cycle_lock/ui/main/parking_spots_screen.dart';
import 'package:cycle_lock/ui/onboarding/bike_detail_screen.dart';
import 'package:cycle_lock/ui/widgets/not_found_text.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../network/api_provider.dart';
import '../../responses/added_bike_list_response.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import 'add_accessories.dart';
import 'add_part.dart';
import 'book_now_screen.dart';

class MyGearScreen extends StatefulWidget {
  const MyGearScreen({Key? key}) : super(key: key);

  @override
  _MyGearScreenState createState() => _MyGearScreenState();
}

class _MyGearScreenState extends State<MyGearScreen>
    with AutomaticKeepAliveClientMixin {
  Apis apis = Apis();
  bool isLoading = false;

  // List<BikeData>? data;
  late BikeListingProvider bikeListingProvider;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      bikeListingProvider = Provider.of<BikeListingProvider>(context, listen: false);
      bikeListingProvider.addedBikeListing();
    });
    // addedBikeListing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body:
          Consumer<BikeListingProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return Column(
                children: [_buildBody(value),SizedBox(height:60)],

              );
            },
          )),
    );
  }

  Future<void> _pullRefresh() async {
    bikeListingProvider.addedBikeListing();
  }

  customAppbar() {
    return SafeArea(
      child: Container(
          height: 70,
          width: double.infinity,
          color: lightGreyColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(
                context,
              );
            },
            child: Container(
              color: lightGreyColor,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      //  SvgPicture.asset(backArrow, height: 30),
                        const Icon(Icons.arrow_back_ios_rounded, size: 28,color: Colors.white),
                        const SizedBox(width: 20),
                        Text("MyGear".tr(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: ts22)),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BikeDetailScreen(
                                        isAdding: true,
                                      ))).then((value) {
                            if (value == "update") {
                              bikeListingProvider.addedBikeListing();
                            }
                          });
                        },
                        child: const Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        )),
                  ]),
            ),
          )),
    );
  }

  _buildBody(BikeListingProvider value) {
    return Expanded(
      child: value.isLoadings
          ?  Center(
              child: Loader.load(),
            )
          : value.data != null && value.data!.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Column(
                      children: List.generate(
                        value.data?.length ?? 0,
                        (position) {
                          return buildUserCard(position, value);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // buildCarImages(),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        //Lottie.network(lottieUrl),
                        notFound("dataNotFound".tr())
                      ],
                    ),
                  ),
                ),
    );
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      bikeListingProvider.addedBikeListing();
    }
  }

  buildUserCard(position, BikeListingProvider value) {
    if(value.data?[position].type ==0){
      return Container(
        margin: const EdgeInsets.only(bottom: 16, top: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: greyBgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              flex: 1,
              child: (value.data?[position].bike_image ?? "").isNotEmpty
                  ? Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        value.data![position].image_url.toString() +
                            "/" +
                            value.data![position].bike_image.toString()),
                    //whatever image you can put here
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : SvgPicture.asset(
                icSmallBicycle,
                width: 18,
                height: 35,
                fit: BoxFit.fitWidth,
                color: lightGreyColor,
              )),
          const SizedBox(width: 15),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                          "BikeName".tr() +
                              value.data![position].bikeName.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: ts22)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                            onTap: () {
                              showAlertDialog(context, "Edit", position, value);
                            },
                            child: const Icon(
                              Icons.edit_outlined,
                              size: 30,
                            )),
                        const SizedBox(width: 15),
                        GestureDetector(
                            onTap: () {
                              showAlertDialog(context, "Delete", position, value);
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              size: 30,
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                value.data![position].accessories != null &&
                    value.data![position].accessories != ""
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                          "BikeAccessories".tr() +
                              value.data![position].accessories.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                )
                    : const SizedBox(),
                const SizedBox(height: 6),
                value.data![position].parts != null &&
                    value.data![position].parts != ""
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                          "BikeParts".tr() +
                              value.data![position].parts.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                )
                    : SizedBox(),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParkingSpotsScreen(
                                    bikeName: value.data?[position].bike_name)));
                      },
                      child: Container(
                          width: 140,
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: buttonColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text("BookStorage".tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: ts14))),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    }
    else if(value.data?[position].type ==2){
      return Container(
        margin: const EdgeInsets.only(bottom: 16, top: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: greyBgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          showAlertDialog2(context, "Edit", position, value);
                        },
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 30,
                        )),
                    const SizedBox(width: 15),
                    GestureDetector(
                        onTap: () {
                          showAlertDialog2(context, "Delete", position, value);
                        },
                        child: const Icon(
                          Icons.delete_outline,
                          size: 30,
                        )),
                  ],
                ),
                value.data![position].accessories != null &&
                    value.data![position].accessories != ""
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                          "BikeAccessories".tr() +
                              value.data![position].accessories.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                )
                    : const SizedBox(),
                value.data![position].parts != null &&
                    value.data![position].parts != ""
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                          "BikeParts".tr() +
                              value.data![position].parts.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                )
                    : SizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "brand".tr()  +": "+
                              value.data![position].brand.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "model".tr()  +": "+
                              value.data![position].model.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                ),
                value.data![position].description!=null?
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "description".tr() +": "+
                              value.data![position].description.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                ):SizedBox(),
                SizedBox(height: 5),

              ],
            ),
          ),
        ]),
      );
    }
    else{
      return Container(
        margin: const EdgeInsets.only(bottom: 16, top: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: greyBgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          showAlertDialog1(context, "Edit", position, value);
                        },
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 30,
                        )),
                    const SizedBox(width: 15),
                    GestureDetector(
                        onTap: () {
                          showAlertDialog1(context, "Delete", position, value);
                        },
                        child: const Icon(
                          Icons.delete_outline,
                          size: 30,
                        )),
                  ],
                ),
                value.data![position].accessories != null &&
                    value.data![position].accessories != ""
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                          "BikeAccessories".tr() +
                              value.data![position].accessories.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                )
                    : const SizedBox(),
                value.data![position].parts != null &&
                    value.data![position].parts != ""
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                          "BikeParts".tr() +
                              value.data![position].parts.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                )
                    : SizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "brand".tr()  +": "+
                              value.data![position].brand.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "model".tr()  +": "+
                              value.data![position].model.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                ),
                value.data![position].description!=null?
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "description".tr() +": "+
                              value.data![position].description.toString(),
                          style: const TextStyle(fontSize: ts16)),
                    ),
                  ],
                ):SizedBox(),
                SizedBox(height: 5),

              ],
            ),
          ),
        ]),
      );
    }

  }

  // addedBikeListing(BikeListingProvider value) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   apis.addedBikeListingApi().then((value) {
  //     if (value?.status ?? false) {
  //       setState(() {
  //         value.data = value!.value.data;
  //         isLoading = false;
  //       });
  //     } else {
  //       value.data = null;
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   });
  // }

  deleteBikeApi(bikeId) async {
    setState(() {
      isLoading = true;
    });
    apis.deleteBikeApi(bikeId).then((value) {
      if (value?.status ?? false) {
        setState(() {
          bikeListingProvider.addedBikeListing();
          // addedBikeListing();
          //data = value!.data;
          isLoading = false;
        });
      } else {
        Dialogs()
            .errorDialog(context, title: value?.message ?? "defaultError".tr());
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  showMessageDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }

  showAlertDialog(
      BuildContext context, String title, position, BikeListingProvider value) {
    Dialogs().confirmationDialog(context,
        message: title == "Edit"
            ? "alertEditBike".tr()
            : "alertDeleteBike".tr(), onContinue: () {
      Navigator.of(context).pop();
      if (title == "Edit") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BikeDetailScreen(
                    isEditing: true,
                    bikeData: value.data![position]))).then((value) {
          if (value == "update") {
            bikeListingProvider.addedBikeListing();
          }
        });
      } else {

        deleteBikeApi(value.data![position].id);
      }
    });
  }
  showAlertDialog2(
      BuildContext context, String title, position, BikeListingProvider value) {
    Dialogs().confirmationDialog(context,
        message: title == "Edit"
            ? "alertEditParts".tr()
            : "alertDeleteparts".tr(), onContinue: () {
      Navigator.of(context).pop();
      if (title == "Edit") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddPart(
                    isEditing: true,
                    bikeData: value.data![position]))).then((value) {
          if (value == "update") {
            bikeListingProvider.addedBikeListing();
          }
        });
      } else {

        deleteBikeApi(value.data![position].id);
      }
    });
  }
  showAlertDialog1(
      BuildContext context, String title, position, BikeListingProvider value) {
    Dialogs().confirmationDialog(context,
        message: title == "Edit"
            ? "alertEditAccessories".tr()
            : "alertDeleteAccessories".tr(), onContinue: () {
      Navigator.of(context).pop();
      if (title == "Edit") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddAccessories(
                    isEditing: true,
                    bikeData: value.data![position]))).then((value) {
          if (value == "update") {
            bikeListingProvider.addedBikeListing();
          }
        });
      } else {

        deleteBikeApi(value.data![position].id);
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
