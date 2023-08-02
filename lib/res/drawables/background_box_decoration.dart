import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BackgroundBoxDecoration {
  Color? boxColor;
  double? radious;
  double? boarderWidth;
  Color? boarderColor;
  Color? shadowColor;
  double? shadowBlurRadius;
  Offset? shadowOffset;
  BackgroundBoxDecoration(
      {this.boxColor,
      this.boarderColor,
      this.boarderWidth,
      this.radious,
      this.shadowColor,
      this.shadowBlurRadius,
      this.shadowOffset});
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
}
