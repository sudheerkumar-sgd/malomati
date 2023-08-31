import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';

import '../../../res/drawables/background_box_decoration.dart';

class TabsButtonsWidget extends StatelessWidget {
  final ValueNotifier<int> selectedIndex;
  final List<String> buttons;
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
              (index) => Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                  ),
                  child: InkWell(
                    onTap: () {
                      selectedIndex.value = index;
                    },
                    child: Container(
                      margin: isLocalEn
                          ? EdgeInsets.only(
                              left: index > 0 ? resources.dimen.dp10 : 0,
                              right: index < buttons.length - 1
                                  ? resources.dimen.dp10
                                  : 0,
                            )
                          : EdgeInsets.only(
                              right: index > 0 ? resources.dimen.dp10 : 0,
                              left: index < buttons.length - 1
                                  ? resources.dimen.dp10
                                  : 0,
                            ),
                      padding: EdgeInsets.symmetric(
                          vertical: resources.dimen.dp5,
                          horizontal: context.resources.dimen.dp10),
                      decoration: BackgroundBoxDecoration(
                        boxColor: value == index
                            ? context.resources.color.bgGradientStart
                            : context.resources.color.colorF5C3C3,
                        radious: context.resources.dimen.dp10,
                      ).roundedCornerBox,
                      child: Text(
                        buttons[index],
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: context.textFontWeight400
                            .onColor(context.resources.color.colorWhite)
                            .onFontSize(context.resources.dimen.dp15),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
