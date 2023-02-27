
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import 'app_text_style.dart';
import 'colors.dart';

class CustomRoundTextField extends StatelessWidget {
  final Icon? icon;
  final String? iconAsset;
  final String? hintText;
  final String? initialValue;

  String? Function(String? val)? validator;
  //final Function()? ;
  String? Function(String? val)? onSaved;
  //final Function()? onSaved,
  final Function(String text)? onChanged;
  final bool? isPassword;
  final bool? isEmail;
  final bool? enable;
  final bool? readOnly;
  final int? minLines;
  final int? maxLength;
  final double? hintSize;
  final double? textSize;
  final EdgeInsetsGeometry? padding;
  final int? maxLines;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? hintColor;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  bool? autofocus;
  TextCapitalization? textCapitalization;


  CustomRoundTextField({
    this.icon,
    this.hintText,
    this.maxLength,
    this.fillColor,
    this.hintColor = blackColor70,
    this.padding : const EdgeInsets.fromLTRB(0, 0, 0, 15),
    this.isEmail : false,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.isPassword : false,
    this.keyboardType,
    this.controller,
    this.enable,
    this.minLines : 1,
    this.maxLines : 1,
    this.focusNode,
    this.readOnly : false,
    this.initialValue,
    this.onTap,
    this.inputFormatters,
    this.iconAsset : "",
    this.suffixIcon, IconButton,
    this.prefixIcon,
    this.hintSize  = 16,
    this.textSize  = 16,
    this.autofocus  = false,
    this.textCapitalization  = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: TextFormField(
        textCapitalization: textCapitalization!,
        style: AppTextStyles.mediumStyle(textSize!, blackColor),
        maxLength: maxLength,
        autofocus: autofocus!,
        readOnly: readOnly!,
        controller: controller,
        enabled: enable,
        minLines: minLines,
        maxLines: maxLines,
        focusNode: focusNode,
        initialValue: initialValue,
        onTap: onTap,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          suffixIconConstraints: const BoxConstraints(
              minHeight: 20,
              minWidth: 20
          ),
          counterText: "",
          // labelText: "",
          prefixIcon: iconAsset!.isNotEmpty
              ? Transform.scale(
                  scale: 0.6,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      iconAsset!,
                      color: Colors.black,
                    ),
                  ),
                )
              : icon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: AppTextStyles.regularStyle(
              hintSize!, hintColor!),
          errorMaxLines: 4,
          contentPadding: const EdgeInsets.only(left: 2,top: 10.0,bottom: 10),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: photosBgColor,width: 0.5),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: photosBgColor,width: 0.5),
          ),
          filled: true,
          fillColor: fillColor,
         focusedErrorBorder: const OutlineInputBorder(
           borderRadius: BorderRadius.all(
             Radius.circular(10),
           ),
           borderSide: BorderSide(
             color: borderColor,
             width: 2,
           ),
         ),
         errorBorder: const OutlineInputBorder(
           borderRadius: BorderRadius.all(
              Radius.circular(10),
           ),
           borderSide: BorderSide(
             color: borderColor,
             width: 2,
           ),
         ),
         errorStyle:
             const TextStyle(color:borderColor, decorationColor: borderColor),
        ),
        obscureText: isPassword! ? true : false,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autocorrect: false,
      ),
    );
  }
}
