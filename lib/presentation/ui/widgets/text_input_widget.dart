import 'package:flutter/material.dart';

class TextInputWidget {
  TextStyle? textStyle;
  String? hintText;
  double? width;
  double? height;
  int? maxLines;
  TextEditingController? textController;
  Color? fillColor;
  Color? focusedBorderColor;
  Color? enabledBorderColor;
  double? boarderWidth;
  double? boarderRadius;
  String? regExp;
  TextInputType? textInputType;
  TextInputAction? textInputAction;
  TextInputWidget({
    this.textStyle,
    this.hintText,
    this.width,
    this.height,
    this.maxLines = 1,
    this.textController,
    this.fillColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.boarderWidth,
    this.boarderRadius,
    this.regExp,
    this.textInputType,
    this.textInputAction,
  });
  Widget get textInputFiled => getTextField();

  Widget getTextField() {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        controller: textController,
        keyboardType: textInputType,
        textInputAction: textInputAction ?? TextInputAction.next,
        obscureText:
            textInputType == TextInputType.visiblePassword ? true : false,
        maxLines: maxLines,
        decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            fillColor: fillColor,
            filled: fillColor == null ? null : true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: focusedBorderColor ?? const Color(0x00000000),
                  width: width ?? 1),
              borderRadius: BorderRadius.all(
                Radius.circular(boarderRadius ?? 4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: enabledBorderColor ?? const Color(0x00000000),
                  width: width ?? 1),
              borderRadius: BorderRadius.all(
                Radius.circular(boarderRadius ?? 4),
              ),
            ),
            errorText: (regExp?.isEmpty == true ||
                    RegExp(regExp ?? '').hasMatch(textController?.text ?? ''))
                ? null
                : 'Please enter Password'),
        style: textStyle,
      ),
    );
  }
}
