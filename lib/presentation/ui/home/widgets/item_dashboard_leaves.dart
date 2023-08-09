// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/custom_bg_widgets.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';

class ItemDashboardLeaves extends StatelessWidget {
  final balanceCount;
  final balancetype;
  String title;
  double padding = 10;
  ItemDashboardLeaves(
      {required this.balanceCount,
      required this.balancetype,
      this.title = '',
      this.padding = 10,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomBgWidgets().roundedCornerWidget(
            padding: EdgeInsets.all(padding),
            widget: Column(
              children: [
                Text(
                  '$balanceCount',
                  textAlign: TextAlign.center,
                  style: context.textFontWeight900
                      .onFontFamily(fontFamily: fontFamilyEN)
                      .onColor(context.resources.color.viewBgColor)
                      .onFontSize(context.resources.dimen.dp20),
                ),
                Text(
                  balancetype,
                  textAlign: TextAlign.center,
                  style: context.textFontWeight400
                      .onColor(context.resources.color.textColor)
                      .onFontSize(context.resources.dimen.dp10),
                ),
              ],
            ),
            boxDecoration: BackgroundBoxDecoration(
                    boxColor: context.resources.color.colorWhite)
                .circularBox),
        SizedBox(
          height: context.resources.dimen.dp10,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textFontWeight400
              .onColor(context.resources.color.textColor)
              .onFontSize(context.resources.dimen.dp12),
        ),
      ],
    );
  }
}
