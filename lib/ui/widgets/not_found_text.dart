import 'package:cycle_lock/utils/colors.dart';
import 'package:flutter/material.dart';

Widget notFound(String title){
  return
    Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 48,vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                textAlign: TextAlign.center,
               // textScaleFactor: tsf,
                text: TextSpan(
                  text: title,
                  style: const TextStyle(
                    height: 1.2,
                    color: buttonColor,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ) /*Text(title,
            style: const TextStyle(
          color: buttonColor,
          fontWeight: FontWeight.w800,
        ),textAlign: TextAlign.center),*/
      ),
    );
}