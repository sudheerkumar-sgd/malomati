import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

class ItemThankyouReceived extends StatelessWidget {
  const ItemThankyouReceived({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Received by: ',
              style: context.textFontWeight400,
            ),
            Text(
              'Ahmed Abdullah ',
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
              'Dept. Name: ',
              style: context.textFontWeight400,
            ),
            Text(
              'Umm Al Quwain Municipality',
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
              'Reason: ',
              style: context.textFontWeight400,
            ),
            Text(
              'Completing task ',
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
              'Date : ',
              style: context.textFontWeight400,
            ),
            Text(
              '02/08/2023, 12:15 PM ',
              style: context.textFontWeight600
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
        ),
      ],
    );
  }
}
