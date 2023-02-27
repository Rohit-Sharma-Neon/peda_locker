import 'package:flutter/material.dart';

Widget richText(text, {TextStyle? style, textAlign, maxLines, overflow, softWrap}) {
  return RichText(
      textAlign: textAlign ?? TextAlign.center,
      maxLines: maxLines,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(
          text: text,
          style: style ?? const TextStyle(
              color:  Colors.white,
              fontWeight:  FontWeight.w500,
              fontSize: 16)));
}
