import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';

const double defaultHeight = 27;

class RightIconTextWidget extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextInputType? textInputType;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final int? maxLines;
  final int? maxLength;
  final String fontFamily;
  final FocusNode? focusNode;
  const RightIconTextWidget(
      {this.height = defaultHeight,
      this.isEnabled = false,
      this.labelText = '',
      this.hintText = '',
      this.errorMessage = '',
      this.textController,
      this.suffixIconPath,
      this.textInputType,
      this.maxLines,
      this.maxLength,
      this.fontFamily = '',
      this.focusNode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: labelText.isNotEmpty,
          child: Text(
            labelText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textFontWeight400
                .onFontFamily(
                    fontFamily: context.resources.isLocalEn
                        ? fontFamilyEN
                        : fontFamilyAR)
                .onFontSize(context.resources.fontSize.dp12),
          ),
        ),
        SizedBox(
          height: context.resources.dimen.dp10,
        ),
        Align(
          alignment: Alignment.center,
          child: TextFormField(
            enabled: isEnabled,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: textInputType,
            controller: textController,
            textAlignVertical: TextAlignVertical.center,
            focusNode: focusNode,
            validator: (value) {
              if (errorMessage.isNotEmpty && (value == null || value.isEmpty)) {
                return errorMessage.isNotEmpty ? errorMessage : null;
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp10,
                  horizontal: context.resources.dimen.dp10),
              hintText: hintText,
              hintStyle: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12)
                  .onFontFamily(
                      fontFamily: context.resources.isLocalEn
                          ? fontFamilyEN
                          : fontFamilyAR)
                  .onColor(context.resources.color.colorD6D6D6),
              suffixIconConstraints:
                  BoxConstraints(maxHeight: height, minHeight: height),
              suffixIcon: (suffixIconPath ?? '').isNotEmpty
                  ? Padding(
                      padding: context.resources.isLocalEn
                          ? const EdgeInsets.only(right: 15.0)
                          : const EdgeInsets.only(left: 15.0),
                      child: ImageWidget(
                              path: suffixIconPath ?? '',
                              backgroundTint:
                                  context.resources.color.viewBgColor)
                          .loadImage,
                    )
                  : null,
              fillColor: context.resources.color.colorWhite,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(context.resources.dimen.dp10),
                ),
              ),
              errorStyle: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            style: fontFamily.isNotEmpty
                ? context.textFontWeight400
                    .onFontFamily(fontFamily: fontFamily)
                    .onFontSize(context.resources.fontSize.dp12)
                : context.textFontWeight400
                    .onFontSize(context.resources.fontSize.dp12),
          ),
        ),
      ],
    );
  }
}
