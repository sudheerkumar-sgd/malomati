import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/widgets/user_app_bar.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../res/drawables/background_box_decoration.dart';
import '../widgets/custom_bg_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: context.resources.color.bottomSheetIconUnSelected,
          body: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    context.resources.color.bgGradientStart,
                    context.resources.color.bgGradientEnd,
                  ],
                )),
                child: Column(
                  children: [
                    SizedBox(
                      height: context.resources.dimen.dp30,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.resources.dimen.dp25),
                      child: UserAppBarWidget(
                        title: context.userDB
                            .get(userFullNameKey, defaultValue: '')
                            .toString(),
                      ),
                    ),
                    SizedBox(
                      height: context.resources.dimen.dp20,
                    ),
                    CustomBgWidgets().roundedCornerWidget(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.resources.dimen.dp10,
                          vertical: 15),
                      margin: EdgeInsets.symmetric(
                        horizontal: context.resources.dimen.dp25,
                      ),
                      widget: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mon, 12 March 2023',
                                    style: context.textFontWeight600.onFontSize(
                                        context.resources.dimen.dp17),
                                  ),
                                  Text(
                                    '09:23:33 AM',
                                    style: context.textFontWeight400.onFontSize(
                                        context.resources.dimen.dp14),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ImageWidget(path: DrawableAssets.icHome).loadImage
                            ],
                          ),
                        ],
                      ),
                      boxDecoration: BackgroundBoxDecoration(
                              boxColor: context.resources.color.colorWhite,
                              radious: context.resources.dimen.dp20)
                          .topCornersBox,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
