import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';

const double defaultHeight = 27;

class RightIconTextWidget extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final TextInputType? textInputType;
  final TextEditingController? textController;
  final String? suffixIconPath;
  const RightIconTextWidget(
      {this.height = defaultHeight,
      this.isEnabled = false,
      this.labelText = '',
      this.hintText = '',
      this.textController,
      this.suffixIconPath,
      this.textInputType,
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
            style: context.textFontWeight400
                .onFontSize(context.resources.dimen.dp12),
          ),
        ),
        SizedBox(
          height: context.resources.dimen.dp10,
        ),
        Container(
          padding: EdgeInsets.only(
            left: context.resources.dimen.dp10,
            top: context.resources.dimen.dp5,
            right: context.resources.dimen.dp15,
            bottom: context.resources.dimen.dp5,
          ),
          decoration: BackgroundBoxDecoration(
                  boxColor: context.resources.color.colorWhite,
                  radious: context.resources.dimen.dp10)
              .roundedCornerBox,
          child: Align(
            alignment: Alignment.center,
            child: TextField(
              enabled: isEnabled,
              maxLines: null,
              keyboardType: textInputType,
              controller: textController,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: context.resources.dimen.dp5),
                  constraints:
                      BoxConstraints(maxHeight: height, minHeight: height),
                  hintText: hintText,
                  hintStyle: context.textFontWeight400
                      .onFontSize(context.resources.dimen.dp12)
                      .onColor(context.resources.color.colorD6D6D6),
                  suffixIconConstraints:
                      BoxConstraints(maxHeight: height, minHeight: height),
                  suffixIcon: (suffixIconPath ?? '').isNotEmpty
                      ? ImageWidget(
                              path: suffixIconPath ?? '',
                              backgroundTint:
                                  context.resources.color.viewBgColor)
                          .loadImage
                      : null,
                  fillColor: context.resources.color.colorWhite,
                  border: InputBorder.none),
              style: context.textFontWeight400
                  .onFontSize(context.resources.dimen.dp12),
            ),
          ),
        ),
      ],
    );
  }
}