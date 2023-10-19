import 'package:flutter/material.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import '../../../../domain/entities/warning_list_entity.dart';

class ItemWarnings extends StatelessWidget {
  final WarningListEntity data;
  ItemWarnings({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: resources.dimen.dp17, vertical: resources.dimen.dp13),
      decoration: BackgroundBoxDecoration(
              boxColor: resources.color.colorWhite,
              radious: resources.dimen.dp15)
          .roundedCornerBox,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: data.date ?? '27/06/2023, 10:41AM',
              style: context.textFontWeight400
                  .onFontFamily(fontFamily: fontFamilyEN)
                  .onColor(resources.color.bgGradientStart)
                  .onFontSize(resources.fontSize.dp12),
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: context.resources.dimen.dp10,
          ),
          RichText(
            text: TextSpan(
              text: '${context.string.receivedBy}: ',
              style: context.textFontWeight600
                  .onFontFamily(
                      fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR)
                  .onFontSize(resources.fontSize.dp12),
              children: [
                TextSpan(
                  text: data.receivedBy ?? 'Shaikha Bintook',
                  style: context.textFontWeight400
                      .onFontFamily(
                          fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR)
                      .onFontSize(resources.fontSize.dp12),
                ),
              ],
            ),
          ),
          SizedBox(
            height: context.resources.dimen.dp5,
          ),
          RichText(
            text: TextSpan(
                text: '${context.string.reason}: ',
                style: context.textFontWeight600
                    .onFontFamily(
                        fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR)
                    .onFontSize(resources.fontSize.dp12),
                children: [
                  TextSpan(
                    text: data.reason ?? 'Late Punch-In',
                    style: context.textFontWeight400
                        .onFontFamily(
                            fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR)
                        .onFontSize(resources.fontSize.dp12),
                  ),
                ]),
          ),
          SizedBox(
            height: context.resources.dimen.dp5,
          ),
          RichText(
            text: TextSpan(
              text: '${context.string.note}: ',
              style: context.textFontWeight600
                  .onFontFamily(
                      fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR)
                  .onFontSize(resources.fontSize.dp12),
              children: [
                TextSpan(
                  text: data.notes ?? 'Punched late on 23rd Sept 2023',
                  style: context.textFontWeight400
                      .onFontFamily(fontFamily: fontFamilyEN)
                      .onFontSize(resources.fontSize.dp12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
