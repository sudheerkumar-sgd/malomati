// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/presentation/ui/more/about_malomati.dart';
import 'package:malomati/presentation/ui/more/privacy_and_policy.dart';
import 'package:malomati/presentation/ui/widgets/guest_services_app_bar.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:page_transition/page_transition.dart';

import '../../../core/enum.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../../../res/resources.dart';
import '../widgets/animated_toggle.dart';
import '../widgets/image_widget.dart';

enum LanguageType { en, ar }

class GuestMoreScreen extends StatelessWidget {
  GuestMoreScreen({super.key});
  late Resources resources;
  final ValueNotifier _languageType =
      ValueNotifier<LanguageType>(LanguageType.en);

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    _languageType.value =
        resources.isLocalEn ? LanguageType.en : LanguageType.ar;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: context.resources.dimen.dp20,
                      horizontal: context.resources.dimen.dp25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.resources.dimen.dp10,
                      ),
                      GuestServicesAppBarWidget(title: context.string.more),
                      SizedBox(
                        height: context.resources.dimen.dp20,
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      ValueListenableBuilder(
                          valueListenable: _languageType,
                          builder: (context, languageType, widget) {
                            return Row(children: [
                              ImageWidget(
                                      path: DrawableAssets.icLanguage,
                                      backgroundTint: resources.iconBgColor)
                                  .loadImage,
                              SizedBox(
                                width: resources.dimen.dp10,
                              ),
                              Text(
                                context.string.language,
                                style: context.textFontWeight400
                                    .onColor(context.resources.color.textColor)
                                    .onFontSize(
                                        context.resources.fontSize.dp15),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  _languageType.value = LanguageType.en;
                                  resources.setLocal(
                                      language: LocalEnum.en.name);
                                },
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.5,
                                      child: SizedBox(
                                        width: 6,
                                        height: 6,
                                        child: Radio<LanguageType>(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            value: LanguageType.en,
                                            groupValue: languageType,
                                            onChanged: (LanguageType? value) {
                                              _languageType.value = value;
                                              resources.setLocal(
                                                  language: LocalEnum.ar.name);
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: resources.dimen.dp5,
                                    ),
                                    Text(
                                      'English',
                                      style: context.textFontWeight600
                                          .onColor(
                                              context.resources.color.textColor)
                                          .onFontSize(
                                              context.resources.fontSize.dp13)
                                          .onFontFamily(
                                              fontFamily: fontFamilyEN),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: resources.dimen.dp20,
                              ),
                              InkWell(
                                onTap: () {
                                  _languageType.value = LanguageType.ar;
                                  resources.setLocal(
                                      language: LocalEnum.ar.name);
                                },
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.5,
                                      child: SizedBox(
                                        width: 6,
                                        height: 6,
                                        child: Radio<LanguageType>(
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            value: LanguageType.ar,
                                            groupValue: languageType,
                                            onChanged: (LanguageType? value) {
                                              _languageType.value = value;
                                              resources.setLocal(
                                                  language: LocalEnum.ar.name);
                                            }),
                                      ),
                                    ),
                                    SizedBox(
                                      width: resources.dimen.dp5,
                                    ),
                                    Text(
                                      'العربية',
                                      style: context.textFontWeight600
                                          .onColor(
                                              context.resources.color.textColor)
                                          .onFontSize(
                                              context.resources.fontSize.dp13)
                                          .onFontFamily(
                                              fontFamily: fontFamilyAR),
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          }),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      Container(
                        color: context.resources.color.colorD6D6D6,
                        height: 0.5,
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      Row(children: [
                        ImageWidget(
                                path: DrawableAssets.icTheme,
                                backgroundTint: resources.iconBgColor)
                            .loadImage,
                        SizedBox(
                          width: resources.dimen.dp10,
                        ),
                        Text(
                          context.string.color,
                          style: context.textFontWeight400
                              .onColor(context.resources.color.textColor)
                              .onFontSize(context.resources.fontSize.dp15),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 114,
                          child: AnimatedToggle(
                            width: 114,
                            height: 17,
                            values: [context.string.red, context.string.blue],
                            selectedPossition: resources.isRedTheme ? 0 : 1,
                            onToggleCallback: (value) {
                              resources.setTheme();
                            },
                            buttonColor: resources.color.viewBgColor,
                            backgroundColor:
                                resources.color.bottomSheetIconUnSelected,
                            textColor: const Color(0xFFFFFFFF),
                          ),
                        ),
                      ]),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      Container(
                        color: context.resources.color.colorD6D6D6,
                        height: 0.5,
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      Row(children: [
                        ImageWidget(
                                path: DrawableAssets.icFontBig,
                                backgroundTint: resources.iconBgColor)
                            .loadImage,
                        SizedBox(
                          width: resources.dimen.dp10,
                        ),
                        Text(
                          context.string.fontsSize,
                          style: context.textFontWeight400
                              .onColor(context.resources.color.textColor)
                              .onFontSize(context.resources.fontSize.dp15),
                        ),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                resources.setFontSize(FontSizeEnum.bigSize);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, top: 5.0, right: 10.0),
                                child: Text(
                                  'A',
                                  style: context.textFontWeight400
                                      .onFontFamily(fontFamily: fontFamilyEN)
                                      .onFontSize(resources.fontSize.dp20)
                                      .onColor(
                                        resources.getUserSelcetedFontSize() ==
                                                FontSizeEnum.bigSize
                                            ? resources.iconBgColor
                                            : resources.color.textColor,
                                      )
                                      .copyWith(
                                          fontWeight: resources
                                                      .getUserSelcetedFontSize() ==
                                                  FontSizeEnum.bigSize
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          height: 1),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                resources.setFontSize(FontSizeEnum.defaultSize);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 5.0, right: 10.0),
                                child: Text(
                                  'A',
                                  style: context.textFontWeight400
                                      .onFontFamily(fontFamily: fontFamilyEN)
                                      .onFontSize(resources.fontSize.dp15)
                                      .onColor(
                                        resources.getUserSelcetedFontSize() ==
                                                FontSizeEnum.defaultSize
                                            ? resources.iconBgColor
                                            : resources.color.textColor,
                                      )
                                      .copyWith(
                                          fontWeight: resources
                                                      .getUserSelcetedFontSize() ==
                                                  FontSizeEnum.defaultSize
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          height: 1),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                resources.setFontSize(FontSizeEnum.smallSize);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 5.0, right: 5.0),
                                child: Text(
                                  'A',
                                  style: context.textFontWeight400
                                      .onFontFamily(fontFamily: fontFamilyEN)
                                      .onFontSize(resources.fontSize.dp10)
                                      .onColor(
                                        resources.getUserSelcetedFontSize() ==
                                                FontSizeEnum.smallSize
                                            ? resources.iconBgColor
                                            : resources.color.textColor,
                                      )
                                      .copyWith(
                                          fontWeight: resources
                                                      .getUserSelcetedFontSize() ==
                                                  FontSizeEnum.smallSize
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          height: 1),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      Container(
                        color: context.resources.color.colorD6D6D6,
                        height: 0.5,
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const PrivacyAndPolicy(),
                            ),
                          );
                        },
                        child: Row(children: [
                          ImageWidget(
                                  path: DrawableAssets.icPrivacy,
                                  backgroundTint: resources.iconBgColor)
                              .loadImage,
                          SizedBox(
                            width: resources.dimen.dp10,
                          ),
                          Text(
                            context.string.privacyAndPolicy,
                            style: context.textFontWeight400
                                .onColor(context.resources.color.textColor)
                                .onFontSize(context.resources.fontSize.dp15),
                          ),
                          const Spacer(),
                        ]),
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      Container(
                        color: context.resources.color.colorD6D6D6,
                        height: 0.5,
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.of(context, rootNavigator: false).pushNamed(
                          //   AboutMalomati.route,
                          // );
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: AboutMalomati(),
                            ),
                          );
                        },
                        child: Row(children: [
                          ImageWidget(
                                  path: DrawableAssets.icInfoCircle,
                                  backgroundTint: resources.iconBgColor)
                              .loadImage,
                          SizedBox(
                            width: resources.dimen.dp10,
                          ),
                          Text(
                            context.string.aboutMalomati,
                            style: context.textFontWeight400
                                .onColor(context.resources.color.textColor)
                                .onFontSize(context.resources.fontSize.dp15),
                          ),
                          const Spacer(),
                        ]),
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp60,
                      ),
                      InkWell(
                        onTap: () {
                          logout(context);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: resources.dimen.dp60),
                          padding: EdgeInsets.all(resources.dimen.dp7),
                          decoration: BackgroundBoxDecoration(
                            boxColor: resources.color.viewBgColor,
                            radious: context.resources.dimen.dp20,
                          ).roundedCornerBox,
                          alignment: Alignment.center,
                          child: Text(
                            context.string.login,
                            style: context.textFontWeight400
                                .onColor(resources.color.colorWhite)
                                .onFontSize(context.resources.fontSize.dp17)
                                .copyWith(height: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.resources.dimen.dp30,
            ),
          ],
        ),
      ),
    );
  }
}
