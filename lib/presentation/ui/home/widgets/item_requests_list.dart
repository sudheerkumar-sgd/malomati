import 'dart:math';

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class ItemRequestsList extends StatelessWidget {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);

  ItemRequestsList({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isExpanded,
        builder: (context, isExpaned, widget) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            margin:
                EdgeInsets.symmetric(horizontal: context.resources.dimen.dp5),
            child: InkWell(
              onTap: () {
                _isExpanded.value = !isExpaned;
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageWidget(
                          path: (Random().nextInt(100) % 2) == 1
                              ? DrawableAssets.icApprovedCircle
                              : DrawableAssets.icRejectCircle)
                      .loadImage,
                  SizedBox(
                    width: context.resources.dimen.dp8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Annual leave \nRequested on : 23/2/2023, 08:52AM',
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: context.resources.dimen.dp8,
                              ),
                              Text(
                                '2 days, 02/03/2023 to 03/03/2023',
                                style: context.textFontWeight600
                                    .onColor(
                                        context.resources.color.textColor212B4B)
                                    .onFontSize(context.resources.dimen.dp12),
                              ),
                              SizedBox(
                                height: context.resources.dimen.dp5,
                              ),
                              Text(
                                'Approvals',
                                style: context.textFontWeight600
                                    .onColor(
                                        context.resources.color.textColor212B4B)
                                    .onFontSize(context.resources.dimen.dp12),
                              ),
                              SizedBox(
                                height: context.resources.dimen.dp8,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: ShapeDecoration(
                                        shape: const CircleBorder(),
                                        color: context
                                            .resources.color.colorGreen26B757),
                                  ),
                                  SizedBox(
                                    width: context.resources.dimen.dp5,
                                  ),
                                  Text(
                                    'Line Manager Approval',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '24/02/2023, 08:32 AM',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: context.resources.dimen.dp5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: ShapeDecoration(
                                        shape: const CircleBorder(),
                                        color: context
                                            .resources.color.colorGreen26B757),
                                  ),
                                  SizedBox(
                                    width: context.resources.dimen.dp5,
                                  ),
                                  Text(
                                    'HR Approval',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '24/02/2023, 08:32 AM',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: context.resources.dimen.dp5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: ShapeDecoration(
                                        shape: const CircleBorder(),
                                        color: context
                                            .resources.color.colorD32030),
                                  ),
                                  SizedBox(
                                    width: context.resources.dimen.dp5,
                                  ),
                                  Text(
                                    'Manager Approval',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'pending',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: context.resources.dimen.dp8,
                                  ),
                                  Text(
                                    'Reason : No Attachment',
                                    style: context.textFontWeight400
                                        .onColor(context
                                            .resources.color.textColor212B4B)
                                        .onFontSize(
                                            context.resources.dimen.dp11),
                                  ),
                                  SizedBox(
                                    height: context.resources.dimen.dp6,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: context.resources.dimen.dp3,
                                        horizontal:
                                            context.resources.dimen.dp10),
                                    decoration: BackgroundBoxDecoration(
                                            boxColor: context.resources.color
                                                .viewBgColorLight,
                                            radious:
                                                context.resources.dimen.dp10)
                                        .roundedCornerBox,
                                    child: Text(
                                      'Re - apply',
                                      style: context.textFontWeight400
                                          .onColor(context
                                              .resources.color.colorWhite)
                                          .onFontSize(
                                              context.resources.dimen.dp10),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
