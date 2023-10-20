import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';

class ItemThankyouReceived extends StatelessWidget {
  final ThankyouEntity data;
  const ItemThankyouReceived({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '${context.string.receivedBy}: ',
            style: context.textFontWeight400.onFontFamily(
                fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
            children: [
              TextSpan(
                text: isLocalEn ? data.empNameEN ?? '' : data.empNameAR ?? '',
                style: context.textFontWeight600.onFontFamily(
                    fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: context.resources.dimen.dp5,
        ),
        RichText(
          text: TextSpan(
            text: '${context.string.deptName}: ',
            style: context.textFontWeight400.onFontFamily(
                fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
            children: [
              TextSpan(
                text: isLocalEn
                    ? data.departmentNameEn ?? ''
                    : data.departmentNameAr ?? '',
                style: context.textFontWeight600.onFontFamily(
                    fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
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
              style: context.textFontWeight400.onFontFamily(
                  fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
              children: [
                TextSpan(
                  text: isLocalEn ? data.reasonEn ?? '' : data.reasonAr ?? '',
                  style: context.textFontWeight600.onFontFamily(
                      fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
                ),
              ]),
        ),
        SizedBox(
          height: context.resources.dimen.dp5,
        ),
        if ((data.note ?? '').isNotEmpty) ...[
          RichText(
            text: TextSpan(
                text: '${context.string.note}: ',
                style: context.textFontWeight400.onFontFamily(
                    fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
                children: [
                  TextSpan(
                    text: data.note ?? '',
                    style: context.textFontWeight600.onFontFamily(
                        fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
                  ),
                ]),
          ),
          SizedBox(
            height: context.resources.dimen.dp5,
          ),
        ],
        RichText(
          text: TextSpan(
            text: '${context.string.date}: ',
            style: context.textFontWeight400.onFontFamily(
                fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
            children: [
              TextSpan(
                text: data.creationDate ?? '',
                style: context.textFontWeight600
                    .onFontFamily(fontFamily: fontFamilyEN),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
