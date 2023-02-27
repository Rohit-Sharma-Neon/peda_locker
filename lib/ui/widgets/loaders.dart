import 'package:cycle_lock/utils/loder.dart';
import 'package:flutter/material.dart';

class Loaders {
  loader(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context){
          return Loader.load();
        }
    );
  }
}