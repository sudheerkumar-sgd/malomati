import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class GuestBackAppBarWidget extends StatelessWidget {
  final String title;
  const GuestBackAppBarWidget({required this.title, super.key});

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
              boxType: BoxFit.none,
              isLocalEn: context.resources.isLocalEn,
            ).loadImage,
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
              .onColor(context.resources.color.viewBgColor)
              .onFontSize(context.resources.fontSize.dp17),
        )),
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
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
            ],
          ),
        )
      ],
    );
  }
}
