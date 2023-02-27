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

class AddAccessories extends StatefulWidget {
  final bool isRegistering;
  final bool isEditing;
  final bool isAdding;
  final BikeData? bikeData;

  const AddAccessories(
      {this.isRegistering = false,
      Key? key,
      this.bikeData,
      this.isEditing = false,
      this.isAdding = false})
      : super(key: key);

  @override
  _AddAccessoriesState createState() => _AddAccessoriesState();
}

class _AddAccessoriesState extends State<AddAccessories> {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _driverHeightController = TextEditingController();

  bool _obscureText = true;

  // bool? isNutrition = false,isBikes = false, isAccessories = false;

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
  String? selectedAccessoriesName;
  String? selectedAccessoriesId;

  XFile? _image;

  String selectedAccessories = "";
  String selectedParts = "";
  String? accessoriesIds;
  List<String> partsIds = [];
  late BikeListingProvider bikeListingProvider;
  var accessoriesName = [];

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
      brandController.text = widget.bikeData?.brand ?? "";
      yearController.text = widget.bikeData?.year ?? "";
      valueController.text = widget.bikeData?.bikeValue ?? "";
      modelController.text = widget.bikeData?.model ?? "";
      descriptionController.text = widget.bikeData?.description ?? "";
      selectedAccessoriesId = widget.bikeData?.accessoriesId;
      setState(() {
        selectedAccessoriesName = widget.bikeData?.accessories;

      });
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
                  ? "selectAccessories".tr()
                  : "selectAccessories".tr(),
              isSkip: widget.isRegistering,
              onSkip: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashBoardScreen()));
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
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("selectAccessories".tr(),
                                  style: const TextStyle(
                                      fontSize: ts24,
                                      fontWeight: FontWeight.w700,
                                      color: textColor)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300),
                              padding: const EdgeInsets.all(10),
                              child: DropdownButton(
                                isExpanded: true,
                                underline: Container(),
                                hint: Text(selectedAccessoriesName ?? "",
                                    style: const TextStyle(
                                        fontSize: ts24,
                                        fontWeight: FontWeight.w500,
                                        color: textColor)),
                                // Not necessary for Option 1
                                onChanged: (newValue) {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  if (newValue != null) {
                                    setState(() {
                                      selectedAccessoriesName =
                                          newValue.toString();
                                      for (var a in data.data!) {
                                        if (a.name == selectedAccessoriesName) {
                                          selectedAccessoriesId =
                                              a.id.toString();
                                        }
                                      }
                                      print("sfasdfsadfadsf" +
                                          selectedAccessoriesId.toString());
                                    });
                                  }
                                },
                                items: accessoriesName.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    value: location.toString(),
                                  );
                                }).toList(),
                              )),
                          const SizedBox(height: 20),

                          CustomTextField(
                              hintText: "enterBrand".tr(),
                              controller: brandController),
                          const SizedBox(height: 20),
                          CustomTextField(
                              hintText: "enterModel".tr(),
                              /*keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],*/
                              controller: modelController),
                          const SizedBox(height: 20),
                          CustomTextField(
                              maxLength: 6,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.]")),
                              ],
                              hintText: "valueAed".tr(),
                              controller: valueController,
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 20),
                          CustomTextField(
                              maxLength: 4,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.]")),
                              ],
                              hintText: "year".tr(),
                              controller: yearController,
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 20),
                          CustomTextField(
                              maxLines: 4,
                              maxLength: 50,
                              hintText: "enterDescription".tr(),
                              controller: descriptionController),
                          const SizedBox(height: 40),

                          SizedBox(
                              width: double.infinity,
                              child: headingMedium("uploadPhoto".tr())),
                          const SizedBox(height: 10),


                          Row(
                            children: [
                              widget.isRegistering || widget.isAdding
                                  ?
                              Container(
                                  margin: EdgeInsets.only(right: 20),
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
                                  child: _image == null &&
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
                                              style: TextStyle(fontSize: ts20),
                                            )
                                          ])))
                            ],
                          ),

                          const SizedBox(height: 50),
                          SizedBox(
                            height: 60,
                            child: PrimaryButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();

                                if (selectedAccessoriesId == null) {
                                Dialogs().errorDialog(context,
                                title: "pleaseSelectAccessories".tr());
                                }else if (brandController.text.trim().isEmpty) {
                                  Dialogs().errorDialog(context,
                                      title: "pleaseEnterBrand".tr());
                                }else if (valueController.text.trim().isEmpty) {
                                  Dialogs().errorDialog(context,
                                      title: "pleaseEnterAccessoriesValue".tr());
                                }else if (yearController.text.trim().isEmpty) {
                                  Dialogs().errorDialog(context,
                                      title: "pleaseEnterAccessoriesYear".tr());
                                }  else {
                                  Loaders().loader(context);
                                  if (widget.isEditing) {
                                    editAccessoriesApi();
                                  } else {
                                    addAccessoriesApi();
                                  }
                                }
                              },
                              title: Text("strContinue".tr(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: ts22)),
                            ),
                          ),
                          SizedBox(
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

  // bool isAccessoriesLoading = true;
  // bool isPartsLoading = true;
  // bool isSizeLoading = true;
  // bool isBikeTypeLoading = true;
  // bool isRiderHeightLoading = true;
  bool isBikeAdding = false;

  accessoriesApi() async {
    await apis.accessoriesApi().then((value) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      if (value?.status ?? false) {
        data = value!;
        data.data?.forEach((accessories) {
          accessoriesName.add(accessories.name);
        });
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  addAccessoriesApi() async {
    await apis
        .addAccessoriesApi(
      accessoriesId: selectedAccessoriesId.toString(),
      model: modelController.text.toString(),
      description: descriptionController.text.toString(),
      brand: brandController.text.toString(),
      value: valueController.text.toString(),
      year: yearController.text.toString(),
      image: _image,
    )
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
        Navigator.pop(context, "update");

        //showAlertDialog(context);
        // Dialogs().errorDialog(
        //   context,
        //   title:
        //   "AccessoriesAddSuccessfully".tr(),
        // );
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

  editAccessoriesApi() async {
    await apis
        .updateAccessoriesApi(
      accessoriesId: selectedAccessoriesId.toString(),
      bikeId: widget.bikeData?.id.toString() ?? "",
      model: modelController.text.toString(),
      description: descriptionController.text.toString(),
      brand: brandController.text.toString(),
      value: valueController.text.toString(),
      year: yearController.text.toString(),
      image: _image,
    )
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

      Navigator.pop(context, false);
      widget.isRegistering
          ? Navigator.push(context,
              MaterialPageRoute(builder: (context) => const DashBoardScreen()))
          : Navigator.pop(context, "update");
    }, onContinue: () {
      Navigator.pop(context, "update");
    });
  }

  XFile? _imageReceipt;
  XFile? _imageBike;

  set _setReceiptImage(XFile? value) {
    _image = value;
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
    if (_image != null) {
      return Container(
          width: 180,
          height: 100,
          color: Colors.white,
          child: Image.file(
            File(_image?.path ?? ""),
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
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.camera_alt, size: 30, color: Colors.black),
            title: Text('Camera'.tr(),
                style: TextStyle(fontSize: ts22, fontWeight: FontWeight.w500)),
            onTap: () {
              pickImage(ImageSource.camera, isReciept);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.image, size: 30, color: Colors.black),
            title: Text('Gallery'.tr(),
                style: TextStyle(fontSize: ts22, fontWeight: FontWeight.w500)),
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
        ? Icon(
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
