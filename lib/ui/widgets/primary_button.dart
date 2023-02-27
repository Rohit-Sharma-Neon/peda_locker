import 'package:cycle_lock/utils/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {

  final Function()? onPressed;
  final Widget title;
  final Color color;
  const PrimaryButton({Key? key,required this.onPressed, required this.title, this.color = buttonColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(onPressed: onPressed, child: title,
        style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          primary: color,
      ),),
    );
  }
}
