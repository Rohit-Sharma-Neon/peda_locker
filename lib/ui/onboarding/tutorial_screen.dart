import 'package:carousel_slider/carousel_slider.dart';
import 'package:cycle_lock/main.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/onboarding/login_screen.dart';
import 'package:cycle_lock/ui/onboarding/register_screen.dart';
import 'package:cycle_lock/ui/widgets/animated_column.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';

import '../../utils/images.dart';
import '../../utils/sizes.dart';
class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}
class _TutorialScreenState extends State<TutorialScreen> {
  int _current = 0;
  List bannerList = [splash, splash, splash, splash];

  late Map<DateTime, String> _events;

  // List<Event> _getEventsForDay(DateTime day) {
  //   return events[day] ?? [];
  // };
  late Map<DateTime, List<String>> _eventss;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _events = {
      // DateTime(_selectedDay.year,_selectedDay.month,2)
      DateTime(_selectedDay.year, _selectedDay.month, 22): "1",
      DateTime(_selectedDay.year, _selectedDay.month, 25): "4",
      DateTime(_selectedDay.year, _selectedDay.month, 4): "2",
      DateTime(_selectedDay.year, _selectedDay.month, 11): "8",
      DateTime(_selectedDay.year, _selectedDay.month, 18): "6",
    };
    _eventss = {
      DateTime(_selectedDay.year, _selectedDay.month, 22): ["1"],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: primaryDark2, body: _buildBody());
  }

  _buildBody() {
    return SafeArea(
      child: animatedColumn(
        duration: 200,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 70, left: 40, right: 40),
            child: const Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: ts30),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
              child: Text("leaveTheHassle".tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: ts20))),
          const SizedBox(
            height: 60,
          ),
          _buildCarouselSlider(),
          Container(),
          const SizedBox(
            height: 40,
          ),
          _buildCarouselDot(),
          const SizedBox(
            height: 60,
          ),
          _buildLoginButton(),
          const SizedBox(
            height: 30,
          ),
          _buildRegisterButton(),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () async {
              await spPreferences.setBool(SpUtil.IS_GUEST, true);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardScreen()));
            },
            child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(40
                  ),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                      text: "skip".tr(),
                      style: const TextStyle(
                          decorationThickness: 1,
                          decoration: TextDecoration.underline,
                          color: buttonColor,
                          fontWeight: FontWeight.w700,
                          fontSize: ts20)
                    )),
                )),
          ),
        ],
      ),
    );
  }

  _buildCarouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
          autoPlay: true,
          height: 300,
          reverse: false,
          scrollDirection: Axis.horizontal,
          autoPlayCurve: Curves.ease,
          viewportFraction: 1.0,
          aspectRatio: 2.0,
          enlargeCenterPage: false,
          enableInfiniteScroll: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 4000),
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }),
      items: bannerList.map<Widget>((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                margin: const EdgeInsets.only(left: 15),
                width: double.infinity,
                child: SvgPicture.asset(
                  i,
                  fit: BoxFit.cover,
                  // color: Colors.white,
                ));
          },
        );
      }).toList(),
    );
  }

  _buildCarouselDot() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
            bannerList.length,
            (index) => Container(
                  margin: const EdgeInsets.only(right: 15),
                  width: _current == index ? 30 : 12,
                  height: _current == index ? 8 : 12,
                  decoration: _current == index
                      ? BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)))
                      : const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                )));
  }

  _buildLoginButton() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: Text(
            "Login".tr(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: ts20,
                fontWeight: FontWeight.w700),
          ),
          style: ElevatedButton.styleFrom(
            primary: primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(15),
          )),
    );
  }

  _buildRegisterButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()));
            },
            child: Text(
              "register".tr(),
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
              padding: const EdgeInsets.all(15),
            )),
      ),
    );
  }
}