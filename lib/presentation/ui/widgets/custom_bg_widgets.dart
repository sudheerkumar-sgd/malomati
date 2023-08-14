import 'package:flutter/material.dart';

import '../../../res/drawables/background_box_decoration.dart';

class CustomBgWidgets {
  Widget? widget;
  double? height;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;
  Matrix4? transform;
  Color? boxColor;
  double? radious;
  double? boarderWidth;
  Color? boarderColor;
  Color? shadowColor;
  double? shadowBlurRadius;
  Offset? shadowOffset;
  CustomBgWidgets(
      {widget,
      boxDecoration,
      height,
      margin,
      padding,
      Matrix4? transform,
      this.boxColor,
      this.boarderColor,
      this.boarderWidth,
      this.radious,
      this.shadowColor,
      this.shadowBlurRadius,
      this.shadowOffset});
  Widget roundedCornerWidget({
    required Widget widget,
    required BoxDecoration boxDecoration,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Matrix4? transform,
  }) {
    return Container(
      transform: transform,
      margin: margin,
      padding: padding,
      width: double.infinity,
      height: height,
      decoration: boxDecoration,
      child: widget,
    );
  }

  Widget containerWidget() {
    return Container(
      transform: transform,
      margin: margin,
      padding: padding,
      width: double.infinity,
      height: height,
      decoration: BackgroundBoxDecoration(
              boxColor: boxColor,
              radious: radious,
              shadowColor: shadowColor,
              shadowBlurRadius: shadowBlurRadius)
          .roundedBoxWithShadow,
      child: widget,
    );
  }
}
