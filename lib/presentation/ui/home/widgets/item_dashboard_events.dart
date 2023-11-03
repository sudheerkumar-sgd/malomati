import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class ItemDashboardEvent extends StatelessWidget {
  final EventsEntity eventsEntity;
  const ItemDashboardEvent({required this.eventsEntity, super.key});

  String _getWishTitle(BuildContext context) {
    if (eventsEntity.eVENTTYPE == '2') {
      return context.string.eventNewjoinWishTitle;
    } else if (eventsEntity.eVENTTYPE == '1' || eventsEntity.eVENTTYPE == '3') {
      return context.string.eventBirthDayWishTitle;
    } else {
      return '';
    }
  }

  String _getWishText(BuildContext context) {
    if (eventsEntity.eVENTTYPE == '1') {
      return context.string.happyBirthday;
    } else if (eventsEntity.eVENTTYPE == '2') {
      return '${context.string.welcome}!';
    } else if (eventsEntity.eVENTTYPE == '3') {
      return context.string.happyWorkAnniversary;
    } else {
      return context.string.noEventsMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (eventsEntity.eVENTTYPE == '4')
        ? ImageWidget(
            path: isLocalEn
                ? eventsEntity.bannerUrlEn ??
                    DrawableAssets.appmenubannnerEnglish
                : eventsEntity.bannerUrlAr ??
                    DrawableAssets.appmenubannnerArabic,
          ).loadImage
        : Container(
            margin:
                EdgeInsets.symmetric(horizontal: context.resources.dimen.dp10),
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
                Visibility(
                  visible: eventsEntity.eVENTTYPE?.isNotEmpty ?? false,
                  child: Container(
                    padding: EdgeInsets.all(context.resources.dimen.dp10),
                    decoration: BackgroundBoxDecoration(
                      boxColor: context.resources.color.bgGradientEnd,
                    ).circularBox,
                    child: ImageWidget(path: DrawableAssets.icCelebration)
                        .loadImage,
                  ),
                ),
                SizedBox(
                  width: context.resources.dimen.dp8,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: eventsEntity.eVENTTYPE?.isNotEmpty ?? false,
                        child: Text(
                          textAlign: TextAlign.center,
                          _getWishTitle(context).toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: context.textFontWeight400
                              .onColor(context.resources.color.colorWhite)
                              .onFontSize(context.resources.fontSize.dp11),
                        ),
                      ),
                      Visibility(
                        visible: eventsEntity.eVENTTYPE?.isNotEmpty ?? false,
                        child: SizedBox(
                          height: context.resources.dimen.dp5,
                        ),
                      ),
                      Text(
                          textAlign: TextAlign.center,
                          _getWishText(context).toUpperCase(),
                          style: context.textFontWeight700
                              .onColor(context.resources.color.colorWhite)
                              .onFontSize(context.resources.fontSize.dp12)),
                      SizedBox(
                        height: context.resources.dimen.dp5,
                      ),
                      Visibility(
                        visible: eventsEntity.eVENTTYPE?.isNotEmpty ?? false,
                        child: Expanded(
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
                                .onFontSize(context.resources.fontSize.dp12),
                          ),
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
