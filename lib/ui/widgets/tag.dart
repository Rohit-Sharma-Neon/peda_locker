import 'package:cycle_lock/utils/colors.dart';
import 'package:flutter/material.dart';

Widget tag(String title){
  return
    Expanded(
      child: Row(
        children: [
          Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 6),
          color: lightGreyColor,
          child: Text(title,style: const TextStyle(color: Colors.white,
              fontWeight: FontWeight.w300),textAlign: TextAlign.center),
  ),
        ],
      ),
    );
}

Widget tag2(String title){
  return
    Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 6),
          color: lightGreyColor,
          child: Text(title,style: const TextStyle(color: Colors.white,
              fontWeight: FontWeight.w300),textAlign: TextAlign.center),
        ),
      ],
    );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
