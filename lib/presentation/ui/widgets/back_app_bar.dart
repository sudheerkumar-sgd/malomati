import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:page_transition/page_transition.dart';

import '../home/user_profile_screen.dart';

class BackAppBarWidget extends StatelessWidget {
  final String title;
  const BackAppBarWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: context.resources.dimen.dp30,
            height: context.resources.dimen.dp30,
            decoration: BackgroundBoxDecoration(
                    boxColor: context.resources.color.colorWhite)
                .circularBox,
            child: ImageWidget(
                    path: DrawableAssets.icChevronBack,
                    backgroundTint: context.resources.iconBgColor,
                    boxType: BoxFit.none)
                .loadImage,
          ),
        ),
        SizedBox(
          width: context.resources.dimen.dp5,
        ),
        Expanded(
            child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: context.textFontWeight600
              .onFontFamily(fontFamily: fontFamilyEN)
              .onColor(context.resources.color.viewBgColor)
              .onFontSize(context.resources.dimen.dp17),
        )),
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(context.resources.dimen.dp5),
                  child: ImageWidget(
                          path: DrawableAssets.icBell,
                          backgroundTint: context.resources.color.textColor)
                      .loadImage),
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
