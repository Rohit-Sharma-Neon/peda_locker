import 'dart:io';

import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/preference_response.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/ui/widgets/primary_button.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import 'components/header.dart';

class PreferenceScreen extends StatefulWidget {
  bool? isRegistring;

  PreferenceScreen({Key? key, this.isRegistring = false}) : super(key: key);

  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  List<String> images = [
    illSupplements,
    illBikes,
    illParts,
  ];

  bool isPreferenceLoading = true;
  final Apis _apis = Apis();
  PreferenceResponse data = PreferenceResponse();

  @override
  void initState() {
    super.initState();
    getPreferencesApi();
    setPreferences();
  }

  String _selectedPrefences = "";
  String _selectedPrefencesNames = "";
  List<String> _preferenceNames = [];

  setPreferences() {
    _selectedPrefencesNames =
        spPreferences.getString(SpUtil.PREFERENCES_ID) ?? "";
    _preferenceNames = _selectedPrefencesNames.split(",");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 1),
        child: PrimaryButton(
          title: const Text("Save", style: TextStyle(fontSize: 26)),
          onPressed: () {
            data.data?.forEach((element) {
              if (element.isChecked ?? false) {
                if (_selectedPrefences.isEmpty) {
                  _selectedPrefences = element.id.toString();
                  _selectedPrefencesNames = element.name.toString();
                } else {
                  _selectedPrefences += "," + element.id.toString();
                  _selectedPrefencesNames += ", " + element.name.toString();
                }
              }
            });
            setPreferenceApi(context);
            if (widget.isRegistring ?? false) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardScreen()),
                  (route) => false);
            } else {
              Loaders().loader(context);
              Navigator.pop(context, "update");
            }
          },
        ),
      ),
      body: Column(
        children: [
          OnBoardingHeader(
              heading: "selectPreferences".tr(),
              isSkip: widget.isRegistring ?? false,
              onSkip: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashBoardScreen()),
                    (route) => false);
              }),
          Expanded(
            child: isPreferenceLoading
                ? Loader.load()
                : ListView.builder(
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    itemCount: data.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          InkWell(
                            onTap: () {
                              // spPreferences.setString(SpUtil.PREFERENCES_ID, data.data?[index].id.toString()??"");
                              // if (widget.isRegistring??false) {
                              //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const DashBoardScreen()),(route) => false);
                              // }else{
                              //   Navigator.pop(context);
                              // }
                              setState(() {
                                data.data?[index].isChecked =
                                    !(data.data?[index].isChecked ?? false);
                              });
                            },
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              width: double.infinity,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  (data.data?[index].imageUrl ?? "") +
                                      "/" +
                                      (data.data?[index].image ?? ""),
                                  colorBlendMode: BlendMode.darken,
                                  color: Colors.black.withOpacity(0.2),
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                        child: /*Loader.load())*/ SizedBox());
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // InkWell(
                          // onTap: (){
                          //   spPreferences.setString(SpUtil.PREFERENCES_ID, data.data?[index].id.toString()??"");
                          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const DashBoardScreen()),(route) => false);
                          // },
                          // child: Container(
                          //     alignment: Alignment.bottomLeft,margin: EdgeInsets.symmetric(vertical: 12),width: double.infinity,height: 200,decoration: BoxDecoration(
                          // image: DecorationImage(image: NetworkImage((data.data?[index].imageUrl??"")+"/"+(data.data?[index].image??"")),fit: BoxFit.fill,colorFilter:
                          // ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.srcOver),),
                          // )),
                          // ),
                          data.data?[index].isChecked == true
                              ? const Positioned(
                                  top: 1,
                                  right: 1,
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 34, horizontal: 18),
                                      child: Icon(
                                        Icons.check_box,
                                        color: Colors.white,
                                        size: 40,
                                      )),
                                )
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 34, horizontal: 18),
                            child: Text(
                              data.data?[index].name ?? "",
                              style: const TextStyle(
                                  fontSize: ts20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    }),
          )
        ],
      ),
    );
  }

  getPreferencesApi() async {
    setState(() {
      isPreferenceLoading = true;
    });
    await _apis.preferenceApi().then((value) {
      if (value?.status ?? false) {
        data = value!;
        data.data?.forEach((element) {
          _preferenceNames.forEach((selected) {
            if (selected == (element.id ?? 0).toString()) {
              element.isChecked = true;
            }
          });
        });
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
    setState(() {
      isPreferenceLoading = false;
    });
  }

  setPreferenceApi(BuildContext context) {
    Loaders().loader(context);
    _apis.addPreference(_selectedPrefences).then((value) {
      if (value?.status ?? false) {
        print("Preference Ids -->" + _selectedPrefences);
        spPreferences.remove(SpUtil.PREFERENCES_ID);
        spPreferences.remove(SpUtil.PREFERENCES_NAMES);
        spPreferences.setString(SpUtil.PREFERENCES_ID, _selectedPrefences);
        spPreferences.setString(
            SpUtil.PREFERENCES_NAMES, _selectedPrefencesNames);
        Dialogs().confirmationDialog(context, onContinue: () {
          Navigator.pop(context, "update");
          Navigator.pop(context, "update");
        }, disableCancel: true, message: value?.message ?? "");
      } else {
        Dialogs().confirmationDialog(context,
            onContinue: () {},
            disableCancel: true,
            message: value?.message ?? "");
        Navigator.pop(context);
      }
    });
  }
}
