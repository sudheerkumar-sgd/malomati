// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';

class ItemThankyouMonth extends StatelessWidget {
  final Map data;
  ValueNotifier<int> selectedMonth;

  ItemThankyouMonth(
      {required this.data, required this.selectedMonth, super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedMonth,
        builder: (context, value, widget) {
          return InkWell(
            onTap: () {
              selectedMonth.value = data['index'];
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp10,
                  vertical: context.resources.dimen.dp15),
              decoration: BackgroundBoxDecoration(
                      boxColor: value == data['index']
                          ? context.resources.color.viewBgColor
                          : context.resources.color.colorWhite,
                      radious: context.resources.dimen.dp15)
                  .roundedCornerBox,
              child: Column(
                children: [
                  Text(
                    '${data['month']}\n${data['year']}',
                    textAlign: TextAlign.center,
                    style: context.textFontWeight400
                        .onFontSize(context.resources.dimen.dp15)
                        .onFontFamily(fontFamily: fontFamilyEN)
                        .onColor(value == data['index']
                            ? context.resources.color.colorWhite
                            : context
                                .resources.color.bottomSheetIconUnSelected),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
