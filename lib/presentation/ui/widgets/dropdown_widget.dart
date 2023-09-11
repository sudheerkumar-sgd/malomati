// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

const double defaultHeight = 27;

class DropDownWidget<T> extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final TextEditingController? textController;
  final String? suffixIconPath;
  final String fontFamily;
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
      this.errorMessage = '',
      this.textController,
      this.suffixIconPath,
      this.fontFamily = '',
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
        ValueListenableBuilder(
            valueListenable: _onItemChanged,
            builder: (context, onItemChanged, widget) {
              return DropdownButtonFormField<T>(
                padding:
                    EdgeInsets.symmetric(vertical: context.resources.dimen.dp2),
                isExpanded: true,
                isDense: true,
                decoration: InputDecoration(
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                      vertical: context.resources.dimen.dp5,
                      horizontal: context.resources.dimen.dp10),
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
                hint: Text(
                  hintText,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp12)
                      .onFontFamily(
                          fontFamily: context.resources.isLocalEn
                              ? fontFamilyEN
                              : fontFamilyAR)
                      .onColor(context.resources.color.colorD6D6D6),
                ),
                validator: (value) {
                  if (value == null || value.toString().isEmpty) {
                    return errorMessage.isNotEmpty ? errorMessage : null;
                  }
                  return null;
                },
                value: selectedValue,
                icon: Padding(
                  padding: context.resources.isLocalEn
                      ? const EdgeInsets.only(right: 10.0)
                      : const EdgeInsets.only(left: 10.0),
                  child: ImageWidget(
                          path: DrawableAssets.icChevronDown,
                          backgroundTint: context.resources.color.viewBgColor)
                      .loadImage,
                ),
                style: context.textFontWeight400
                    .onFontFamily(
                        fontFamily: fontFamily.isNotEmpty
                            ? fontFamily
                            : context.resources.isLocalEn
                                ? fontFamilyEN
                                : fontFamilyAR)
                    .onFontSize(context.resources.fontSize.dp12),
                onChanged: (T? value) {
                  _onItemChanged.value = !_onItemChanged.value;
                  selectedValue = value;
                  callback!(value);
                },
                items: list.map<DropdownMenuItem<T>>((T value) {
                  return DropdownMenuItem<T>(
                    value: value,
                    child: Text(
                      overflow: TextOverflow.clip,
                      value.toString(),
                      style: context.textFontWeight400.onFontFamily(
                          fontFamily: fontFamily.isNotEmpty
                              ? fontFamily
                              : context.resources.isLocalEn
                                  ? fontFamilyEN
                                  : fontFamilyAR),
                    ),
                  );
                }).toList(),
              );
            }),
      ],
    );
  }
}
