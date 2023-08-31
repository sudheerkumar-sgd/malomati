import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import '../../../../res/drawables/background_box_decoration.dart';

class CallConfirmationWidget extends StatelessWidget {
  final String mobileNumber;
  const CallConfirmationWidget({required this.mobileNumber, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            callNumber(context, mobileNumber);
          },
          child: Container(
            width: double.infinity,
            margin:
                EdgeInsets.symmetric(horizontal: context.resources.dimen.dp30),
            padding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp15,
                horizontal: context.resources.dimen.dp10),
            decoration: BackgroundBoxDecoration(
              boxColor: context.resources.color.colorWhite,
              radious: context.resources.dimen.dp15,
            ).roundedCornerBox,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageWidget(
                        path: DrawableAssets.icCall,
                        backgroundTint: context.resources.color.colorBlue356DCE)
                    .loadImage,
                SizedBox(
                  width: context.resources.dimen.dp15,
                ),
                RichText(
                  text: TextSpan(
                      text: '${context.string.call} ',
                      style: context.textFontWeight400
                          .onColor(context.resources.color.colorBlue356DCE)
                          .onFontSize(context.resources.dimen.dp20),
                      children: [
                        TextSpan(
                          text: mobileNumber,
                          style: context.textFontWeight400
                              .onColor(context.resources.color.colorBlue356DCE)
                              .onFontFamily(fontFamily: fontFamilyEN)
                              .onFontSize(context.resources.dimen.dp20),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(
                left: context.resources.dimen.dp30,
                top: context.resources.dimen.dp10,
                right: context.resources.dimen.dp30,
                bottom: context.resources.dimen.dp20),
            padding: EdgeInsets.symmetric(
                vertical: context.resources.dimen.dp15,
                horizontal: context.resources.dimen.dp10),
            decoration: BackgroundBoxDecoration(
              boxColor: context.resources.color.colorWhite,
              radious: context.resources.dimen.dp15,
            ).roundedCornerBox,
            child: Text(
              'Cancel',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: context.textFontWeight600
                  .onColor(context.resources.color.colorBlue356DCE)
                  .onFontSize(context.resources.dimen.dp20),
            ),
          ),
        ),
      ],
    );
  }
}
