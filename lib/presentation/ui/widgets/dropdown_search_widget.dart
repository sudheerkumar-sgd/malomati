// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

const double defaultHeight = 27;

class DropDownSearchWidget<T> extends StatelessWidget {
  final double height;
  final bool isEnabled;
  final String labelText;
  final String hintText;
  final String errorMessage;
  final String? suffixIconPath;
  final String fontFamily;
  final List<T> list;
  T? selectedValue;
  Function(T?)? callback;
  final Color? fillColor;
  DropDownSearchWidget(
      {required this.list,
      this.height = defaultHeight,
      this.isEnabled = true,
      this.labelText = '',
      this.hintText = '',
      this.errorMessage = '',
      this.suffixIconPath,
      this.fontFamily = '',
      this.fillColor,
      this.selectedValue,
      this.callback,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text(
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
          SizedBox(
            height: context.resources.dimen.dp10,
          ),
        ],
        SizedBox(
          height: context.resources.dimen.dp40,
          child: DropdownSearch<T>(
            items: list,
            popupProps: PopupProps.menu(
              constraints: list.isNotEmpty
                  ? BoxConstraints(maxHeight: (30.0 * list.length) + 45)
                  : const BoxConstraints(maxHeight: 50),
              showSearchBox: list.isNotEmpty,
              searchFieldProps: TextFieldProps(
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp12),
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: context.resources.dimen.dp10,
                        horizontal: context.resources.dimen.dp10),
                    hintText: 'Search',
                    hintStyle: context.textFontWeight400
                        .onFontSize(context.resources.fontSize.dp12)
                        .onFontFamily(
                            fontFamily: context.resources.isLocalEn
                                ? fontFamilyEN
                                : fontFamilyAR)
                        .onColor(context.resources.color.colorD6D6D6),
                    suffixIconConstraints:
                        BoxConstraints(maxHeight: height, minHeight: height),
                    fillColor: fillColor ?? context.resources.color.colorWhite,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimen.dp10),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(context.resources.dimen.dp10),
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  )),
              itemBuilder: (context, item, isSelected) {
                return Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp15,
                      vertical: context.resources.dimen.dp5),
                  child: Text(
                    overflow: TextOverflow.clip,
                    item.toString(),
                    style: context.textFontWeight400,
                  ),
                );
              },
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
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
                  hintStyle: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp12)
                      .onFontFamily(
                          fontFamily: context.resources.isLocalEn
                              ? fontFamilyEN
                              : fontFamilyAR)
                      .onColor(context.resources.color.colorD6D6D6),
                  hintText: hintText),
            ),
            onChanged: (value) {
              callback?.call(value);
            },
          ),
        ),
      ],
    );
  }
}
