import 'package:flutter/material.dart';

class CustomBgWidgets {
  Widget roundedCornerWidget(
      Widget widget, BoxDecoration boxDecoration, double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: boxDecoration,
      child: widget,
    );
  }
}
