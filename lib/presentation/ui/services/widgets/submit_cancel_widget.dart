import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

import '../../../../res/drawables/background_box_decoration.dart';

class SubmitCancelWidget extends StatelessWidget {
  final Function(String) callBack;
  const SubmitCancelWidget({required this.callBack, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp15,
                  vertical: context.resources.dimen.dp7),
              decoration: BackgroundBoxDecoration(
                      boxColor: context.resources.color.textColorLight,
                      radious: context.resources.dimen.dp15)
                  .roundedCornerBox,
              child: Text(
                context.string.cancel,
                style: context.textFontWeight600
                    .onFontSize(context.resources.dimen.dp17)
                    .onColor(context.resources.color.colorWhite)
                    .copyWith(height: 1),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(
          width: context.resources.dimen.dp20,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              callBack(context.string.submit);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.resources.dimen.dp15,
                  vertical: context.resources.dimen.dp7),
              decoration: BackgroundBoxDecoration(
                      boxColor: context.resources.color.viewBgColor,
                      radious: context.resources.dimen.dp15)
                  .roundedCornerBox,
              child: Text(
                context.string.submit,
                style: context.textFontWeight600
                    .onFontSize(context.resources.dimen.dp17)
                    .onColor(context.resources.color.colorWhite)
                    .copyWith(height: 1),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
