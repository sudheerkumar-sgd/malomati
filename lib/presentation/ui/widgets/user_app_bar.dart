import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class UserAppBarWidget extends StatelessWidget {
  final String title;
  const UserAppBarWidget({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.string.welcome,
                style: context.textFontWeight400
                    .onColor(context.resources.color.colorEDECEC),
              ),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: context.textFontWeight600
                    .onFontFamily(fontFamily: fontFamilyEN)
                    .onColor(context.resources.color.colorEDECEC)
                    .onFontSize(context.resources.dimen.dp17),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                  padding: EdgeInsets.all(context.resources.dimen.dp5),
                  child: ImageWidget(path: DrawableAssets.icBell).loadImage),
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
                          backgroundTint: Colors.white)
                      .loadImage,
                ),
              ),
              SizedBox(
                width: context.resources.dimen.dp5,
              ),
              Container(
                  padding: EdgeInsets.only(
                    left: context.resources.dimen.dp5,
                    top: context.resources.dimen.dp5,
                    bottom: context.resources.dimen.dp5,
                  ),
                  child:
                      ImageWidget(path: DrawableAssets.icUserCircle).loadImage),
            ],
          ),
        )
      ],
    );
  }
}
