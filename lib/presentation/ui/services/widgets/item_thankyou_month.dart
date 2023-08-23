// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';

class ItemThankyouMonth extends StatelessWidget {
  final String year;
  final String month;
  ValueNotifier<String> selectedMonth;

  ItemThankyouMonth(
      {required this.year,
      required this.month,
      required this.selectedMonth,
      super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedMonth,
        builder: (context, value, widget) {
          return InkWell(
            onTap: () {
              selectedMonth.value = month;
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp10,
                  vertical: context.resources.dimen.dp15),
              decoration: BackgroundBoxDecoration(
                      boxColor: value == month
                          ? context.resources.color.viewBgColor
                          : context.resources.color.colorWhite,
                      radious: context.resources.dimen.dp15)
                  .roundedCornerBox,
              child: Column(
                children: [
                  Text(
                    '$month\n$year',
                    textAlign: TextAlign.center,
                    style: context.textFontWeight400
                        .onFontSize(context.resources.dimen.dp15)
                        .onColor(value == month
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
