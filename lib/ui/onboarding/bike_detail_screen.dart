import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/providers/bike_listing_provider.dart';
import 'package:cycle_lock/responses/accessories_response.dart';
import 'package:cycle_lock/responses/bike_size_response.dart';
import 'package:cycle_lock/responses/parts_response.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/onboarding/components/header.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/ui/widgets/heading_medium.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import '../../responses/added_bike_list_response.dart';
import '../../responses/bike_brand_response.dart';
import '../../responses/bike_type_response.dart';
import '../../utils/dialogs.dart';
import '../../utils/sizes.dart';
import '../widgets/primary_button.dart';

class BikeDetailScreen extends StatefulWidget {
  final bool isRegistering;
  final bool isEditing;
  final bool isAdding;
  final BikeData? bikeData;

  const BikeDetailScreen(
      {this.isRegistering = false,
      Key? key,
      this.bikeData,
      this.isEditing = false,
      this.isAdding = false})
      : super(key: key);

  @override
  _BikeDetailScreenState createState() => _BikeDetailScreenState();
}

class _BikeDetailScreenState extends State<BikeDetailScreen> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _bicycleValueController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _driverHeightController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController brandController = TextEditingController();

  bool _obscureText = true;

  bool? isOtherShow = false;

  String _bikeType = "";
  String _sizeOfBicycle = "";
  String _brandOfBicycle = "";
  String _heightType = "Cm";
  int selectedOwner = 1;
  String? selectedBikeTypeId;
  String? selectedBikeSizeId;
  String? selectedBikeBrandId;
  final _nickNameFormKey = GlobalKey<FormState>();
  final _bikeValueFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  final _heightFormKey = GlobalKey<FormState>();
  String selectedCountry = "+971";

  resetData() {
    _nickNameController.text = "";
    _bicycleValueController.text = "";
    _nameController.text = "";
    _mobileController.text = "";
    _driverHeightController.text = "";
    selectedAccessories = "";
    selectedParts = "";
    _imageBike = null;
    _imageReceipt = null;
    setState(() {
      _bikeType = "";
      _sizeOfBicycle = "";
      _brandOfBicycle = "";
      _heightType = "Cms";
      // selectedOwner = 1;
    });
  }

  String selectedAccessories = "";
  String selectedParts = "";
  List<String> accessoriesIds = [];
  List<String> partsIds = [];
  late BikeListingProvider bikeListingProvider;

  Apis apis = Apis();
  AccessoriesResponse data = AccessoriesResponse();
  PartsResponse partsData = PartsResponse();
  BikeSizeResponse bikeSizeData = BikeSizeResponse();
  BikeSizeData bikeSizeDetails = BikeSizeData();
  BikeBrandData bikeBrandDetails = BikeBrandData();
  BikeTypeResponse bikeTypeData = BikeTypeResponse();
  BikeBrandResponse bikeBrandData = BikeBrandResponse();
  BikeTypeData bikeTypeDetails = BikeTypeData();
  bool isLoading = true;
  late ScrollController _scrollController;
  List<BikeBrandData>? bikeBrandDataList = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      bikeListingProvider =
          Provider.of<BikeListingProvider>(context, listen: false);
    });
    _scrollController = ScrollController()..addListener(() {});
    super.initState();
    if (mounted) {
      accessoriesApi();
    }
    setData();
  }

  setData() {
    if (widget.isEditing) {
      _nickNameController.text = widget.bikeData?.bike_name ?? "";
      modelController.text = widget.bikeData?.model ?? "";
      _bicycleValueController.text = widget.bikeData?.bikeValue ?? "";
      _nameController.text =
          widget.bikeData?.name == "NULL" ? "" : widget.bikeData?.name ?? "";
      _driverHeightController.text = widget.bikeData?.driverHeight == "NULL"
          ? ""
          : widget.bikeData?.driverHeight ?? "";
      _mobileController.text =
          widget.bikeData?.phone == "NULL" ? "" : widget.bikeData?.phone ?? "";
      accessoriesIds = widget.bikeData?.accessoriesId?.split(",") ?? [];
      bikeTypeDetails.name = widget.bikeData?.bike_name;
      selectedAccessories = widget.bikeData?.accessoriesId.toString() ?? "";
      // selectedParts = widget.bikeData?.partsId.toString()??"";
      partsIds = widget.bikeData?.partsId?.split(",") ?? [];
      _heightType = widget.bikeData?.heightType == "NULL"
          ? "Cm"
          : widget.bikeData?.heightType ?? "Cm";
      selectedBikeTypeId = widget.bikeData?.bikeTypeId.toString() ?? "";
      selectedBikeSizeId = widget.bikeData?.bikeSizeId.toString() ?? "";
      if(widget.bikeData?.brand_id==null){
        brandController.text = widget.bikeData?.brand??"";
        isOtherShow=true;
        selectedBikeBrandId=null;
      }else{
        selectedBikeBrandId = widget.bikeData?.brand_id.toString() ?? "";
        isOtherShow=false;
      }
      if (mounted) {
        setState(() {
          selectedOwner =
              (widget.bikeData?.ownerType ?? "Self") == "Someone Else" ? 2 : 1;
        });
      }
    }
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 400), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          OnBoardingHeader(
              heading: widget.isEditing
                  ? "enterBikeDetails".tr()
                  : "enterBikeDetails".tr(),
              isSkip: widget.isRegistering,
              onSkip: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DashBoardScreen()));
              }),
          Expanded(
            child: isLoading
                ? Loader.load()
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          Form(
                            key: _nickNameFormKey,
                            child: CustomTextField(
                                hintText: "NicknameOfBike".tr(),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    _scrollToTop();
                                    Dialogs().errorDialog(context,
                                        title: "emptyNameError".tr());
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _nickNameController),
                          ),

                          /// Bike Type
                          // DropdownButton<BikeTypeData>(
                          //   hint: _bikeType == ""
                          //       ? Text(
                          //           'BikeType'.tr(),
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         )
                          //       : Text(
                          //           _bikeType,
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         ),
                          //   iconEnabledColor: iconColor,
                          //   isExpanded: true,
                          //   underline: Container(
                          //     height: 2,
                          //     color: underLineColor,
                          //   ),
                          //   iconSize: 30.0,
                          //   items: bikeTypeData.data?.map(
                          //     (val) {
                          //       return DropdownMenuItem<BikeTypeData>(
                          //         value: val,
                          //         child: Text(
                          //           val.name ?? "",
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         ),
                          //       );
                          //     },
                          //   ).toList(),
                          //   onChanged: (val) {
                          //     bikeTypeDetails = val ?? BikeTypeData();
                          //     selectedBikeTypeId = val?.id.toString() ?? "";
                          //     setState(
                          //       () {
                          //         _bikeType = val?.name ?? "";
                          //       },
                          //     );
                          //   },
                          // ),
                          const SizedBox(height: 20),
                          DropdownSearch<BikeTypeData>(
                            mode: Mode.MENU,
                            showSearchBox: true,
                            popupTitle: Text(
                              "BikeType".tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  height: 2),
                            ),
                            items: bikeTypeData.data ?? [],
                            itemAsString: (BikeTypeData? u) => u?.name ?? "",
                            dropdownBuilder: (context, bikeType) {
                              return (_bikeType).isNotEmpty
                                  ? Text(_bikeType,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black))
                                  : Text("BikeType".tr(),
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black));
                            },
                            dropdownButtonProps: const IconButtonProps(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: primaryDark2,
                                size: 30,
                              )
                            ),
                          /*  dropdownButtonBuilder: (context) {
                              return const Icon(
                                Icons.arrow_drop_down,
                                color: primaryDark2,
                                size: 30,
                              );
                            },*/
                            maxHeight: height * 0.4,
                            popupItemBuilder: (context, value, enable) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                child: Text(
                                  value.name ?? "",
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.black),
                                ),
                              );
                            },
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'BikeType'.tr(),
                              hintMaxLines: 1,
                              contentPadding: EdgeInsets.zero,
                              hintStyle: const TextStyle(
                                  fontSize: 24, color: Colors.black),
                              floatingLabelStyle: const TextStyle(fontSize: 24),
                              labelStyle: const TextStyle(fontSize: 24),
                              counterStyle: const TextStyle(fontSize: 24),
                              helperStyle: const TextStyle(fontSize: 24),
                            ),
                            onChanged: (BikeTypeData? val) {
                              bikeTypeDetails = val ?? BikeTypeData();
                              selectedBikeTypeId = val?.id.toString() ?? "";
                              setState(
                                () {
                                  _bikeType = val?.name ?? "";
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          /// Bike Size
                          // DropdownButton<BikeSizeData>(
                          //   hint: _sizeOfBicycle == ""
                          //       ? Text(
                          //           'SizeOfBicycle'.tr(),
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         )
                          //       : Text(
                          //           _sizeOfBicycle,
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         ),
                          //   iconEnabledColor: iconColor,
                          //   isExpanded: true,
                          //   underline: Container(
                          //     height: 2,
                          //     color: underLineColor,
                          //   ),
                          //   iconSize: 30.0,
                          //   items: bikeSizeData.data?.map(
                          //     (val) {
                          //       return DropdownMenuItem<BikeSizeData>(
                          //         value: val,
                          //         child: Text(
                          //           (val.size ?? "") +
                          //               "  " +
                          //               (val.sizeType ?? ""),
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         ),
                          //       );
                          //     },
                          //   ).toList(),
                          //   onChanged: (val) {
                          //     selectedBikeSizeId = val?.id.toString() ?? "";
                          //     bikeSizeDetails = val ?? BikeSizeData();
                          //     setState(
                          //       () {
                          //         _sizeOfBicycle = (val?.size ?? "") +
                          //             "  " +
                          //             (val?.sizeType ?? "");
                          //       },
                          //     );
                          //   },
                          // ),
                          DropdownSearch<BikeSizeData>(
                            mode: Mode.MENU,
                            showSearchBox: true,
                            popupTitle: Text('SizeOfBicycle'.tr(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    height: 2)),
                            items: bikeSizeData.data ?? [],
                            itemAsString: (BikeSizeData? u) =>
                                (u?.size ?? "") + "  ",
                            dropdownSearchBaseStyle: const TextStyle(fontSize: 24),
                            dropdownBuilder: (context, val) {
                              return (_sizeOfBicycle).isNotEmpty
                                  ? Text(_sizeOfBicycle,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black))
                                  : Text("SizeOfBicycle".tr(),
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black));
                            },
                            dropdownButtonProps: const IconButtonProps(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: primaryDark2,
                                  size: 30,
                                )
                            ),

                            // dropdownButtonBuilder: (context) {
                            //   return const Icon(
                            //     Icons.arrow_drop_down,
                            //     color: primaryDark2,
                            //     size: 30,
                            //   );
                            // },
                            maxHeight: height * 0.4,
                            popupItemBuilder: (context, val, enable) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                child: Text(
                                  (val.size ?? "") + "",
                                  style: const TextStyle(fontSize: 24),
                                ),
                              );
                            },
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'SizeOfBicycle'.tr(),
                              hintMaxLines: 1,
                              contentPadding: EdgeInsets.zero,
                              hintStyle: const TextStyle(
                                  fontSize: 24, color: Colors.black),
                              floatingLabelStyle: const TextStyle(fontSize: 24),
                              labelStyle: const TextStyle(fontSize: 24),
                              counterStyle: const TextStyle(fontSize: 24),
                              helperStyle: const TextStyle(fontSize: 24),
                            ),
                            onChanged: (BikeSizeData? val) {
                              selectedBikeSizeId = val?.id.toString() ?? "";
                              bikeSizeDetails = val ?? BikeSizeData();
                              setState(
                                () {
                                  _sizeOfBicycle = (val?.size ?? "") + "  ";
                                },
                              );
                            },
                          ),

                          if(!widget.isRegistering)
                          const SizedBox(height: 20),

                          /// Bike Brand
                          // DropdownButton<BikeBrandData>(
                          //   hint: _brandOfBicycle == ""
                          //       ? Text(
                          //           'Brand of Bicycle',
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         )
                          //       : Text(
                          //           _brandOfBicycle,
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         ),
                          //   iconEnabledColor: iconColor,
                          //   isExpanded: true,
                          //   underline: Container(
                          //     height: 2,
                          //     color: underLineColor,
                          //   ),
                          //   iconSize: 30.0,
                          //   items: bikeBrandData.data?.map(
                          //     (val) {
                          //       return DropdownMenuItem<BikeBrandData>(
                          //         value: val,
                          //         child: Text(
                          //           (val.name ?? ""),
                          //           style: TextStyle(
                          //               color: Colors.black, fontSize: ts24),
                          //         ),
                          //       );
                          //     },
                          //   ).toList(),
                          //   onChanged: (val) {
                          //     selectedBikeBrandId = val?.id.toString() ?? "";
                          //     bikeBrandDetails = val ?? BikeBrandData();
                          //     setState(
                          //       () {
                          //         _brandOfBicycle = (val?.name ?? "");
                          //       },
                          //     );
                          //   },
                          // ),
                          if(!widget.isRegistering)
                          DropdownSearch<BikeBrandData>(
                            mode: Mode.MENU,
                            showSearchBox: true,
                            popupTitle:  Text("BrandOfBicycle".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    height: 2)),
                            items: bikeBrandDataList,
                            dropdownSearchBaseStyle:
                                const TextStyle(fontSize: 24),
                            itemAsString: (BikeBrandData? u) => u?.name ?? "",
                            dropdownBuilder: (context, val) {
                              return (_brandOfBicycle).isNotEmpty
                                  ? Text(_brandOfBicycle,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black))
                                  : Text("BrandOfBicycle".tr(),
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black));
                            },
                            // dropdownButtonBuilder: (context) {
                            //   return const Icon(
                            //     Icons.arrow_drop_down,
                            //     color: primaryDark2,
                            //     size: 30,
                            //   );
                            // },

                            dropdownButtonProps: const IconButtonProps(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: primaryDark2,
                                  size: 30,
                                )
                            ),
                            dropdownSearchDecoration:  InputDecoration(
                              hintText: 'BrandOfBicycle'.tr(),
                              hintMaxLines: 1,
                              contentPadding: EdgeInsets.zero,
                              hintStyle: const TextStyle(
                                  fontSize: 24, color: Colors.black),
                              floatingLabelStyle: const TextStyle(fontSize: 24),
                              labelStyle: const TextStyle(fontSize: 24),
                              counterStyle: const TextStyle(fontSize: 24),
                              helperStyle: const TextStyle(fontSize: 24),
                            ),
                            maxHeight: height * 0.4,
                            popupItemBuilder: (context, val, enable) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                child: Text(
                                  val.name ?? "",
                                  style: const TextStyle(fontSize: 24),
                                ),
                              );
                            },
                            onChanged: (val) {
                              setState(
                                () {
                                  if (val?.name == "Other") {
                                    isOtherShow = true;
                                    selectedBikeBrandId = null;
                                  } else {
                                    bikeBrandDetails = val ?? BikeBrandData();
                                    selectedBikeBrandId =
                                        val?.id.toString() ?? "";
                                    isOtherShow = false;
                                  }
                                  _brandOfBicycle = (val?.name ?? "");
                                },
                              );
                            },
                          ),

                          if(!widget.isRegistering)
                          isOtherShow == true
                              ? Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                        hintText: "enterBrand".tr(),
                                        controller: brandController),
                                  ],
                                )
                              : const SizedBox(),
                          if(!widget.isRegistering)
                          const SizedBox(height: 20),
                          if(!widget.isRegistering)
                          CustomTextField(
                              hintText: "enterModel".tr(),
                              /*keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],*/
                              controller: modelController),

                         /* if(!widget.isRegistering)
                          const SizedBox(height: 20),
                          if(!widget.isRegistering)
                          SizedBox(
                              width: double.infinity,
                              child: headingMedium("selectAccessories".tr())),
                          if(!widget.isRegistering)
                          const SizedBox(height: 10),
                          if(!widget.isRegistering)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.data?.length ?? 0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 3.45),
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    data.data![index].isChecked =
                                        !(data.data?[index].isChecked ?? false);
                                  });
                                },
                                child: SizedBox(
                                  width: width / 2.4,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          value: data.data?[index].isChecked ??
                                              false,
                                          onChanged: (value) {
                                            setState(() {
                                              data.data![index].isChecked =
                                                  value;
                                            });
                                          },
                                          visualDensity: const VisualDensity(
                                              horizontal: -4),
                                          activeColor: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Expanded(
                                          child: Text(
                                              data.data?[index].name ?? "",
                                              style:
                                                  const TextStyle(fontSize: ts22))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if(!widget.isRegistering)
                          const SizedBox(height: 20),
                          if(!widget.isRegistering)
                          SizedBox(
                              width: double.infinity,
                              child: headingMedium("selectParts".tr())),
                          if(!widget.isRegistering)
                          const SizedBox(height: 10),
                          if(!widget.isRegistering)
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: partsData.data?.length ?? 0,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 3.45),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    partsData.data![index].isChecked =
                                        !(partsData.data?[index].isChecked ??
                                            false);
                                  });
                                },
                                child: SizedBox(
                                  width: width / 2.4,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          value: partsData
                                                  .data?[index].isChecked ??
                                              false,
                                          onChanged: (value) {
                                            setState(() {
                                              partsData.data![index].isChecked =
                                                  value;
                                            });
                                          },
                                          visualDensity: const VisualDensity(
                                              horizontal: -4),
                                          activeColor: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Expanded(
                                          child: Text(
                                              partsData.data?[index].name ?? "",
                                              style: const TextStyle(
                                                  fontSize: ts22))),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),*/
                          Form(
                            key: _bikeValueFormKey,
                            child:
                            CustomTextField(
                                maxLength: 6,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    Dialogs().errorDialog(context,
                                        title: "bikeValueEmptyError".tr());
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9.]")),
                                ],
                                hintText: "valueBicycle".tr(),
                                controller: _bicycleValueController,
                                keyboardType: TextInputType.number),
                          ),

                          if(!widget.isRegistering)
                          const SizedBox(height: 40),
                          if(!widget.isRegistering)
                          SizedBox(
                              width: double.infinity,
                              child: headingMedium("uploadReceipt".tr())),
                          if(!widget.isRegistering)
                          const SizedBox(height: 10),

                          /// Receipt
                          if(!widget.isRegistering)
                          Row(
                            children: [
                              widget.isRegistering || widget.isAdding
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      height: 100,
                                      width: 180,
                                      color: greyColor,
                                      child: Center(
                                        child: !kIsWeb &&
                                                defaultTargetPlatform ==
                                                    TargetPlatform.android
                                            ? FutureBuilder<void>(
                                                future: retrieveLostData(true),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<void>
                                                        snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState.none:
                                                    case ConnectionState
                                                        .waiting:
                                                      return profileImage(true);
                                                    case ConnectionState.done:
                                                      return _handlePreview(
                                                          true);
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                          'Pick image/video error: ${snapshot.error}}',
                                                          textAlign:
                                                              TextAlign.center,
                                                        );
                                                      } else {
                                                        return profileImage(
                                                            true);
                                                      }
                                                  }
                                                },
                                              )
                                            : _handlePreview(true),
                                      ),
                                      alignment: Alignment.center)
                                  : Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      height: 100,
                                      width: 180,
                                      color: greyColor,
                                      child: _imageReceipt == null &&
                                              (widget.bikeData?.image ?? "")
                                                  .isNotEmpty
                                          ? Image.network((widget
                                                      .bikeData?.image_url ??
                                                  "") +
                                              "/" +
                                              (widget.bikeData?.image ?? ""))
                                          : Center(
                                              child: !kIsWeb &&
                                                      defaultTargetPlatform ==
                                                          TargetPlatform.android
                                                  ? FutureBuilder<void>(
                                                      future: retrieveLostData(
                                                          true),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<void>
                                                              snapshot) {
                                                        switch (snapshot
                                                            .connectionState) {
                                                          case ConnectionState
                                                              .none:
                                                          case ConnectionState
                                                              .waiting:
                                                            return profileImage(
                                                                true);
                                                          case ConnectionState
                                                              .done:
                                                            return _handlePreview(
                                                                true);
                                                          default:
                                                            if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                'Pick image/video error: ${snapshot.error}}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              );
                                                            } else {
                                                              return profileImage(
                                                                  true);
                                                            }
                                                        }
                                                      },
                                                    )
                                                  : _handlePreview(true),
                                            ),
                                      alignment: Alignment.center),
                              SizedBox(
                                  width: 150,
                                  child: PrimaryButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            15))),
                                            builder: (context) {
                                              return bottomSheet(true);
                                            });
                                      },
                                      title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SvgPicture.asset(icUpload,
                                                height: 30),
                                            Text(
                                              "upload".tr(),
                                              style: const TextStyle(fontSize: ts20),
                                            )
                                          ])))
                            ],
                          ),
                          if(!widget.isRegistering)
                          const SizedBox(height: 40),

                          if(!widget.isRegistering)
                          SizedBox(
                              width: double.infinity,
                              child: headingMedium("uploadBikeImage".tr())),
                          if(!widget.isRegistering)
                          const SizedBox(height: 10),

                          /// Bike
                          if(!widget.isRegistering)
                          Row(
                            children: [
                              widget.isRegistering || widget.isAdding
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      height: 100,
                                      width: 180,
                                      color: greyColor,
                                      child: Center(
                                        child: !kIsWeb &&
                                                defaultTargetPlatform ==
                                                    TargetPlatform.android
                                            ? FutureBuilder<void>(
                                                future: retrieveLostData(false),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<void>
                                                        snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState.none:
                                                    case ConnectionState
                                                        .waiting:
                                                      return profileImage(
                                                          false);
                                                    case ConnectionState.done:
                                                      return _handlePreview(
                                                          false);
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                          'Pick image/video error: ${snapshot.error}}',
                                                          textAlign:
                                                              TextAlign.center,
                                                        );
                                                      } else {
                                                        return profileImage(
                                                            false);
                                                      }
                                                  }
                                                },
                                              )
                                            : _handlePreview(false),
                                      ),
                                      alignment: Alignment.center)
                                  : Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      height: 100,
                                      width: 180,
                                      color: greyColor,
                                      child: _imageBike == null &&
                                              (widget.bikeData?.bike_image ??
                                                      "")
                                                  .isNotEmpty
                                          ? Image.network((widget
                                                      .bikeData?.image_url ??
                                                  "") +
                                              "/" +
                                              (widget.bikeData?.bike_image ??
                                                  ""))
                                          : Center(
                                              child: !kIsWeb &&
                                                      defaultTargetPlatform ==
                                                          TargetPlatform.android
                                                  ? FutureBuilder<void>(
                                                      future: retrieveLostData(
                                                          false),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<void>
                                                              snapshot) {
                                                        switch (snapshot
                                                            .connectionState) {
                                                          case ConnectionState
                                                              .none:
                                                          case ConnectionState
                                                              .waiting:
                                                            return profileImage(
                                                                false);
                                                          case ConnectionState
                                                              .done:
                                                            return _handlePreview(
                                                                false);
                                                          default:
                                                            if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                'Pick image/video error: ${snapshot.error}}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              );
                                                            } else {
                                                              return profileImage(
                                                                  false);
                                                            }
                                                        }
                                                      },
                                                    )
                                                  : _handlePreview(false),
                                            ),
                                      alignment: Alignment.center),
                              SizedBox(
                                  width: 150,
                                  child: PrimaryButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            15))),
                                            builder: (context) {
                                              return bottomSheet(false);
                                            });
                                      },
                                      title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SvgPicture.asset(icUpload,
                                                height: 30),
                                            Text(
                                              "upload".tr(),
                                              style: const TextStyle(fontSize: ts20),
                                            )
                                          ])))
                            ],
                          ),

                          !widget.isRegistering ?
                          const SizedBox(height: 20) : const SizedBox(height: 40),

                          widget.isRegistering
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: double.infinity,
                                        child:
                                            headingMedium("selectOwner".tr())),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedOwner = 1;
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 16),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: selectedOwner == 1
                                                          ? 2
                                                          : 1,
                                                      color: selectedOwner == 1
                                                          ? Colors.grey.shade700
                                                          : Colors.grey)),
                                              child: Text("self".tr(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: ts22)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedOwner = 2;
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 16),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: selectedOwner == 2
                                                          ? 2
                                                          : 1,
                                                      color: selectedOwner == 2
                                                          ? Colors.grey.shade700
                                                          : Colors.grey)),
                                              child: Text("someoneElse".tr(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: ts22)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    selectedOwner == 1
                                        ? const SizedBox()
                                        : animatedColumn(
                                            children: [
                                              Form(
                                                key: _nameFormKey,
                                                child: CustomTextField(
                                                    validator: (val) {
                                                      if (val!.isEmpty) {
                                                        Dialogs().errorDialog(
                                                            context,
                                                            title:
                                                                "elseNameEmptyError"
                                                                    .tr());
                                                        return "";
                                                      } else if (val.length <
                                                          2) {
                                                        Dialogs().errorDialog(
                                                            context,
                                                            title:
                                                                "elseNameLengthError"
                                                                    .tr());
                                                        return "";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    hintText: "name".tr(),
                                                    controller:
                                                        _nameController),
                                              ),
                                              const SizedBox(height: 20),
                                              Form(
                                                key: _phoneFormKey,
                                                child: CustomTextField(
                                                    prefixIcon: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CountryCodePicker(
                                                          onChanged: (val) {
                                                            selectedCountry =
                                                                val.dialCode!;
                                                          },
                                                          flagWidth: 60,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          initialSelection:
                                                              selectedCountry,
                                                          showCountryOnly:
                                                              false,
                                                          showOnlyCountryWhenClosed:
                                                              false,
                                                          textStyle: const TextStyle(
                                                            fontSize: 24,
                                                            color: textColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          alignLeft: false,
                                                        ),
                                                        const SizedBox(width: 0),
                                                        SvgPicture.asset(
                                                            icArrowDown),
                                                        const SizedBox(width: 14),
                                                      ],
                                                    ),
                                                    validator: (val) {
                                                      if (val!.isEmpty) {
                                                        Dialogs().errorDialog(
                                                            context,
                                                            title:
                                                                "elseMobileEmptyError"
                                                                    .tr());
                                                        return "";
                                                      } else if (val.length <
                                                          8) {
                                                        Dialogs().errorDialog(
                                                            context,
                                                            title:
                                                                "elseMobileLengthError"
                                                                    .tr());
                                                        return "";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    maxLength: 13,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    hintText:
                                                        "mobileNumber".tr(),
                                                    controller:
                                                        _mobileController),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    flex: 8,
                                                    child: Container(
                                                      height: 54,
                                                      margin: const EdgeInsets.only(
                                                          bottom: 7),
                                                      child: Form(
                                                        key: _heightFormKey,
                                                        child: CustomTextField(
                                                            maxLength: 6,
                                                            validator: (val) {
                                                              if (val!
                                                                  .isEmpty) {
                                                                Dialogs().errorDialog(
                                                                    context,
                                                                    title: "driverHeightEmptyError"
                                                                        .tr());
                                                                return "";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                      "[0-9]")),
                                                            ],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            hintText:
                                                                "driverHeight"
                                                                    .tr(),
                                                            controller:
                                                                _driverHeightController),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      height: 54,
                                                      child: DropdownButton(
                                                        hint:
                                                            _heightType == "Cm"
                                                                ? Text(
                                                                    'Cm'.tr(),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            ts24),
                                                                  )
                                                                : Text(
                                                                    _heightType,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            ts24),
                                                                  ),
                                                        iconEnabledColor:
                                                            Colors.black,
                                                        isExpanded: true,
                                                        underline: Container(
                                                          height: 1,
                                                          color: underLineColor,
                                                        ),
                                                        iconSize: 30.0,
                                                        items: [
                                                          "Cm".tr(),
                                                          "Inch".tr()
                                                        ].map(
                                                          (val) {
                                                            return DropdownMenuItem(
                                                              value: val,
                                                              child: Text(
                                                                val,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        ts24),
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                        onChanged: (val) {
                                                          setState(
                                                            () {
                                                              _heightType = val
                                                                  .toString();
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  //     TextButton(
                                                  //   onPressed: () {
                                                  //
                                                  //   },
                                                  //   child: Text(addMoreBike,style: TextStyle(shadows: [
                                                  //     Shadow(
                                                  //         color: primaryDark,
                                                  //         offset: Offset(0, -5))
                                                  //   ],fontSize: ts22,fontWeight: FontWeight.bold,color: Colors.transparent,
                                                  //     decoration: TextDecoration.underline,
                                                  //     decorationColor: primaryDark,
                                                  //     decorationThickness: 1,
                                                  //   )),
                                                  // ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                            ],
                                          ),
                                  ],
                                ),

                          SizedBox(
                            height: 60,
                            child: PrimaryButton(
                              onPressed: () {
                                if (isOtherShow == true) {
                                  FocusScope.of(context).unfocus();
                                  selectedAccessories = "";
                                  selectedParts = "";
                                  data.data?.forEach((element) {
                                    if (element.isChecked == true) {
                                      if (selectedAccessories == "") {
                                        selectedAccessories =
                                            element.id.toString();
                                      } else {
                                        selectedAccessories +=
                                            "," + element.id.toString();
                                      }
                                    }
                                    // element.isChecked = false;
                                  });
                                  partsData.data?.forEach((element) {
                                    if (element.isChecked ?? false) {
                                      if (selectedParts == "") {
                                        selectedParts = element.id.toString();
                                      } else {
                                        selectedParts +=
                                            "," + element.id.toString();
                                      }
                                    }
                                    // element.isChecked = false;
                                  });
                                  if (_nickNameFormKey.currentState!
                                      .validate()) {
                                    if (_bikeType == "") {
                                      _scrollToTop();
                                      Dialogs().errorDialog(context,
                                          title: "bikeTypeEmptyError".tr());
                                    } else if (_sizeOfBicycle == "") {
                                      _scrollToTop();
                                      Dialogs().errorDialog(context,
                                          title: "bikeSizeEmptyError".tr());
                                    } else if (_sizeOfBicycle == "") {
                                      _scrollToTop();
                                      Dialogs().errorDialog(context,
                                          title: "bikeSizeEmptyError".tr());
                                    } else if (brandController.text.isEmpty) {
                                      _scrollToTop();
                                      Dialogs().errorDialog(context,
                                          title: "Enter Bike Brand!");
                                    } else if (_bikeValueFormKey.currentState!
                                        .validate()) {
                                      if (widget.isAdding) {
                                        if (selectedOwner == 1) {
                                          Loaders().loader(context);
                                          if (widget.isEditing) {
                                            editBikeApi();
                                          } else {
                                            addBikeApi();
                                          }
                                        } else if (selectedOwner == 2) {
                                          if (_nameFormKey.currentState!
                                              .validate()) {
                                            if (_phoneFormKey.currentState!
                                                .validate()) {
                                              if (_heightFormKey.currentState!
                                                  .validate()) {
                                                Loaders().loader(context);
                                                if (widget.isEditing) {
                                                  editBikeApi();
                                                } else {
                                                  addBikeApi();
                                                }
                                              }
                                            }
                                          }
                                        }
                                      } else if (selectedOwner == 1) {
                                        Loaders().loader(context);
                                        if (widget.isEditing) {
                                          editBikeApi();
                                        } else {
                                          addBikeApi();
                                        }
                                      } else if (selectedOwner == 2) {
                                        if (_nameFormKey.currentState!
                                            .validate()) {
                                          if (_phoneFormKey.currentState!
                                              .validate()) {
                                            if (_heightFormKey.currentState!
                                                .validate()) {
                                              Loaders().loader(context);
                                              if (widget.isEditing) {
                                                editBikeApi();
                                              } else {
                                                addBikeApi();
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                                else {
                                  FocusScope.of(context).unfocus();
                                  selectedAccessories = "";
                                  selectedParts = "";
                                  data.data?.forEach((element) {
                                    if (element.isChecked == true) {
                                      if (selectedAccessories == "") {
                                        selectedAccessories =
                                            element.id.toString();
                                      } else {
                                        selectedAccessories +=
                                            "," + element.id.toString();
                                      }
                                    }
                                    // element.isChecked = false;
                                  });
                                  partsData.data?.forEach((element) {
                                    if (element.isChecked ?? false) {
                                      if (selectedParts == "") {
                                        selectedParts = element.id.toString();
                                      } else {
                                        selectedParts +=
                                            "," + element.id.toString();
                                      }
                                    }
                                    // element.isChecked = false;
                                  });
                                  if (_nickNameFormKey.currentState!
                                      .validate()) {
                                    if (_bikeType == "") {
                                      _scrollToTop();
                                      Dialogs().errorDialog(context,
                                          title: "bikeTypeEmptyError".tr());
                                    } else if (_sizeOfBicycle == "") {
                                      _scrollToTop();
                                      Dialogs().errorDialog(context,
                                          title: "bikeSizeEmptyError".tr());
                                    } else if (_sizeOfBicycle == "") {
                                      _scrollToTop();
                                      Dialogs().errorDialog(context,
                                          title: "bikeSizeEmptyError".tr());
                                    } else if (_brandOfBicycle == "" && !widget.isRegistering) {
                                      _scrollToTop();
                                      Dialogs().errorDialog(context,
                                          title: "Bike Brand Can't Be Empty!");
                                    } else if (_bikeValueFormKey.currentState!
                                        .validate()) {
                                      if (widget.isAdding) {
                                        if (selectedOwner == 1) {
                                          Loaders().loader(context);
                                          if (widget.isEditing) {
                                            editBikeApi();
                                          } else {
                                            addBikeApi();
                                          }
                                        } else if (selectedOwner == 2) {
                                          if (_nameFormKey.currentState!
                                              .validate()) {
                                            if (_phoneFormKey.currentState!
                                                .validate()) {
                                              if (_heightFormKey.currentState!
                                                  .validate()) {
                                                Loaders().loader(context);
                                                if (widget.isEditing) {
                                                  editBikeApi();
                                                } else {
                                                  addBikeApi();
                                                }
                                              }
                                            }
                                          }
                                        }
                                      } else if (selectedOwner == 1) {
                                        Loaders().loader(context);
                                        if (widget.isEditing) {
                                          editBikeApi();
                                        } else {
                                          addBikeApi();
                                        }
                                      } else if (selectedOwner == 2) {
                                        if (_nameFormKey.currentState!
                                            .validate()) {
                                          if (_phoneFormKey.currentState!
                                              .validate()) {
                                            if (_heightFormKey.currentState!
                                                .validate()) {
                                              Loaders().loader(context);
                                              if (widget.isEditing) {
                                                editBikeApi();
                                              } else {
                                                addBikeApi();
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              title: Text("strContinue".tr(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: ts22)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // TextButton(
                          //   onPressed: () {
                          //
                          //   },
                          //   child: Text(addMoreBike,style: TextStyle(shadows: [
                          //     Shadow(
                          //         color: primaryDark,
                          //         offset: Offset(0, -5))
                          //   ],fontSize: ts22,fontWeight: FontWeight.bold,color: Colors.transparent,
                          //     decoration: TextDecoration.underline,
                          //     decorationColor: primaryDark,
                          //     decorationThickness: 1,
                          //   )),
                          // ),
                          const SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  List<Map> availableHobbies = [
    {"name": "Foobball", "isChecked": false},
    {"name": "Baseball", "isChecked": false},
    {
      "name": "Video",
      "isChecked": false,
    },
    {"name": "Readding", "isChecked": false},
    {"name": "Surfling", "isChecked": false}
  ];

  // bool isAccessoriesLoading = true;
  // bool isPartsLoading = true;
  // bool isSizeLoading = true;
  // bool isBikeTypeLoading = true;
  // bool isRiderHeightLoading = true;
  bool isBikeAdding = false;

  accessoriesApi() async {
    await apis.accessoriesApi().then((value) {
      if (value?.status ?? false) {
        partsApi();
        data = value!;
        data.data?.forEach((accessories) {
          accessoriesIds.forEach((id) {
            if ((accessories.id.toString()) == id) {
              setState(() {
                accessories.isChecked = true;
              });
            }
          });
        });
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  partsApi() async {
    await apis.partsApi().then((value) {
      if (value?.status ?? false) {
        bikeTypeApi();
        partsData = value!;
        partsData.data?.forEach((parts) {
          partsIds.forEach((id) {
            if ((parts.id.toString()) == id) {
              setState(() {
                parts.isChecked = true;
              });
            }
          });
        });
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
      // setState(() {
      //   isPartsLoading = false;
      // });
    });
  }

  bikeSizeApi() async {
    await apis.bikeSizeApi().then((value) {
      if (value?.status ?? false) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        bikeBrandApi();
        bikeSizeData = value!;
        if (widget.isEditing) {
          bikeSizeData.data?.forEach((element) {
            if (element.id == (widget.bikeData?.bikeSizeId ?? "0")) {
              setState(() {
                _sizeOfBicycle = "${element.size}";
              });
            }
          });
        }
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  bikeBrandApi() async {
    await apis.bikeBrandApi().then((value) {
      if (value?.status ?? false) {
        setState(() {
          isLoading = false;
        });
        bikeBrandData = value!;
        for (var a in bikeBrandData.data!) {
          bikeBrandDataList!.add(a);
        }
        bikeBrandDataList!.add(
            BikeBrandData(id: 0, name: "Other", createdAt: "", updatedAt: ""));

        if (widget.isEditing) {
          bikeBrandData.data?.forEach((element) {
            if (element.id == (widget.bikeData?.bikeSizeId ?? "0")) {
              setState(() {
                if(isOtherShow==false){
                  _brandOfBicycle = "${element.name}";
                }else{
                  _brandOfBicycle="Other";
                }
              });
            }
          });
        }
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  bikeTypeApi() async {
    // setState(() {
    //   isBikeTypeLoading = true;
    // });
    await apis.bikeTypeApi().then((value) {
      if (value?.status ?? false) {
        bikeSizeApi();

        bikeTypeData = value!;
        if (widget.isEditing) {
          bikeTypeData.data?.forEach((element) {
            if (element.id == (widget.bikeData?.bikeTypeId ?? "0")) {
              setState(() {
                _bikeType = element.name ?? "";
              });
            }
          });
        }
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  addBikeApi() async {
    if (selectedOwner == 1) {
      _nameController.text = "";
      _mobileController.text = "";
      _driverHeightController.text = "";
    }
    await apis
        .addBikeApi(
            model: modelController.text.toString(),
            bikeName: _nickNameController.text,
            bikeTypeId: bikeTypeDetails.id ?? 0,
            bikeValue: _bicycleValueController.text,
            ownerType: selectedOwner == 1 ? "Self" : "Someone Else",
            name: selectedOwner == 1 ? "" : _nameController.text,
            countryCode: selectedCountry.replaceAll("+", ""),
            phone: selectedOwner == 1 ? "" : _mobileController.text.trim(),
            driverHeight:
                selectedOwner == 1 ? "" : _driverHeightController.text.trim(),
            heightType: _heightType,
            accessoriesId: selectedAccessories,
            partId: selectedParts,
            brand_id: selectedBikeBrandId??"",
            brand: brandController.text.toString(),
            bikeSizeId: bikeSizeDetails.id ?? 0,
            image: _imageReceipt ?? null,
            bike_image: _imageBike ?? null)
        .then((value) {
      if (value?.status ?? false) {
        data.data?.forEach((element) {
          if (element.isChecked == true) {
            element.isChecked = false;
          }
        });
        partsData.data?.forEach((element) {
          if (element.isChecked == true) {
            element.isChecked = false;
          }
        });
        bikeListingProvider.addedBikeListing();
        Navigator.pop(context, "update");
        showAlertDialog(context);
        Fluttertoast.showToast(msg: value?.message ?? "");
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
      // setState(() {
      //   isBikeAdding = false;
      // });
    });
  }

  editBikeApi() async {
    if (selectedOwner == 1) {
      _nameController.text = "";
      _mobileController.text = "";
      _driverHeightController.text = "";
    }
    await apis
        .updateBikeApi(
            model: modelController.text.toString(),
            bikeName: _nickNameController.text,
            bikeTypeId: (selectedBikeTypeId.toString() == 0
                ? ""
                : selectedBikeTypeId.toString()),
            bikeValue: _bicycleValueController.text,
            ownerType: selectedOwner == 1 ? "Self" : "Someone Else",
            name: selectedOwner == 1 ? "" : _nameController.text,
            bikeId: widget.bikeData?.id.toString() ?? "",
            countryCode: selectedCountry.replaceAll("+", ""),
            phone: selectedOwner == 1 ? "" : _mobileController.text.trim(),
            driverHeight:
                selectedOwner == 1 ? "" : _driverHeightController.text.trim(),
            heightType: _heightType,
            accessoriesId: selectedAccessories,
            partId: selectedParts,
            brand_id: selectedBikeBrandId??"",
            brand: brandController.text.toString(),
            bikeSizeId: (selectedBikeSizeId.toString() == 0
                ? ""
                : selectedBikeSizeId.toString()),
            image: _imageReceipt ?? null,
            bike_image: _imageBike ?? null)
        .then((value) {
      if (value?.status ?? false) {
        data.data?.forEach((element) {
          if (element.isChecked == true) {
            element.isChecked = false;
          }
        });
        partsData.data?.forEach((element) {
          if (element.isChecked == true) {
            element.isChecked = false;
          }
        });
        Navigator.pop(context, "update");
        Navigator.pop(context, "update");
        Fluttertoast.showToast(msg: value?.message ?? "");
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
      // setState(() {
      //   isBikeAdding = false;
      // });
    });
  }

  showAlertDialog(BuildContext context) {
    Dialogs().confirmationDialog(context,
        message: widget.isEditing
            ? "BikeUpdatedSuccessfully".tr()
            : "BikeAddedSuccessfully".tr(), onCancel: () {
      resetData();
      Navigator.pop(context, false);
      widget.isRegistering
          ? Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DashBoardScreen()))
          : Navigator.pop(context, "update");
    }, onContinue: () {
      resetData();

      _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);

      Navigator.pop(context, "update");
    });
  }

  XFile? _imageReceipt;
  XFile? _imageBike;

  set _setReceiptImage(XFile? value) {
    _imageReceipt = value;
  }

  set _setBikeImage(XFile? value) {
    _imageBike = value;
  }

  dynamic _pickImageError;
  String? _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source, bool isReceipt) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 30,
    );
    setState(() {
      isReceipt ? _setReceiptImage = pickedFile : _setBikeImage = pickedFile;
    });
  }

  Future<void> retrieveLostData(isReceipt) async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        isReceipt
            ? _setReceiptImage = response.file
            : _setBikeImage = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageReceipt != null) {
      return Container(
          width: 180,
          height: 100,
          color: Colors.white,
          child: Image.file(
            File(_imageReceipt?.path ?? ""),
            height: 200,
            width: 200,
            fit: BoxFit.fitHeight,
          ));
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return profileImage(true);
    }
  }

  Widget _previewBikeImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageBike != null) {
      return Container(
          width: 180,
          height: 100,
          color: Colors.white,
          child: Image.file(
            File(_imageBike?.path ?? ""),
            height: 200,
            width: 200,
            fit: BoxFit.fitHeight,
          ));
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return profileImage(false);
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _handlePreview(isReceipt) {
    return isReceipt ? _previewImages() : _previewBikeImage();
  }

  Widget bottomSheet(isReciept) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt, size: 30, color: Colors.black),
            title: Text('Camera'.tr(),
                style: const TextStyle(fontSize: ts22, fontWeight: FontWeight.w500)),
            onTap: () {
              pickImage(ImageSource.camera, isReciept);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image, size: 30, color: Colors.black),
            title: Text('Gallery'.tr(),
                style: const TextStyle(fontSize: ts22, fontWeight: FontWeight.w500)),
            onTap: () {
              pickImage(ImageSource.gallery, isReciept);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget profileImage(isReciept) {
    return isReciept
        ? const Icon(
            Icons.document_scanner_outlined,
            size: 60,
            color: lightGreyColor,
          )
        : SvgPicture.asset(
            icSmallBicycle,
            height: 40,
            color: lightGreyColor,
          );
  }
}
