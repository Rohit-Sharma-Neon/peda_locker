import 'package:cycle_lock/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../utils/sizes.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool isBack;
  const BaseAppBar({Key? key, required this.title, this.actions, this.isBack = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isBack ? InkWell(onTap: (){Navigator.pop(context);},child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.arrow_back_ios_rounded,size: 30,),
      )):const SizedBox(),
      backgroundColor: lightGreyColor,
      centerTitle: title=="Complete Profile" ? true : false,
      title: Text(title,style: const TextStyle(fontSize: ts26,fontWeight: FontWeight.w500)),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}
