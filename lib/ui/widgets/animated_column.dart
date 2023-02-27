import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

Widget animatedColumn({int duration = 100,required List<Widget> children,CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center, EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 0)}){
  return SingleChildScrollView(
    child: Padding(
      padding: padding,
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 100),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 0.0,
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: children,
          ),
        ),
      ),
    ),
  );
}