import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/custom_bg_widgets.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';

class ItemDashboardLeaves extends StatelessWidget {
  const ItemDashboardLeaves({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomBgWidgets().roundedCornerWidget(
            padding: EdgeInsets.all(context.resources.dimen.dp10),
            widget: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  '25',
                  style: context.textFontWeight900
                      .onFontFamily(fontFamily: fontFamilyEN)
                      .onColor(context.resources.color.viewBgColor)
                      .onFontSize(context.resources.dimen.dp20),
                ),
                SizedBox(
                  height: context.resources.dimen.dp5,
                ),
                Text(
                  textAlign: TextAlign.center,
                  'days',
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
          'Balance Leave',
          textAlign: TextAlign.center,
          style: context.textFontWeight400
              .onColor(context.resources.color.textColor)
              .onFontSize(context.resources.dimen.dp12),
        ),
      ],
    );
  }
}
