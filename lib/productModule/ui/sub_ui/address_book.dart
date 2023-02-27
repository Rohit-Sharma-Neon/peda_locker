import "package:flutter/material.dart";
import "package:easy_localization/easy_localization.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/address_provider.dart';
import '../../../responses/data_modal.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/colors.dart';
import '../../../utils/utility.dart';
import 'change_address.dart';

class AddressBookScreen extends StatefulWidget {
  static const routeName = "/address-book";

  const AddressBookScreen({Key? key}) : super(key: key);

  @override
  _AddressBookScreenState createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {


  Future<bool> _willPopCallback() async {
    if(context.read<AddressProvider>().dataList.isNotEmpty){
      Navigator.of(context).pop("Back");
    }else{
      Navigator.of(context).pop("");
    }
    return Future.value(true);
  }

  @override
  void initState() {
    context.read<AddressProvider>().dataList.clear();
    Future.microtask(() => context.read<AddressProvider>().getAddressApi("none"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, value, child) {
        return WillPopScope(
          onWillPop: () => _willPopCallback(),
          child: Scaffold(
              backgroundColor: whiteColor,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: lightGreyColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      size: 24, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text('AddressBook'.tr(),
                    style: AppTextStyles.mediumStyle(
                        AppFontSize.font_18, whiteColor)),
                //backgroundColor: bgColor,
              ),
              body: value.isLoadings ? Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: const CircularProgressIndicator(),) : buildBody(value)),
        );
      },
    );
  }

  buildBody(AddressProvider value) {
    /* if(value.dataList?.isDefault == "1") {
      _groupValue = value.data.d;
    }*/
    return Container(
        padding: const EdgeInsets.all(0.0),
        decoration: const BoxDecoration(),
        child: ListView(children: [
          const SizedBox(height: 15),
          Column(children: [
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Choose_an_Address'.tr(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: AppTextStyles.boldStyle(
                                  AppFontSize.font_22, blackColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Divider(height: 1, color: blackColor),
                    const SizedBox(height: 8),
                    ListView.builder(
                        itemBuilder: (context, index) =>
                            buildAddressCard(index, value.dataList[index]),
                        itemCount: value.dataList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true)
                  ],
                ),
              ],
            ),
          ]),
          const SizedBox(height: 2),
          GestureDetector(
              onTap: () {
                context.read<AddressProvider>().clearTag();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeAddressScreen(
                        addressId: "", length: value.dataList.length),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                    color: greyColor,
                    onPressed: () {},
                  ),
                  Text('Add_Address'.tr(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.boldStyle(
                          AppFontSize.font_18, blackColor)),
                ],
              )),
          if (value.dataList.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              // child: Center(
              //     child: Image.asset(
              //   AssetImage.locationNotFound,
              //   height: 140,
              // )),
            )
        ]));
  }

  int _groupValue = -1;
  bool isValue = false;

  buildAddressCard(int index, DataModal? data) {
    if (data?.isDefault == "1" && !isValue) {
      _groupValue = index;
      isValue = true;
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Radio(
                  value: index,
                  groupValue: _groupValue,
                  activeColor:blackColor,
                  onChanged: (value) {
                    setState(() {
                      _groupValue = index;
                      context
                          .read<AddressProvider>()
                          .updateDefaultAddressApi(data?.id.toString());
                    });
                  },
                ),
              ),
              Expanded(
                flex: 7,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _groupValue = index;
                      context
                          .read<AddressProvider>()
                          .updateDefaultAddressApi(data?.id.toString());
                    });
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            data?.tag?.toLowerCase() != "other"
                                ? capitalize(data?.tag ?? "")
                                : capitalize(data?.otherTag ?? ""),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: AppTextStyles.boldStyle(
                                AppFontSize.font_16, blackColor)),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  "${(data?.houseNumber ?? "").isNotEmpty ? "${data?.houseNumber}, " : ""}"
                                  "${(data?.appartmentOffice ?? "").isNotEmpty ? "${data?.appartmentOffice}, " : ""}"
                                  "${(data?.address ?? "").isNotEmpty ? "${data?.address}, " : ""}",
                                  // overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.regularStyle(
                                      AppFontSize.font_14,
                                      blackColor)),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _dialog("Are you sure you want to edit?", "edit",
                                data, index);
                          },
                          child: const Icon(Icons.edit,
                              color: blackColor)),
                      if (data?.isDefault == "0") const SizedBox(width: 12),
                      data?.isDefault == "0"
                          ? GestureDetector(
                              onTap: () {
                                _dialog("Are you sure you want to delete?",
                                    "delete", data, index);
                              },
                              child: const Icon(Icons.delete,
                                  color: blackColor))
                          : const SizedBox(),
                    ]),
              ),
              //const SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: blackColor),
        ],
      ),
    );
  }

  _dialog(String message, String type, DataModal? data, int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          //title: Text('Logout'),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (type == 'edit') {
                    context.read<AddressProvider>().setTagData(data!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeAddressScreen(
                            addressId: data.id.toString(), length: 0),
                      ),
                    );
                  } else {
                    context
                        .read<AddressProvider>()
                        .deleteAddressApi(data?.id.toString(), index);
                  }
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'))
          ],
        ),
      ),
    );
  }
}
