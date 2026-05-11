import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/constants/data_constants.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import '../widgets/back_app_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutMalomati extends StatefulWidget {
  static const String route = '/AboutMalomati';
  const AboutMalomati({super.key});

  @override
  State<AboutMalomati> createState() => _AboutMalomatiState();
}

class _AboutMalomatiState extends State<AboutMalomati> {
  final ValueNotifier<String> _version = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;
    _version.value = "${packageInfo.version} (${packageInfo.buildNumber})";
  }

  @override
  void dispose() {
    _version.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Container(
          margin: EdgeInsets.symmetric(
              vertical: context.resources.dimen.dp20,
              horizontal: context.resources.dimen.dp25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              BackAppBarWidget(title: context.string.aboutMalomati),
              SizedBox(
                height: context.resources.dimen.dp60,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.resources.dimen.dp15),
                decoration: BackgroundBoxDecoration(
                        boxColor: context.resources.color.colorWhite,
                        radious: context.resources.dimen.dp10)
                    .roundedCornerBox,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: context.resources.dimen.dp40,
                    ),
                    ImageWidget(
                      path: DrawableAssets.icAppIcon,
                    ).loadImage,
                    SizedBox(
                      height: context.resources.dimen.dp25,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _version,
                        builder: (context, value, child) {
                          return RichText(
                              text: TextSpan(
                                  text: '${context.string.version}: ',
                                  style: context.textFontWeight600.onFontSize(
                                      context.resources.fontSize.dp11),
                                  children: [
                                TextSpan(
                                    text: value,
                                    style: context.textFontWeight600
                                        .onFontSize(
                                            context.resources.fontSize.dp11)
                                        .onFontFamily(fontFamily: fontFamilyEN))
                              ]));
                        }),
                    SizedBox(
                      height: context.resources.dimen.dp1,
                    ),
                    RichText(
                        text: TextSpan(
                            text: '${context.string.lastUpdateText}: ',
                            style: context.textFontWeight400
                                .onFontSize(context.resources.fontSize.dp11),
                            children: [
                          TextSpan(
                            text: '11th ',
                            style: context.textFontWeight400
                                .onFontSize(context.resources.fontSize.dp11)
                                .onFontFamily(fontFamily: fontFamilyEN),
                          ),
                          TextSpan(
                            text: isLocalEn ? 'May' : getArabicMonthName('May'),
                            style: context.textFontWeight400
                                .onFontSize(context.resources.fontSize.dp11),
                          ),
                          TextSpan(
                            text: ' 2026',
                            style: context.textFontWeight400
                                .onFontSize(context.resources.fontSize.dp11)
                                .onFontFamily(fontFamily: fontFamilyEN),
                          )
                        ])),
                    SizedBox(
                      height: context.resources.dimen.dp1,
                    ),
                    Text(
                      context.string.developedBy,
                      style: context.textFontWeight400
                          .onFontSize(context.resources.fontSize.dp11),
                    ),
                    SizedBox(
                      height: context.resources.dimen.dp40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageWidget(path: DrawableAssets.icGovUAQ).loadImage,
                        SizedBox(
                          width: context.resources.dimen.dp40,
                        ),
                        ImageWidget(path: DrawableAssets.icSmartUAQ).loadImage,
                      ],
                    ),
                    SizedBox(
                      height: context.resources.dimen.dp25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
