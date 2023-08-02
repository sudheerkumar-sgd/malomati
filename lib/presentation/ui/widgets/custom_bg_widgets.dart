import 'package:flutter/material.dart';

class CustomBgWidgets {
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
}
