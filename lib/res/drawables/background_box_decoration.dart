import 'package:flutter/widgets.dart';

class BackgroundBoxDecoration {
  Color boxColor;
  double radious;
  double boarderWidth;
  Color boarderColor;
  BackgroundBoxDecoration(
      this.boxColor, this.boarderColor, this.boarderWidth, this.radious);
  BoxDecoration get roundedCornerBox {
    return BoxDecoration(
        color: boxColor,
        border: Border.all(color: boarderColor, width: boarderWidth),
        borderRadius: BorderRadius.all(Radius.circular(radious)));
  }

  BoxDecoration get topCornersBox {
    return BoxDecoration(
        color: boxColor,
        border: Border.all(color: boarderColor, width: boarderWidth),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radious),
            topRight: Radius.circular(radious)));
  }
}
