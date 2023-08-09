import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;
  final double width;
  final double height;
  final int selectedPossition;

  const AnimatedToggle({
    super.key,
    required this.values,
    required this.onToggleCallback,
    required this.width,
    required this.height,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
    this.selectedPossition = 0,
  });
  @override
  AnimatedToggleState createState() => AnimatedToggleState();
}

class AnimatedToggleState extends State<AnimatedToggle> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            final initialPosition = !(widget.selectedPossition == 0);
            var index = 0;
            if (!initialPosition) {
              index = 1;
            }
            widget.onToggleCallback(index);
            setState(() {});
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BackgroundBoxDecoration(
              boxColor: widget.backgroundColor,
              radious: context.resources.dimen.dp10,
            ).roundedCornerBox,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                widget.values.length,
                (index) => Text(
                  widget.values[index],
                  style: context.textFontWeight400
                      .onColor(context.resources.color.textColor)
                      .onFontSize(context.resources.dimen.dp11),
                ),
              ),
            ),
          ),
        ),
        AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: context.resources.isLocalEn
              ? ((widget.selectedPossition == 0)
                  ? Alignment.centerLeft
                  : Alignment.centerRight)
              : ((widget.selectedPossition == 0)
                  ? Alignment.centerRight
                  : Alignment.centerLeft),
          child: Container(
            margin: EdgeInsets.all(context.resources.dimen.dp1),
            width: widget.width / 2,
            height: widget.height - 2,
            decoration: BackgroundBoxDecoration(
              boxColor: widget.buttonColor,
              radious: context.resources.dimen.dp10,
            ).roundedCornerBox,
            alignment: Alignment.center,
            child: Text(
              (widget.selectedPossition == 0)
                  ? widget.values[0]
                  : widget.values[1],
              style: context.textFontWeight400
                  .onColor(widget.textColor)
                  .onFontSize(context.resources.dimen.dp11),
            ),
          ),
        ),
      ],
    );
  }
}
