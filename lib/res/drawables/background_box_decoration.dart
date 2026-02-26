import 'package:flutter/material.dart';

class BackgroundBoxDecoration {
  Color? boxColor;
  double? radious;
  double? boarderWidth;
  Color? boarderColor;
  Color? shadowColor;
  double? shadowBlurRadius;
  Offset? shadowOffset;
  Alignment? gradientBegin;
  Alignment? gradientEnd;
  List<Color>? gradientColors;
  BackgroundBoxDecoration(
      {this.boxColor,
      this.boarderColor,
      this.boarderWidth,
      this.radious,
      this.shadowColor,
      this.shadowBlurRadius,
      this.shadowOffset,
      this.gradientBegin,
      this.gradientEnd,
      this.gradientColors});
  BoxDecoration get roundedCornerBox {
    return BoxDecoration(
        color: boxColor,
        border: Border.all(
            color: boarderColor ?? const Color(0x00000000),
            width: boarderWidth ?? 0),
        borderRadius: BorderRadius.all(Radius.circular(radious ?? 4)));
  }

  BoxDecoration get topCornersBox {
    return BoxDecoration(
        color: boxColor,
        border: Border.all(
            color: boarderColor ?? const Color(0x00000000),
            width: boarderWidth ?? 0),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radious ?? 4),
            topRight: Radius.circular(radious ?? 4)));
  }

  BoxDecoration get bottomCornersBox {
    return BoxDecoration(
        color: boxColor,
        border: Border.all(
            color: boarderColor ?? const Color(0x00000000),
            width: boarderWidth ?? 0),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(radious ?? 4),
            bottomRight: Radius.circular(radious ?? 4)));
  }

  BoxDecoration get rightCornersBox {
    return BoxDecoration(
        color: boxColor,
        border: Border.all(
            color: boarderColor ?? const Color(0x00000000),
            width: boarderWidth ?? 0),
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(radious ?? 4),
            topRight: Radius.circular(radious ?? 4)));
  }

  BoxDecoration get leftCornersBox {
    return BoxDecoration(
        color: boxColor,
        border: Border.all(
            color: boarderColor ?? const Color(0x00000000),
            width: boarderWidth ?? 0),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(radious ?? 4),
            topLeft: Radius.circular(radious ?? 4)));
  }

  BoxDecoration get bottomCornersBoxWithShadow {
    return bottomCornersBox.copyWith(
      boxShadow: kElevationToShadow[5],
    );
  }

  BoxDecoration get roundedCornerBoxWithShadow {
    return roundedCornerBox.copyWith(
      boxShadow: [
        BoxShadow(
          color: shadowColor ?? const Color(0x00000000),
          blurRadius: shadowBlurRadius ?? 0,
          offset: shadowOffset ?? Offset.zero, // Shadow position
        ),
      ],
    );
  }

  BoxDecoration get roundedBoxWithShadow {
    return roundedCornerBox.copyWith(boxShadow: kElevationToShadow[2]);
  }

  BoxDecoration get circularBox {
    return BoxDecoration(
        color: boxColor,
        border: Border.all(
            color: boarderColor ?? const Color(0x00000000),
            width: boarderWidth ?? 0),
        shape: BoxShape.circle);
  }

  BoxDecoration get gradientBox {
    return BoxDecoration(gradient: gradientLinear);
  }

  BoxDecoration get roundedCornerGradientBox {
    return roundedCornerBox.copyWith(gradient: gradientLinear);
  }

  BoxDecoration get topCornerGradientBox {
    return topCornersBox.copyWith(gradient: gradientLinear);
  }

  BoxDecoration get bottomCornerGradientBox {
    return bottomCornersBox.copyWith(gradient: gradientLinear);
  }

  LinearGradient get gradientLinear {
    return LinearGradient(
      begin:
          gradientBegin ?? Alignment.topLeft, // starting point of the gradient
      end: gradientEnd ?? Alignment.bottomRight, // ending point of the gradient
      colors: gradientColors ??
          [
            Color(0xFF131A46), // first color
            Color(0xFF065796), // second color
          ],
    );
  }
}
