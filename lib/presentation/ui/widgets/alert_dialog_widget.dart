import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../res/drawables/background_box_decoration.dart';

enum PopupType {
  success,
  fail;
}

class AlertDialogWidget extends StatelessWidget {
  final String message;
  final String title;
  final PopupType type;
  const AlertDialogWidget(
      {required this.message, required this.type, this.title = '', super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      child: Padding(
        padding: EdgeInsets.all(context.resources.dimen.dp20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageWidget(
                    path: DrawableAssets.icCheckmarkCircle,
                    backgroundTint: context.resources.color.viewBgColor)
                .loadImage,
            SizedBox(
              height: context.resources.dimen.dp10,
            ),
            Text(
              title.isEmpty
                  ? (type == PopupType.success
                      ? context.string.thanks
                      : context.string.sorry)
                  : title,
              style: context.textFontWeight600
                  .onFontSize(context.resources.dimen.dp17),
            ),
            SizedBox(
              height: context.resources.dimen.dp20,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textFontWeight400
                  .onFontSize(context.resources.dimen.dp12),
            ),
            SizedBox(
              height: context.resources.dimen.dp25,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp40,
                    vertical: context.resources.dimen.dp7),
                decoration: BackgroundBoxDecoration(
                        boxColor: context.resources.color.bgGradientStart,
                        radious: context.resources.dimen.dp15)
                    .roundedCornerBox,
                child: Text(
                  context.string.close,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.dimen.dp15)
                      .onColor(context.resources.color.colorWhite)
                      .copyWith(height: 1),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
