import 'dart:convert';

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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.string.welcome,
              style: context.textFontWeight400
                  .onColor(context.resources.color.colorEDECEC),
            ),
            Text(
              jsonDecode(title),
              style: context.textFontWeight700
                  .onColor(context.resources.color.colorEDECEC)
                  .onFontSize(context.resources.dimen.dp20),
            )
          ],
        ),
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: Row(
            children: [
              ImageWidget(path: DrawableAssets.icLangAr).loadImage,
              ImageWidget(path: DrawableAssets.icLangAr).loadImage,
              ImageWidget(path: DrawableAssets.icLangAr).loadImage,
            ],
          ),
        )
      ],
    );
  }
}
