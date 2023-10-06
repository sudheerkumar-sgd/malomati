import 'dart:io';

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../res/drawables/background_box_decoration.dart';
import '../widgets/image_widget.dart';
import 'guest_back_app_bar.dart';

class UAQAppsScreen extends StatelessWidget {
  const UAQAppsScreen({super.key});

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
            children: [
              SizedBox(
                height: context.resources.dimen.dp10,
              ),
              GuestBackAppBarWidget(title: context.string.uaqApps),
              SizedBox(
                height: context.resources.dimen.dp40,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      launchAppUrl(Platform.isAndroid
                          ? 'uae.gov.smartuaq'
                          : '1063110068');
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(context.resources.dimen.dp10),
                          decoration: BackgroundBoxDecoration(
                                  boxColor: context.resources.color.colorWhite,
                                  radious: context.resources.dimen.dp10)
                              .roundedCornerBox,
                          child: ImageWidget(
                            path: DrawableAssets.icSmartUaqApp,
                            width: 60,
                            height: 60,
                          ).loadImage,
                        ),
                        SizedBox(
                          height: context.resources.dimen.dp10,
                        ),
                        Text(
                          'Smart UAQ',
                          style: context.textFontWeight400,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: context.resources.dimen.dp50,
                  ),
                  InkWell(
                    onTap: () {
                      launchAppUrl(Platform.isAndroid
                          ? 'com.nvssoft.tarasolsuite'
                          : '1478089710');
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(context.resources.dimen.dp10),
                          decoration: BackgroundBoxDecoration(
                                  boxColor: context.resources.color.colorWhite,
                                  radious: context.resources.dimen.dp10)
                              .roundedCornerBox,
                          child: ImageWidget(
                            path: DrawableAssets.icTarasolSuiteApp,
                            width: 60,
                            height: 60,
                          ).loadImage,
                        ),
                        SizedBox(
                          height: context.resources.dimen.dp10,
                        ),
                        Text(
                          'Tarasol Suite',
                          style: context.textFontWeight400,
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
