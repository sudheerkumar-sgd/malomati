// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';

class RatingDialogWidget extends StatelessWidget {
  RatingDialogWidget({super.key});
  final ValueNotifier<int> _rating = ValueNotifier<int>(0);
  final InAppReview inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    Resources resources = context.resources;
    _rating.value = 5;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: resources.dimen.dp10,
            ),
            Container(
              padding: EdgeInsets.all(
                context.resources.dimen.dp10,
              ),
              decoration: BackgroundBoxDecoration(
                      boxColor: context.resources.color.colorWhite,
                      radious: context.resources.dimen.dp10)
                  .roundedBoxWithShadow,
              child: ImageWidget(
                      path: DrawableAssets.icLogo, width: 36, height: 36)
                  .loadImage,
            ),
            SizedBox(
              height: context.resources.dimen.dp20,
            ),
            Text.rich(
              TextSpan(
                  text: isLocalEn ? 'Rate Our App' : 'قيّم تطبيقنا',
                  children: []),
              style: context.textFontWeight600
                  .onFontSize(context.resources.fontSize.dp16),
            ),
            // Text(
            //   resources.string.feedBackRatingTitleDes
            //       .replaceAll('00000', ' ${data['ticketID'] ?? ''} '),
            //   textAlign: TextAlign.center,
            //   style: context.textFontWeight400
            //       .onFontSize(context.resources.fontSize.dp12),
            // ),
            SizedBox(
              height: context.resources.dimen.dp10,
            ),
            Text(
              isLocalEn
                  ? 'Your rating helps us deliver a better experience.'
                  : 'تقييمك يساعدنا على تحسين تجربة المستخدم.',
              style: context.textFontWeight400
                  .onFontSize(context.resources.fontSize.dp12),
            ),
            SizedBox(
              height: context.resources.dimen.dp20,
            ),
            ValueListenableBuilder(
                valueListenable: _rating,
                builder: (context, value, child) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            _rating.value = 1;
                          },
                          child: ImageWidget(
                                  path: DrawableAssets.icStar,
                                  padding: const EdgeInsets.all(5),
                                  backgroundTint:
                                      value > 0 ? Colors.orange : null)
                              .loadImageWithMoreTapArea,
                        ),
                        InkWell(
                          onTap: () {
                            _rating.value = 2;
                          },
                          child: ImageWidget(
                                  path: DrawableAssets.icStar,
                                  padding: const EdgeInsets.all(5),
                                  backgroundTint:
                                      value > 1 ? Colors.orange : null)
                              .loadImageWithMoreTapArea,
                        ),
                        InkWell(
                          onTap: () {
                            _rating.value = 3;
                          },
                          child: ImageWidget(
                                  path: DrawableAssets.icStar,
                                  padding: const EdgeInsets.all(5),
                                  backgroundTint:
                                      value > 2 ? Colors.orange : null)
                              .loadImageWithMoreTapArea,
                        ),
                        InkWell(
                          onTap: () {
                            _rating.value = 4;
                          },
                          child: ImageWidget(
                                  path: DrawableAssets.icStar,
                                  padding: const EdgeInsets.all(5),
                                  backgroundTint:
                                      value > 3 ? Colors.orange : null)
                              .loadImageWithMoreTapArea,
                        ),
                        InkWell(
                          onTap: () {
                            _rating.value = 5;
                          },
                          child: ImageWidget(
                                  path: DrawableAssets.icStar,
                                  padding: const EdgeInsets.all(5),
                                  backgroundTint:
                                      value > 4 ? Colors.orange : null)
                              .loadImageWithMoreTapArea,
                        ),
                      ]);
                }),
            SizedBox(
              height: context.resources.dimen.dp25,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  if (await inAppReview.isAvailable()) {
                    Navigator.pop(context);
                    inAppReview.requestReview();
                  } else if (context.mounted) {
                    Navigator.pop(context);
                    launchAppUrl(
                        Platform.isAndroid ? 'com.gov.uaq.hrms' : '6468637952');
                  }
                },
                child: Container(
                  width: 150,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp20,
                      vertical: context.resources.dimen.dp10),
                  decoration: BackgroundBoxDecoration(
                          boxColor: context.resources.color.viewBgColorLight,
                          radious: context.resources.dimen.dp15)
                      .roundedCornerBox,
                  child: Text(
                    'Write a review',
                    style: context.textFontWeight600
                        .onFontSize(context.resources.fontSize.dp14)
                        .onColor(Colors.white)
                        .copyWith(height: 1),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.resources.dimen.dp15,
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Dialogs.dismiss(context);
                },
                child: Container(
                  width: 150,
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp20,
                      vertical: context.resources.dimen.dp10),
                  decoration: BackgroundBoxDecoration(
                          boxColor: context.resources.color.viewBgColorLight
                              .withAlpha(50),
                          radious: context.resources.dimen.dp15)
                      .roundedCornerBox,
                  child: Text(
                    'Close',
                    style: context.textFontWeight600
                        .onFontSize(context.resources.fontSize.dp14)
                        .onColor(resources.color.textColor.withAlpha(150))
                        .copyWith(height: 1),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.resources.dimen.dp5,
            ),
          ],
        ),
      ),
    );
  }
}
