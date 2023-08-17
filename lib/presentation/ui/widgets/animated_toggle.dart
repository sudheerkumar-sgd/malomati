// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';

class AnimatedToggle extends StatelessWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;
  final double boxRadious;
  final double textFontSize;
  final int selectedPossition;
  ValueNotifier<bool> initialPosition = ValueNotifier<bool>(true);
  AnimatedToggle({
    super.key,
    required this.values,
    required this.onToggleCallback,
    required this.width,
    required this.height,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.boxRadious = 10,
    this.textFontSize = 11,
    this.selectedPossition = 0,
  });

  @override
  Widget build(BuildContext context) {
    initialPosition.value = selectedPossition == 0;
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            initialPosition.value = !initialPosition.value;
            var index = 0;
            if (!initialPosition.value) {
              index = 1;
            }
            onToggleCallback(index);
          },
          child: Container(
            width: width,
            height: height,
            decoration: BackgroundBoxDecoration(
              boxColor: backgroundColor,
              radious: boxRadious,
            ).roundedCornerBox,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                values.length,
                (index) => Text(
                  values[index],
                  style: context.textFontWeight400
                      .onColor(context.resources.color.textColor)
                      .onFontSize(textFontSize)
                      .copyWith(height: 1),
                ),
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: initialPosition,
            builder: (context, value, widget) {
              return AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.decelerate,
                alignment: value ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: width / 2,
                  height: height - 2,
                  decoration: BackgroundBoxDecoration(
                    boxColor: buttonColor,
                    radious: boxRadious,
                  ).roundedCornerBox,
                  alignment: Alignment.center,
                  child: Text(
                    (value) ? values[0] : values[1],
                    style: context.textFontWeight400
                        .onColor(textColor)
                        .onFontSize(textFontSize)
                        .copyWith(height: 1),
                  ),
                ),
              );
            }),
      ],
    );
  }
}
