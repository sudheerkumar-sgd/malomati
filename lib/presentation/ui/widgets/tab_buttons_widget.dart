import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

import '../../../res/drawables/background_box_decoration.dart';

class TabsButtonsWidget extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;
  final List<Map> buttons;
  const TabsButtonsWidget(
      {required this.buttons, required this.selectedIndex, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, value, widget) {
          return Row(
            children: List.generate(
              buttons.length,
              (index) {
                final name = buttons[index]['name'];
                final count = buttons[index]['count'] ?? 0;
                return Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: double.infinity,
                    ),
                    child: InkWell(
                      onTap: () {
                        selectedIndex.value = index;
                      },
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Container(
                            margin: isLocalEn
                                ? EdgeInsets.only(
                                    left: index > 0 ? resources.dimen.dp10 : 0,
                                    right: index < buttons.length - 1
                                        ? count > 0
                                            ? resources.dimen.dp5
                                            : resources.dimen.dp10
                                        : count > 0
                                            ? resources.dimen.dp5
                                            : 0,
                                    top: resources.dimen.dp10)
                                : EdgeInsets.only(
                                    right: index > 0 ? resources.dimen.dp10 : 0,
                                    left: index < buttons.length - 1
                                        ? count > 0
                                            ? resources.dimen.dp5
                                            : resources.dimen.dp10
                                        : count > 0
                                            ? resources.dimen.dp5
                                            : 0,
                                    top: resources.dimen.dp10),
                            padding: EdgeInsets.symmetric(
                                vertical: resources.dimen.dp5,
                                horizontal: context.resources.dimen.dp10),
                            decoration: BackgroundBoxDecoration(
                              boxColor: value == index
                                  ? context.resources.color.viewBgColorLight
                                  : context.resources.color.colorF5C3C3,
                              radious: context.resources.dimen.dp10,
                            ).roundedCornerBox,
                            child: Text(
                              name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: context.textFontWeight400
                                  .onColor(context.resources.color.colorWhite)
                                  .onFontSize(context.resources.fontSize.dp15),
                            ),
                          ),
                          Align(
                              alignment: isLocalEn
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Visibility(
                                visible: count > 0,
                                child: Container(
                                  width: resources.dimen.dp20,
                                  height: resources.dimen.dp20,
                                  decoration: ShapeDecoration(
                                      shape: const CircleBorder(),
                                      color: resources.color.bgGradientEnd),
                                  child: Text('$count',
                                      textAlign: TextAlign.center,
                                      style: context.textFontWeight600
                                          .onColor(context
                                              .resources.color.colorWhite)
                                          .onFontFamily(
                                              fontFamily: fontFamilyEN)
                                          .onFontSize(
                                              context.resources.fontSize.dp13)),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
