import 'dart:io';

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';

import '../../../res/drawables/background_box_decoration.dart';

class UpdateDialogWidget extends StatelessWidget {
  const UpdateDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // InkWell(
          //   onTap: () {
          //     //Navigator.pop(context);
          //   },
          //   child: Padding(
          //     padding:
          //         const EdgeInsets.only(left: 10.0, top: 15.0, right: 15.0),
          //     child: Align(
          //         alignment: Alignment.topRight,
          //         child: ImageWidget(path: DrawableAssets.icCross).loadImage),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.resources.dimen.dp20,
                vertical: context.resources.dimen.dp15),
            child: Column(
              children: [
                Text(
                  context.string.appUpdateTitle,
                  textAlign: TextAlign.center,
                  style: context.textFontWeight600
                      .onFontSize(context.resources.fontSize.dp17),
                ),
                SizedBox(
                  height: context.resources.dimen.dp20,
                ),
                Text(
                  context.string.appUpdateBody,
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
                    launchAppUrl(
                        Platform.isAndroid ? 'com.gov.uaq.hrms' : '6468637952');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp20,
                        vertical: context.resources.dimen.dp7),
                    decoration: BackgroundBoxDecoration(
                            boxColor: context.resources.color.viewBgColorLight,
                            radious: context.resources.dimen.dp15)
                        .roundedCornerBox,
                    child: Text(
                      'Download Update',
                      style: context.textFontWeight400
                          .onFontSize(context.resources.fontSize.dp11)
                          .onColor(context.resources.color.colorWhite)
                          .copyWith(height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
