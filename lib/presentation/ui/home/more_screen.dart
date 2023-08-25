// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/presentation/ui/home/widgets/call_confirmation.dart';
import 'package:malomati/presentation/ui/more/about_malomati.dart';
import 'package:malomati/presentation/ui/more/hr_government_law.dart';
import 'package:malomati/presentation/ui/more/privacy_and_policy.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:page_transition/page_transition.dart';

import '../../../core/enum.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../../../res/resources.dart';
import '../widgets/animated_toggle.dart';
import '../widgets/image_widget.dart';
import '../widgets/services_app_bar.dart';

enum LanguageType { en, ar }

class MoreScreen extends StatelessWidget {
  MoreScreen({super.key});
  late Resources resources;
  final ValueNotifier _isNotificationEnabled = ValueNotifier<bool>(true);
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
                      ServicesAppBarWidget(title: context.string.more),
                      SizedBox(
                        height: context.resources.dimen.dp20,
                      ),
                      Row(children: [
                        ImageWidget(
                                path: DrawableAssets.icSettings,
                                backgroundTint: resources.iconBgColor)
                            .loadImage,
                        SizedBox(
                          width: resources.dimen.dp10,
                        ),
                        Text(
                          context.string.notificationSetting,
                          style: context.textFontWeight400
                              .onColor(context.resources.color.textColor)
                              .onFontSize(context.resources.dimen.dp15),
                        ),
                        const Spacer(),
                        Transform.scale(
                          scale: 0.6,
                          child: SizedBox(
                            width: 34,
                            height: 17,
                            child: ValueListenableBuilder(
                                valueListenable: _isNotificationEnabled,
                                builder:
                                    (context, isNotificationEnabled, widget) {
                                  return CupertinoSwitch(
                                      activeColor: resources.color.viewBgColor,
                                      value: isNotificationEnabled,
                                      onChanged: (value) {
                                        _isNotificationEnabled.value =
                                            !isNotificationEnabled;
                                      });
                                }),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: const HRGovernmentLaw(),
                            ),
                          );
                        },
                        child: Row(children: [
                          ImageWidget(
                                  path: DrawableAssets.icLaw,
                                  backgroundTint: resources.iconBgColor)
                              .loadImage,
                          SizedBox(
                            width: resources.dimen.dp10,
                          ),
                          Text(
                            context.string.hRGovernmentLaw,
                            style: context.textFontWeight400
                                .onColor(context.resources.color.textColor)
                                .onFontSize(context.resources.dimen.dp15),
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
                                    .onFontSize(context.resources.dimen.dp15),
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
                                              context.resources.dimen.dp13)
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
                                              context.resources.dimen.dp13)
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
                              .onFontSize(context.resources.dimen.dp15),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 114,
                          child: AnimatedToggle(
                            width: 114,
                            height: 17,
                            values: const ['red', 'blue'],
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
                                .onFontSize(context.resources.dimen.dp15),
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
                              child: const AboutMalomati(),
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
                                .onFontSize(context.resources.dimen.dp15),
                          ),
                          const Spacer(),
                        ]),
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp50,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          context.string.contactAssistance,
                          style: context.textFontWeight600
                              .onColor(context.resources.color.viewBgColor)
                              .onFontSize(context.resources.dimen.dp17),
                        ),
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp20,
                      ),
                      InkWell(
                        onTap: () {
                          sendEmail(context, supportEmailId);
                        },
                        child: Row(children: [
                          ImageWidget(
                                  path: DrawableAssets.icMail,
                                  backgroundTint: resources.iconBgColor)
                              .loadImage,
                          SizedBox(
                            width: resources.dimen.dp10,
                          ),
                          Text(
                            supportEmailId,
                            style: context.textFontWeight400
                                .onColor(context.resources.color.textColor)
                                .onFontSize(context.resources.dimen.dp15),
                          ),
                          const Spacer(),
                          ImageWidget(
                            path: DrawableAssets.icChevronRight,
                            isLocalEn: context.resources.isLocalEn,
                          ).loadImage,
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
                          Dialogs.showBottomSheetDialogTransperrent(
                              context,
                              const CallConfirmationWidget(
                                  mobileNumber: supportMobileNumber));
                        },
                        child: Row(children: [
                          ImageWidget(
                                  path: DrawableAssets.icCall,
                                  backgroundTint: resources.iconBgColor)
                              .loadImage,
                          SizedBox(
                            width: resources.dimen.dp10,
                          ),
                          Text(
                            supportMobileNumber,
                            style: context.textFontWeight400
                                .onColor(context.resources.color.textColor)
                                .onFontFamily(fontFamily: fontFamilyEN)
                                .onFontSize(context.resources.dimen.dp15),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.resources.dimen.dp20,
            ),
            InkWell(
              onTap: () {
                logout(context);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: resources.dimen.dp60),
                padding: EdgeInsets.all(resources.dimen.dp7),
                decoration: BackgroundBoxDecoration(
                  boxColor: resources.color.viewBgColor,
                  radious: context.resources.dimen.dp20,
                ).roundedCornerBox,
                alignment: Alignment.center,
                child: Text(
                  context.string.logout,
                  style: context.textFontWeight400
                      .onColor(resources.color.colorWhite)
                      .onFontSize(context.resources.dimen.dp17)
                      .copyWith(height: 1),
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
