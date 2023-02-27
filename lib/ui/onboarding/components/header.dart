import 'package:cycle_lock/utils/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import '../../../utils/strings.dart';

class OnBoardingHeader extends StatelessWidget {
  final bool isSkip;
  final String heading;
  final bool isBackNav;
  final void Function()? onSkip;

  const OnBoardingHeader(
      {Key? key,
      this.isSkip = false,
      required this.heading,
      this.isBackNav = true,
      this.onSkip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: double.infinity,
      height: 250,
      color: lightGreyColor,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          isBackNav
              ? Padding(
                  padding: const EdgeInsets.only(left: 12, top: 30),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          size: 28, color: Colors.white)),
                )
              : const SizedBox(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                      width: 280,
                      height: double.infinity,
                      child: SvgPicture.asset(
                        icHeaderBike,
                        fit: BoxFit.contain,
                      ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(heading,
                    style: const TextStyle(
                        fontSize: ts28,
                        color: Colors.white,
                        fontWeight: FontWeight.w500))),
          ),
          isSkip
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onSkip,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "skip".tr(),
                          style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: Colors.white,
                                    offset: Offset(0, -5))
                              ],
                              color: Colors.transparent,
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                              decorationColor: Colors.white,
                              //color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationThickness: 3
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
