import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

import '../../../res/drawables/background_box_decoration.dart';

class InfoLoaderWidget extends StatelessWidget {
  final String message;
  const InfoLoaderWidget({required this.message, super.key});

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
            const Center(
              child: SizedBox(
                  width: 40, height: 40, child: CircularProgressIndicator()),
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
