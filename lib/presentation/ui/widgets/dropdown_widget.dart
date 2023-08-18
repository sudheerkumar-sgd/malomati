// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

const double defaultHeight = 27;

class DropDownWidget<T> extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final List<T> list;
  T? selectedValue;
  Function(T?)? callback;
  final ValueNotifier<bool> _onItemChanged = ValueNotifier(false);
  DropDownWidget(
      {required this.list,
      this.height = defaultHeight,
      this.isEnabled = false,
      this.labelText = '',
      this.hintText = '',
      this.textController,
      this.suffixIconPath,
      this.selectedValue,
      this.callback,
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
              bottom: context.resources.dimen.dp5),
          decoration: BackgroundBoxDecoration(
                  boxColor: context.resources.color.colorWhite,
                  radious: context.resources.dimen.dp10)
              .roundedCornerBox,
          child: ValueListenableBuilder(
              valueListenable: _onItemChanged,
              builder: (context, value, widget) {
                return DropdownButton<T>(
                  padding: EdgeInsets.symmetric(
                      vertical: context.resources.dimen.dp2),
                  isExpanded: true,
                  isDense: true,
                  hint: Text(
                    hintText,
                    style: context.textFontWeight400
                        .onFontSize(context.resources.dimen.dp12)
                        .onColor(context.resources.color.colorD6D6D6),
                  ),
                  value: selectedValue,
                  icon: ImageWidget(
                          path: DrawableAssets.icChevronDown,
                          backgroundTint: context.resources.color.viewBgColor)
                      .loadImage,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.dimen.dp12),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (T? value) {
                    _onItemChanged.value = !_onItemChanged.value;
                    selectedValue = value;
                    callback!(value);
                  },
                  items: list.map<DropdownMenuItem<T>>((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                );
              }),
        ),
      ],
    );
  }
}
