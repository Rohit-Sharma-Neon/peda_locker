import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/how_it_works_response.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/custom_video_player.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';
import '../../utils/colors.dart';
import '../../utils/sizes.dart';

class HowItWorksScreen extends StatefulWidget {
  const HowItWorksScreen({Key? key}) : super(key: key);

  @override
  State<HowItWorksScreen> createState() => _HowItWorksScreenState();
}

class _HowItWorksScreenState extends State<HowItWorksScreen> {
  Apis apis = Apis();
  bool isLoading = true;
  List<Data>? data;

  bool isPlay = false;
  @override
  void initState() {
    super.initState();
    termsApi();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(title: "HowItWorks".tr()),
      body: isLoading
          ?  Center(
              child: Loader.load(),
            )
          : animatedColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Column(
                    children: List.generate(
                      data?.length ?? 0,
                      (position) {
                        return buildCard(position);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
    );
  }

  buildCard(position) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: greyBgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data?[position].name ?? "",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ts25)),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (data?[position].isShow ?? false) {
                      data?[position].isShow = false;
                    } else {
                      data?[position].isShow = true;
                    }
                  });
                },
                child: Icon(
                  data?[position].isShow ?? false
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  size: 30,
                  color: lightGreyColor,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          data?[position].isShow ?? false
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          isPlay = true;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          isPlay ? CustomVideoPlayer(url: "${data?[position].imageUrl??""}/${data?[position].video??""}",) : Image.network(
                           "${data?[position].imageUrl??""}/${data?[position].image??""}" ,
                            height: 250,
                            fit: BoxFit.fill,
                          ),
                          isPlay ? const SizedBox() : Image.asset(
                            "assets/images/play.png",
                            height: 50,
                            fit: BoxFit.fill,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data?[position].description ?? "",
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: ts18, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  termsApi() async {
    await apis.howItWorksApi().then((value) {
      if (value?.status ?? false) {
        setState(() {
          data = value!.data;
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
