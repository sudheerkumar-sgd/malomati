// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

import '../../../../res/drawables/background_box_decoration.dart';

class SubmitCancelWidget extends StatelessWidget {
  final Function(String) callBack;
  String actionButtonName;
  String cancelButtonName;
  SubmitCancelWidget({
    required this.callBack,
    this.actionButtonName = '',
    this.cancelButtonName = '',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                cancelButtonName.isEmpty
                    ? Navigator.pop(context)
                    : callBack(cancelButtonName);
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
                  cancelButtonName.isEmpty
                      ? context.string.cancel
                      : cancelButtonName,
                  style: context.textFontWeight600
                      .onFontSize(context.resources.fontSize.dp17)
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
                callBack(actionButtonName.isEmpty
                    ? context.string.submit
                    : actionButtonName);
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
                  actionButtonName.isEmpty
                      ? context.string.submit
                      : actionButtonName,
                  style: context.textFontWeight600
                      .onFontSize(context.resources.fontSize.dp17)
                      .onColor(context.resources.color.colorWhite)
                      .copyWith(height: 1),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
