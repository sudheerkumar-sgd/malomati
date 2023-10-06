import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class GuestServicesAppBarWidget extends StatelessWidget {
  final String title;
  const GuestServicesAppBarWidget({required this.title, super.key});

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
