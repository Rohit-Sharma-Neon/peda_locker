import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/sizes.dart';

Widget headingMedium(String title){
  return Text(title,style: const TextStyle(fontSize: ts24,fontWeight: FontWeight.w700,color: textColor));
}