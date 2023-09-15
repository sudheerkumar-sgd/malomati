import 'package:flutter/material.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';

import '../../../core/constants/constants.dart';

class TextInputWidget {
  TextStyle? textStyle;
  String? hintText;
  String errorMessage;
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
  final String? suffixIconPath;
  final Function? suffixIconClick;
  TextInputWidget({
    this.textStyle,
    this.hintText,
    this.errorMessage = '',
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
    this.suffixIconPath,
    this.suffixIconClick,
  });
  Widget get textInputFiled => getTextField();

  Widget getTextField() {
    return SizedBox(
      width: width,
      //height: height,
      child: TextFormField(
        controller: textController,
        keyboardType: textInputType,
        textInputAction: textInputAction ?? TextInputAction.next,
        obscureText:
            textInputType == TextInputType.visiblePassword ? true : false,
        maxLines: maxLines,
        validator: (value) {
          if (errorMessage.isNotEmpty && (value == null || value.isEmpty)) {
            return errorMessage.isNotEmpty ? errorMessage : null;
          }
          return null;
        },
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: enabledBorderColor ?? const Color(0x00000000),
                  width: width ?? 1),
              borderRadius: BorderRadius.all(
                Radius.circular(boarderRadius ?? 4),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: enabledBorderColor ?? const Color(0x00000000),
                  width: width ?? 1),
              borderRadius: BorderRadius.all(
                Radius.circular(boarderRadius ?? 4),
              ),
            ),
            suffixIconConstraints:
                const BoxConstraints(maxHeight: 16, minHeight: 16),
            suffixIcon: (suffixIconPath ?? '').isNotEmpty
                ? InkWell(
                    onTap: () {
                      suffixIconClick!();
                    },
                    child: Padding(
                      padding: isLocalEn
                          ? const EdgeInsets.only(right: 15.0)
                          : const EdgeInsets.only(left: 15.0),
                      child: ImageWidget(
                        width: 16,
                        height: 16,
                        path: suffixIconPath ?? '',
                      ).loadImage,
                    ),
                  )
                : null),
        style: textStyle,
      ),
    );
  }
}
