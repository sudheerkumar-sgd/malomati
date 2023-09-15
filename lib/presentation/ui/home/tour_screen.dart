// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../res/drawables/background_box_decoration.dart';

class TourScreen extends StatelessWidget {
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  ValueNotifier<int> selectedButtonIndex = ValueNotifier<int>(0);

  TourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final pageController = PageController(
      initialPage: _currentPage.value,
    );
    final tourImages = [
      {
        'title': context.string.welcome,
        'description': context.string.welcomeTourDescription,
        'image': DrawableAssets.homePageOverly
      },
      {
        'title': context.string.attendanceTourTitle,
        'description': context.string.attendanceTourDescription,
        'image': DrawableAssets.homePageOverly1
      },
      {
        'title': context.string.dashboardTourTitle,
        'description': context.string.dashboardTourDescription,
        'image': DrawableAssets.homePageOverly2
      },
      {
        'title': context.string.appBarTourTitle,
        'description': context.string.appBarTourDescription,
        'image': DrawableAssets.homePageOverly3
      },
      {
        'title': context.string.favouriteTourTitle,
        'description': context.string.favouriteTourDescription,
        'image': DrawableAssets.homePageOverly4
      },
      {
        'title': context.string.requestsTourTitle,
        'description': context.string.requestsTourDescription,
        'image': DrawableAssets.homePageOverly5
      },
    ];
    context.userDB.put(appTourKey, true);
    //getTopSafeAreaHeight(context);
    final screenSize = getScrrenSize(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Stack(
          fit: StackFit.passthrough,
          children: [
            PageView(
              controller: pageController,
              reverse: !isLocalEn,
              children: [
                for (int i = 0; i < tourImages.length; i++) ...[
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      ImageWidget(
                              path: DrawableAssets.homePage,
                              boxType: BoxFit.fill)
                          .loadImage,
                      ImageWidget(
                              path: tourImages[i]['image'] ?? '',
                              boxType: BoxFit.fill)
                          .loadImage,
                    ],
                  )
                ]
              ],
              onPageChanged: (value) {
                _currentPage.value = value;
              },
            ),
            ValueListenableBuilder(
                valueListenable: _currentPage,
                builder: (context, value, child) {
                  double margin = 300.0;
                  Alignment alignment = Alignment.topCenter;
                  Alignment tooltipAlignment = Alignment.topCenter;
                  bool bottomTooltipShow = false;
                  switch (value) {
                    case 0:
                      {
                        margin = screenSize.height * .13;
                        alignment = Alignment.topLeft;
                      }
                    case 1:
                      {
                        margin = screenSize.height * .35;
                        alignment = Alignment.topCenter;
                      }
                    case 2:
                      {
                        margin = screenSize.height * .63;
                        alignment = Alignment.topCenter;
                      }
                    case 3:
                      {
                        margin = screenSize.height * .14;
                        alignment = Alignment.topRight;
                        tooltipAlignment = Alignment.topRight;
                      }
                    case 4:
                      {
                        margin = screenSize.height * .45;
                        alignment = Alignment.topRight;
                        bottomTooltipShow = true;
                      }
                    case 5:
                      {
                        margin = screenSize.height * .74;
                        alignment = Alignment.topRight;
                        bottomTooltipShow = true;
                      }
                  }
                  return Align(
                    alignment: alignment,
                    child: Container(
                      width: 250,
                      margin: EdgeInsets.only(
                          top: margin,
                          left: resources.dimen.dp20,
                          right: resources.dimen.dp25),
                      child: Column(
                        children: [
                          Align(
                            alignment: tooltipAlignment,
                            child: Visibility(
                              visible: !bottomTooltipShow && value > 0,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: resources.dimen.dp25),
                                child: ImageWidget(
                                  path: DrawableAssets.icToolTip,
                                ).loadImage,
                              ),
                            ),
                          ),
                          Container(
                            width: 250,
                            padding: EdgeInsets.all(
                              resources.dimen.dp15,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                // one or both
                                color: context.resources.color.colorWhite,
                                width: 0.0,
                              ),
                              color: context.resources.color.colorWhite,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  context.resources.dimen.dp10)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tourImages[value]['title'] ?? '',
                                  style: context.textFontWeight600.onFontSize(
                                      context.resources.fontSize.dp12),
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp10,
                                ),
                                Text(
                                  tourImages[value]['description'] ?? '',
                                  style: context.textFontWeight400.onFontSize(
                                      context.resources.fontSize.dp10),
                                ),
                                SizedBox(
                                  height: context.resources.dimen.dp20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Visibility(
                                        visible: value > 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            _currentPage.value =
                                                (_currentPage.value - 1);
                                            pageController.animateToPage(
                                                _currentPage.value,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: Curves.linear);
                                          },
                                          child: Container(
                                            margin: isLocalEn
                                                ? EdgeInsets.only(
                                                    right: resources.dimen.dp10,
                                                  )
                                                : EdgeInsets.only(
                                                    left: resources.dimen.dp10),
                                            padding: EdgeInsets.symmetric(
                                              vertical: resources.dimen.dp5,
                                            ),
                                            decoration: BackgroundBoxDecoration(
                                              boxColor: context.resources.color
                                                  .bgGradientStart,
                                              radious:
                                                  context.resources.dimen.dp10,
                                            ).roundedCornerBox,
                                            child: Text(
                                              context.string.prev,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.textFontWeight400
                                                  .onColor(context.resources
                                                      .color.colorWhite)
                                                  .onFontSize(context
                                                      .resources.fontSize.dp12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _currentPage.value =
                                              (_currentPage.value + 1);
                                          pageController.animateToPage(
                                              _currentPage.value,
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              curve: Curves.linear);
                                        },
                                        child: Visibility(
                                          visible:
                                              value < tourImages.length - 1,
                                          child: Container(
                                            margin: isLocalEn
                                                ? EdgeInsets.only(
                                                    right: resources.dimen.dp10,
                                                  )
                                                : EdgeInsets.only(
                                                    left: resources.dimen.dp10),
                                            padding: EdgeInsets.symmetric(
                                              vertical: resources.dimen.dp5,
                                            ),
                                            decoration: BackgroundBoxDecoration(
                                              boxColor: context.resources.color
                                                  .bgGradientStart,
                                              radious:
                                                  context.resources.dimen.dp10,
                                            ).roundedCornerBox,
                                            child: Text(
                                              context.string.next,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.textFontWeight400
                                                  .onColor(context.resources
                                                      .color.colorWhite)
                                                  .onFontSize(context
                                                      .resources.fontSize.dp12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Phoenix.rebirth(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: resources.dimen.dp5,
                                          ),
                                          decoration: BackgroundBoxDecoration(
                                            boxColor: context.resources.color
                                                .bgGradientStart,
                                            radious:
                                                context.resources.dimen.dp10,
                                          ).roundedCornerBox,
                                          child: Text(
                                            value == tourImages.length - 1
                                                ? context.string.done
                                                : context.string.endTour,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.textFontWeight400
                                                .onColor(context
                                                    .resources.color.colorWhite)
                                                .onFontSize(context
                                                    .resources.fontSize.dp12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Align(
                            alignment: tooltipAlignment,
                            child: Visibility(
                              visible: bottomTooltipShow,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: resources.dimen.dp25),
                                child: ImageWidget(
                                  path: DrawableAssets.icToolTip,
                                  isLocalEn: false,
                                ).loadImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
