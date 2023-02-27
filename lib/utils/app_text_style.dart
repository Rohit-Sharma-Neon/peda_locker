import 'package:flutter/material.dart';


class AppFontWeight {
  static FontWeight thin = FontWeight.w100;
  static FontWeight altThin = FontWeight.w200;
  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight medium = FontWeight.w500;
  static FontWeight bold = FontWeight.w600;
  static FontWeight altBold = FontWeight.w700;
  static FontWeight extraBold = FontWeight.w800;
}

class AppFontSize {
  static const double font_8 = 8;
  static const double font_10 = 10;
  static const double font_11 = 11;
  static const double font_12 = 12;
  static const double font_13 = 13;
  static const double font_14 = 14;
  static const double font_15 = 15;
  static const double font_16 = 16;
  static const double font_17 = 17;
  static const double font_18 = 18;
  static const double font_20 = 20;
  static const double font_22 = 22;
  static const double font_24 = 24;
  static const double font_26 = 26;
  static const double font_28 = 28;
  static const double font_34 = 34;
  static const double font_36 = 36;
  static const double font_38 = 38;
  static const double font_60 = 60;
}


class AppTextStyles {

  static TextStyle extraThinStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.thin);
  }

  static TextStyle extraAltThinStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.altThin);
  }

  static TextStyle lightStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.light);
  }

  static TextStyle regularStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.regular);
  }

  static TextStyle mediumStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.medium);
  }

  static TextStyle boldStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.bold);
  }

  static TextStyle altBoldStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.altBold);
  }

  static TextStyle extraBoldStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.extraBold);
  }


  static TextStyle mediumDecorationStyle(decoration, double size, Color color) {
    return TextStyle(
        decoration: decoration,
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.medium);
  }

  static TextStyle regularDecorationStyle(decoration, double size, Color color) {
    return TextStyle(
        decoration: decoration,
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.regular);
  }

  static TextStyle boldDecorationStyle(decoration,double size, Color color) {
    return TextStyle(
        decoration: decoration,
        fontSize: size, color: color, fontFamily: "Proxima-Nova", fontWeight: AppFontWeight.bold);
  }



}