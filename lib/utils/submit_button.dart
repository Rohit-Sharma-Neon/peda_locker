
import 'package:flutter/material.dart';

import 'colors.dart';

class SubmitButton extends StatelessWidget {
  final String? value;
  final Color? color;
  final Color? textColor;
  final double? height;
  final TextStyle? textStyle;

  const SubmitButton(
      {Key? key,
      this.value,
      this.color,
      this.textColor,
      @required this.height,
      @required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
        height: height,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          // gradient: const LinearGradient(
          //   colors: <Color>[
          //     AppColors.submitGradiantColor2,
          //     AppColors.submitGradiantColor1
          //   ],
          //   //stops: [0.9, 0.0],
          //   begin: Alignment(-1.0, -3.0),
          //   end: Alignment(1.0, 3.0),
          //   //end: FractionalOffset.bottomLeft,
          // ),
          // boxShadow: const [
          //    BoxShadow(
          //     color: Colors.black54,
          //     offset:  Offset(0, 5),
          //     blurRadius: 6.0,
          //   ),
          // ],
        ),
        child: Text(value ?? "", style: textStyle!));
  }
}

class SmartButton extends StatelessWidget {
  final String? value;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final double radius;
  final double padding;
  final TextStyle? textStyle;

  const SmartButton(
      {Key? key,
      this.value,
      this.color,
      this.textColor,
      @required this.height,
      @required this.textStyle,
      this.width,
      this.radius = 10.0,
      this.padding = 6.0
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: width,
          padding: EdgeInsets.only(left: padding, right: padding),
          height: height,
          alignment: FractionalOffset.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Text(value ?? "", style: textStyle!),
        ),
      ],
    );
  }
}

class SmallButton extends StatelessWidget {
  final String? value;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final TextStyle? textStyle;

  const SmallButton(
      {Key? key,
      this.value,
      this.color,
      this.textColor,
      @required this.height,
      @required this.width,
      @required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(value ?? "", style: textStyle!),
    );
  }
}

class SmallIconButton extends StatelessWidget {
  final String? value;
  final String? icon;
  final Color? color;
  final Color? textColor;
  final double? height;
  final double? width;
  final TextStyle? textStyle;

  const SmallIconButton(
      {Key? key,
      this.value,
      this.icon,
      this.color,
      this.textColor,
      @required this.width,
      @required this.height,
      @required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        // gradient: const LinearGradient(
        //   colors: <Color>[
        //     AppColors.submitGradiantColor2,
        //     AppColors.submitGradiantColor1
        //   ],
        //   begin: Alignment(-1.0, -3.0),
        //   end: Alignment(1.0, 3.0),
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon!,
            height: 20,
            width: 20,
          ),
          const SizedBox(width: 5),
          Text(value ?? "", style: textStyle!),
        ],
      ),
    );
  }
}

class ButtonWithIcon extends StatelessWidget {
  final String? value;
  final String? icon;
  final Color? color;
  final Color? textColor;
  final double? height;
  final TextStyle? textStyle;

  const ButtonWithIcon(
      {Key? key,
      this.value,
      @required this.icon,
      this.color,
      this.textColor,
      @required this.height,
      @required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: <Color>[
            submitGradiantColor2,
            submitGradiantColor1
          ],
          //stops: [0.9, 0.0],
          begin: Alignment(-1.0, -3.0),
          end: Alignment(1.0, 3.0),
          //end: FractionalOffset.bottomLeft,
        ),
        // boxShadow: const [
        //    BoxShadow(
        //     color: Colors.black54,
        //     offset:  Offset(0, 5),
        //     blurRadius: 6.0,
        //   ),
        // ],SizedBox(height: 5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon!,
            height: 20,
            width: 20,
            color: whiteColor,
          ),
          const SizedBox(width: 10),
          Text(value ?? "", style: textStyle!),
        ],
      ),
    );
  }
}
