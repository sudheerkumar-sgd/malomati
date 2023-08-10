import 'dart:math';

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class ItemAttendanceList extends StatelessWidget {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);

  ItemAttendanceList({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isExpanded,
        builder: (context, isExpaned, widget) {
          return InkWell(
            onTap: () {
              _isExpanded.value = !isExpaned;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              margin:
                  EdgeInsets.symmetric(horizontal: context.resources.dimen.dp5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: ShapeDecoration(
                            shape: const CircleBorder(),
                            color: (Random().nextInt(100) % 2) == 1
                                ? context.resources.color.colorD32030
                                : context.resources.color.colorGreen26B757),
                      ),
                      SizedBox(
                        width: context.resources.dimen.dp8,
                      ),
                      Expanded(
                        child: Text(
                          'Monday, 09 May 2023',
                          style: context.textFontWeight400
                              .onColor(context.resources.color.textColor)
                              .onFontSize(context.resources.dimen.dp12),
                        ),
                      ),
                      ImageWidget(
                              path: isExpaned
                                  ? DrawableAssets.icChevronUp
                                  : DrawableAssets.icChevronDown)
                          .loadImage
                    ],
                  ),
                  Visibility(
                    visible: isExpaned,
                    child: Container(
                      margin: EdgeInsets.only(
                          left: context.resources.dimen.dp15,
                          top: context.resources.dimen.dp8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Absent',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                  SizedBox(
                                    height: context.resources.dimen.dp5,
                                  ),
                                  Text(
                                    'SGD Office',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Short Leave In: 08:03:00',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                  SizedBox(
                                    height: context.resources.dimen.dp5,
                                  ),
                                  Text(
                                    'Reg Out: 14:04:00',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
