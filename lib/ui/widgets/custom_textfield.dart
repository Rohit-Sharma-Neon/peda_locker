import 'package:cycle_lock/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextField extends StatelessWidget {
  final bool isRegister;
  final Icon? icon;
  final String iconAsset;
  final Color? hintColors;
  final String suffixIconAsset;
  final String hintText;
  final String? Function(String? val)? validator;
  final Function(String text)? onChanged;
  final bool isPassword;
  final bool isEmail;
  final bool readOnly;
  final int minLines;
  final double? fontSizes;
  final double? hintSizes;
  final int maxLength;
  final EdgeInsetsGeometry padding;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final capitalization;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final Color? cursorColor;
  final ValueChanged<String>? onFieldSubmitted;

  const CustomTextField({
    this.icon,
    this.hintColors,
    this.hintSizes,
    this.fontSizes,
    this.isRegister = false,
    this.capitalization = TextCapitalization.none,
    required this.hintText,
    this.maxLength = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
    this.isEmail = false,
    this.validator,
    this.onChanged,
    this.isPassword = false,
    this.keyboardType,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.readOnly = false,
    // this.initialValue,
    // this.onTap,
    // this.inputFormatters,
    this.iconAsset = '',
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.suffixIconAsset = '',
    this.style,
    this.cursorColor,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        key: key,
        maxLength: maxLength,
        textInputAction: textInputAction,
        autofocus: false,
        textCapitalization: capitalization,
        readOnly: readOnly,
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        cursorColor: cursorColor,
        style: style ?? TextStyle(fontSize: fontSizes ?? 24.0),
        inputFormatters: inputFormatters,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          isDense: true,
          counterText: '',
          // labelText: '',
          prefixIcon: this.iconAsset.isNotEmpty
              ? Transform.scale(
                  scale: 1.3,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      iconAsset,
                      color: iconColor,
                    ),
                  ),
                )
              : prefixIcon,
          suffixIcon: this.suffixIconAsset.isNotEmpty
              ? Transform.scale(
                  scale: 1.3,
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      suffixIconAsset,
                      color: buttonColor,
                    ),
                  ),
                )
              : suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: hintColors != null ? hintColors : hintColor,
              fontSize: hintSizes??24),
          errorMaxLines: 1,
          errorStyle: TextStyle(fontSize: isRegister ? 14 : 0),
          // contentPadding: EdgeInsets.only(left: 10),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: lightGreyColor, width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(color: lightGreyColor, width: 1),
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: const BorderRadius.all(
          //     const Radius.circular(5),
          //   ),
          //   // borderSide: BorderSide(color: darkBlueColor, width: 1),
          // ),

          // filled: true,
          // fillColor: fillColor,
//          focusedErrorBorder: OutlineInputBorder(
//            borderRadius: const BorderRadius.all(
//              const Radius.circular(5),
//            ),
//            borderSide: BorderSide(
//              color: kPrimaryColor,
//              width: 0.5,
//            ),
//          ),
//          errorBorder: OutlineInputBorder(
//            borderRadius: const BorderRadius.all(
//              const Radius.circular(5),
//            ),
//            borderSide: BorderSide(
//              color: kPrimaryColor,
//              width: 0.5,
//            ),
//          ),
//          errorStyle:
//              TextStyle(color: kPrimaryColor, decorationColor: kPrimaryColor),
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        autovalidateMode: isRegister
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        // onSaved: onSaved,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autocorrect: false,
      ),
    );
  }
}
