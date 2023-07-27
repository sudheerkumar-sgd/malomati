import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../core/enum.dart';
import '../widgets/custom_bg_widgets.dart';
import '../widgets/image_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  //final Function(Widget) changeScreen;
  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Stack(
            children: <Widget>[
              const Image(
                width: double.infinity,
                image: AssetImage(DrawableAssets.loginCoveImage),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          left: 50, top: 10, right: 50, bottom: 100),
                      decoration: BackgroundBoxDecoration(
                              context.resources.color.colorWhite,
                              context.resources.color.colorWhite,
                              0,
                              30)
                          .topCornersBox,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ImageWidget(path: DrawableAssets.icLogoTitle)
                              .loadImage,
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            context.string.please_select_language_ar,
                            style: context.textFontWeight900
                                .copyWith(
                                    fontFamily: fontFamilyAR,
                                    fontWeight: FontWeight.w900)
                                .onFontSize(14),
                          ),
                          Text(
                            context.string.please_select_language,
                            style: context.textFontWeight600
                                .copyWith(
                                    fontFamily: fontFamilyEN,
                                    fontWeight: FontWeight.w600)
                                .onFontSize(14),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () => {
                              context.resources
                                  .setLocal(language: LocalEnum.ar.name)
                            },
                            child: CustomBgWidgets().roundedCornerWidget(
                                Center(
                                  child: Text(
                                    context.string.arabic,
                                    style: context.textFontWeight600
                                        .copyWith(
                                            fontFamily: fontFamilyAR,
                                            fontWeight: FontWeight.w600)
                                        .onColor(
                                            context.resources.color.textColor)
                                        .onFontSize(17),
                                  ),
                                ),
                                BackgroundBoxDecoration(
                                        context.resources.color.colorWhite,
                                        context.resources.color.viewBgColor,
                                        1,
                                        10)
                                    .roundedCornerBox,
                                40),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () => {
                              context.resources
                                  .setLocal(language: LocalEnum.en.name)
                            },
                            child: CustomBgWidgets().roundedCornerWidget(
                                Center(
                                  child: Text(
                                    context.string.english,
                                    style: context.textFontWeight900
                                        .copyWith(
                                            fontFamily: fontFamilyEN,
                                            fontWeight: FontWeight.w900)
                                        .onColor(
                                            context.resources.color.colorWhite)
                                        .onFontSize(17),
                                  ),
                                ),
                                BackgroundBoxDecoration(
                                        context.resources.color.viewBgColor,
                                        context.resources.color.viewBgColor,
                                        0,
                                        10)
                                    .roundedCornerBox,
                                40),
                          ),
                        ],
                      ),
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
