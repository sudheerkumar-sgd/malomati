import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';

import '../../../res/drawables/background_box_decoration.dart';

class NotificationDialogWidget extends StatelessWidget {
  final String message;
  final String title;
  final String imageUrl;
  final String actionButtionTitle;
  const NotificationDialogWidget(
      {required this.message,
      this.imageUrl = '',
      this.title = '',
      this.actionButtionTitle = '',
      super.key});

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
            if (imageUrl.isNotEmpty) ...{
              ImageWidget(
                path: imageUrl,
              ).loadImage,
            },
            SizedBox(
              height: context.resources.dimen.dp10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textFontWeight600
                  .onFontSize(context.resources.fontSize.dp17),
            ),
            SizedBox(
              height: context.resources.dimen.dp20,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12),
            ),
            SizedBox(
              height: context.resources.dimen.dp25,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context, 'send');
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
                  actionButtionTitle.isEmpty
                      ? context.string.close
                      : actionButtionTitle,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp15)
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
