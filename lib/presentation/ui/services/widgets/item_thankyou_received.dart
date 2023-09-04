import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';

class ItemThankyouReceived extends StatelessWidget {
  final ThankyouEntity data;
  const ItemThankyouReceived({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${context.string.receivedBy}: ',
              style: context.textFontWeight400,
            ),
            Text(
              isLocalEn ? data.empNameEN ?? '' : data.empNameAR ?? '',
              style: context.textFontWeight600,
            ),
          ],
        ),
        SizedBox(
          height: context.resources.dimen.dp5,
        ),
        Row(
          children: [
            Text(
              '${context.string.deptName}: ',
              style: context.textFontWeight400,
            ),
            Text(
              isLocalEn
                  ? data.departmentNameEn ?? ''
                  : data.departmentNameAr ?? '',
              style: context.textFontWeight600,
            ),
          ],
        ),
        SizedBox(
          height: context.resources.dimen.dp5,
        ),
        Row(
          children: [
            Text(
              '${context.string.reason}: ',
              style: context.textFontWeight400,
            ),
            Text(
              isLocalEn ? data.reasonEn ?? '' : data.reasonAr ?? '',
              style: context.textFontWeight600,
            ),
          ],
        ),
        SizedBox(
          height: context.resources.dimen.dp5,
        ),
        Row(
          children: [
            Text(
              '${context.string.date}: ',
              style: context.textFontWeight400,
            ),
            Text(
              data.creationDate ?? '',
              style: context.textFontWeight600
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
        ),
      ],
    );
  }
}
