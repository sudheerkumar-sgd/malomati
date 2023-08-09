// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';

import '../../../res/drawables/background_box_decoration.dart';

class PageIndicator extends StatelessWidget {
  ValueNotifier eventBannerChange = ValueNotifier<int>(0);
  final double size;
  final int position;
  PageIndicator(
      {super.key,
      required this.size,
      required this.position,
      required this.eventBannerChange});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: eventBannerChange,
        builder: (context, value, widget) {
          return Container(
            margin: EdgeInsets.all(context.resources.dimen.dp5),
            width: context.resources.dimen.dp5,
            height: context.resources.dimen.dp5,
            decoration: BackgroundBoxDecoration(
                    boxColor: position == value
                        ? context.resources.color.viewBgColor
                        : context.resources.color.colorWhite)
                .circularBox,
          );
        });
  }
}
