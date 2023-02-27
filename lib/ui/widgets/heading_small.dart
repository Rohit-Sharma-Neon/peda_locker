import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/sizes.dart';

Widget headingSmall(String title){
  return Text(title,style: const TextStyle(fontSize: ts20,fontWeight: FontWeight.w500,color: textColor));
}