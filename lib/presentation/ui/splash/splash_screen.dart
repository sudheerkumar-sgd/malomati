import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malomati/config/app_routes.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../core/enum.dart';
import '../widgets/custom_bg_widgets.dart';
import '../widgets/image_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
  }

  void _onLanguageSelected(BuildContext context, LocalEnum language) {
    if (_isNavigating) return;
    _isNavigating = true;
    context.resources.setLocal(language: language.name);
    context.settingDB.put(isSplashDoneKey, true);
    Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          const Align(
            alignment: Alignment.topCenter,
            child: Image(
              width: double.infinity,
              fit: BoxFit.fill,
              image: AssetImage(DrawableAssets.loginCoveImage),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: context.resources.dimen.dp50,
                      top: context.resources.dimen.dp10,
                      right: context.resources.dimen.dp50,
                      bottom: context.resources.dimen.dp100),
                  decoration: BackgroundBoxDecoration(
                          boxColor: context.resources.color.colorWhite,
                          radious: context.resources.dimen.dp30)
                      .topCornersBox,
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.resources.dimen.dp10,
                      ),
                      ImageWidget(path: DrawableAssets.icLogoTitle).loadImage,
                      SizedBox(
                        height: context.resources.dimen.dp50,
                      ),
                      Text(
                        context.string.please_select_language_ar,
                        style: context.textFontWeight900.copyWith(
                            fontFamily: fontFamilyAR,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(
                        context.string.please_select_language,
                        style: context.textFontWeight600.copyWith(
                            fontFamily: fontFamilyEN,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp30,
                      ),
                      InkWell(
                        onTap: () {
                          _onLanguageSelected(context, LocalEnum.ar);
                        },
                        child: CustomBgWidgets().roundedCornerWidget(
                            widget: Center(
                              child: Text(
                                context.string.arabic,
                                style: context.textFontWeight600
                                    .copyWith(
                                        fontFamily: fontFamilyAR,
                                        fontWeight: FontWeight.w600)
                                    .onColor(context.resources.color.textColor)
                                    .onFontSize(
                                        context.resources.fontSize.dp17),
                              ),
                            ),
                            boxDecoration: BackgroundBoxDecoration(
                                    boxColor:
                                        context.resources.color.colorWhite,
                                    boarderColor:
                                        context.resources.color.viewBgColor,
                                    boarderWidth: context.resources.dimen.dp1,
                                    radious: context.resources.dimen.dp10)
                                .roundedCornerBox,
                            height: context.resources.dimen.dp40),
                      ),
                      SizedBox(
                        height: context.resources.dimen.dp15,
                      ),
                      InkWell(
                        onTap: () {
                          _onLanguageSelected(context, LocalEnum.en);
                        },
                        child: CustomBgWidgets().roundedCornerWidget(
                            widget: Center(
                              child: Text(
                                context.string.english,
                                style: context.textFontWeight600
                                    .copyWith(
                                        fontFamily: fontFamilyEN,
                                        fontWeight: FontWeight.w600)
                                    .onColor(context.resources.color.colorWhite)
                                    .onFontSize(
                                        context.resources.fontSize.dp17),
                              ),
                            ),
                            boxDecoration: BackgroundBoxDecoration(
                                    boxColor:
                                        context.resources.color.viewBgColor,
                                    radious: context.resources.dimen.dp10)
                                .roundedCornerBox,
                            height: context.resources.dimen.dp40),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
