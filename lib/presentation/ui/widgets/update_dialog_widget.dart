import 'dart:io';

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

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
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 15.0, right: 15.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: ImageWidget(path: DrawableAssets.icCross).loadImage),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: context.resources.dimen.dp20),
            child: Column(
              children: [
                Text(
                  'قم بتحديث تطبيقك',
                  textAlign: TextAlign.center,
                  style: context.textFontWeight600
                      .onFontSize(context.resources.fontSize.dp17)
                      .onFontFamily(fontFamily: fontFamilyAR),
                ),
                Text(
                  'Update your application',
                  textAlign: TextAlign.center,
                  style: context.textFontWeight600
                      .onFontSize(context.resources.fontSize.dp17),
                ),
                SizedBox(
                  height: context.resources.dimen.dp20,
                ),
                Text(
                  'نحن نعمل على تحسين الأداء وإصلاح بعض المشاكل لنجعل تجربتك سلسة',
                  textAlign: TextAlign.center,
                  style: context.textFontWeight400
                      .onFontSize(context.resources.fontSize.dp12)
                      .onFontFamily(fontFamily: fontFamilyAR),
                ),
                Text(
                  'We improve performance and fix some bugs to make your experience seamless',
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
                    launchAppUrl(Platform.isAndroid ? 'com.gov.uaq.hrms' : '');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp20,
                        vertical: context.resources.dimen.dp7),
                    decoration: BackgroundBoxDecoration(
                            boxColor: context.resources.color.bgGradientStart,
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
                SizedBox(
                  height: context.resources.dimen.dp15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
