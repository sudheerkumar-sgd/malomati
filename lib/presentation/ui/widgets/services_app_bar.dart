import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:page_transition/page_transition.dart';

import '../../../config/constant_config.dart';
import '../home/notification_screen.dart';
import '../home/user_profile_screen.dart';

class ServicesAppBarWidget extends StatelessWidget {
  final String title;
  const ServicesAppBarWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: context.textFontWeight600
              .onColor(context.resources.color.viewBgColor)
              .onFontSize(context.resources.fontSize.dp17),
        )),
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: NotificationsScreen(),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                        padding: EdgeInsets.all(context.resources.dimen.dp5),
                        child: ImageWidget(
                                path: DrawableAssets.icBell,
                                backgroundTint:
                                    context.resources.color.textColor)
                            .loadImage),
                    ValueListenableBuilder(
                        valueListenable: ConstantConfig.isApprovalCountChange,
                        builder: (context, value, child) {
                          return Visibility(
                            visible: ConstantConfig.notificationsCount > 0,
                            child: Center(
                              child: Container(
                                width: context.resources.dimen.dp15,
                                height: context.resources.dimen.dp15,
                                decoration: ShapeDecoration(
                                    shape: const CircleBorder(),
                                    color: context.resources.color.viewBgColor),
                                child: Text(
                                    '${ConstantConfig.notificationsCount}',
                                    textAlign: TextAlign.center,
                                    style: context.textFontWeight600
                                        .onColor(
                                            context.resources.color.colorWhite)
                                        .onFontFamily(fontFamily: fontFamilyEN)
                                        .onFontSize(
                                            context.resources.fontSize.dp8)
                                        .copyWith(height: 1.5)),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              SizedBox(
                width: context.resources.dimen.dp5,
              ),
              InkWell(
                onTap: () {
                  context.resources.setLocal();
                },
                child: Container(
                  padding: EdgeInsets.all(context.resources.dimen.dp5),
                  child: ImageWidget(
                          path: context.resources.isLocalEn
                              ? DrawableAssets.icLangAr
                              : DrawableAssets.icLangEn,
                          backgroundTint: context.resources.color.textColor)
                      .loadImage,
                ),
              ),
              SizedBox(
                width: context.resources.dimen.dp5,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: UserProfileScreen(),
                    ),
                  );
                },
                child: Container(
                    padding: EdgeInsets.only(
                      left: context.resources.dimen.dp5,
                      top: context.resources.dimen.dp5,
                      bottom: context.resources.dimen.dp5,
                    ),
                    child: ImageWidget(
                            path: DrawableAssets.icUserCircle,
                            backgroundTint: context.resources.color.textColor)
                        .loadImage),
              ),
            ],
          ),
        )
      ],
    );
  }
}
