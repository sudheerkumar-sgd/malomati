import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class ItemDashboardEvent extends StatelessWidget {
  final EventsEntity eventsEntity;
  const ItemDashboardEvent({required this.eventsEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: context.resources.dimen.dp10),
        padding: EdgeInsets.all(context.resources.dimen.dp10),
        decoration: BackgroundBoxDecoration(
                boxColor: context.resources.color.colorWhite,
                radious: context.resources.dimen.dp10)
            .roundedBoxWithShadow
            .copyWith(
              gradient: LinearGradient(
                colors: [
                  context.resources.color.bgGradientStart,
                  context.resources.color.bgGradientEnd,
                ],
              ),
            ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(context.resources.dimen.dp10),
              decoration: BackgroundBoxDecoration(
                boxColor: context.resources.color.bgGradientEnd,
              ).circularBox,
              child: ImageWidget(path: DrawableAssets.icCelebration).loadImage,
            ),
            SizedBox(
              width: context.resources.dimen.dp8,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'Its Time To Wish Your Colleague Today'.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: context.textFontWeight400
                        .onColor(context.resources.color.colorWhite)
                        .onFontSize(context.resources.dimen.dp11),
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp5,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    'Happy Birthday'.toUpperCase(),
                    style: context.textFontWeight900
                        .onFontFamily(fontFamily: fontFamilyEN)
                        .onColor(context.resources.color.colorWhite)
                        .onFontSize(context.resources.dimen.dp12)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: context.resources.dimen.dp5,
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      (context.resources.isLocalEn
                                  ? eventsEntity.fULLNAMEUS
                                  : eventsEntity.fULLNAMEAR)
                              ?.toUpperCase() ??
                          '',
                      overflow: TextOverflow.ellipsis,
                      style: context.textFontWeight900
                          .onColor(context.resources.color.colorWhite)
                          .onFontSize(context.resources.dimen.dp12),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: context.resources.dimen.dp8,
            ),
          ],
        ));
  }
}
