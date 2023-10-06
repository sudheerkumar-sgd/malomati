import 'package:flutter/material.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';

import '../../../../core/common/common_utils.dart';
import '../../../../domain/entities/events_entity.dart';

class ItemEvents extends StatelessWidget {
  final EventsEntity data;
  const ItemEvents({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    printLog(
        message:
            'dfdff ${DateTime.now().compareTo(getDateTimeByString('yyyy-MM-ddThh:mm:ss', data.sTARTDATE ?? ''))}');
    var isEventDone =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                .compareTo(getDateTimeByString(
                    'yyyy-MM-ddThh:mm:ss', data.sTARTDATE ?? '')) >
            0;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: resources.dimen.dp10, horizontal: resources.dimen.dp15),
      decoration: BackgroundBoxDecoration(
              boxColor: resources.color.colorWhite,
              radious: resources.dimen.dp15)
          .roundedCornerBox,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: resources.dimen.dp7,
                horizontal: resources.dimen.dp15),
            decoration: BackgroundBoxDecoration(
                    boxColor: isEventDone
                        ? resources.color.colorD6D6D6
                        : resources.color.viewBgColor,
                    radious: resources.dimen.dp10)
                .roundedCornerBox,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text:
                      '${getDateByformat('dd', getDateTimeByString('yyyy-MM-ddThh:mm:ss', data.sTARTDATE ?? ''))}\n',
                  style: context.textFontWeight600
                      .onFontFamily(fontFamily: fontFamilyEN)
                      .onFontSize(resources.fontSize.dp15)
                      .onColor(resources.color.colorWhite)
                      .copyWith(height: 1.0),
                  children: [
                    TextSpan(
                      text: getDateByformat(
                              'MMM',
                              getDateTimeByString(
                                  'yyyy-MM-ddThh:mm:ss', data.sTARTDATE ?? ''))
                          .toUpperCase(),
                      style: context.textFontWeight400
                          .onFontFamily(fontFamily: fontFamilyEN)
                          .onColor(resources.color.colorWhite)
                          .onFontSize(resources.fontSize.dp10)
                          .copyWith(height: 1.2),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            width: resources.dimen.dp20,
          ),
          Text(
            data.nAME ?? '',
            style: context.textFontWeight600
                .onFontSize(resources.fontSize.dp15)
                .onFontFamily(fontFamily: fontFamilyAR)
                .onColor(isEventDone
                    ? resources.color.bottomSheetIconUnSelected
                    : resources.color.textColor),
          )
        ],
      ),
    );
  }
}
