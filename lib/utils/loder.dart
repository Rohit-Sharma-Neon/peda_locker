import 'package:cycle_lock/utils/images.dart';
import 'package:flutter/material.dart';

class Loader{
  static load() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Center(
          child: Image.asset(
            aLoader,
            height: 80,
            width: 80,
          )),
    );
  }

}
