import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class ImageWidget {
  String path;
  double? width;
  double? height;
  BoxFit? boxType;
  Color? backgroundTint;
  EdgeInsetsGeometry padding;
  final bool isLocalEn;
  ImageWidget(
      {required this.path,
      this.width,
      this.height,
      this.boxType,
      this.backgroundTint,
      this.padding = const EdgeInsets.all(5),
      this.isLocalEn = true});

  Widget get loadImage =>
      RotatedBox(quarterTurns: isLocalEn ? 0 : 2, child: getImage());

  Widget get loadImageWithMoreTapArea => getImageWithMoreTapArea();

  Widget getImage() {
    {
      if (path.contains("http://") || path.contains("https://")) {
        return Image.network(path);
      } else if (path.contains('assets/')) {
        if (path.contains(".svg")) {
          return SvgPicture.asset(
            path,
            width: width,
            height: height,
            fit: boxType ?? BoxFit.contain,
            color: backgroundTint,
          );
        } else {
          return Image.asset(path);
        }
      } else {
        return Image.file(File(path));
      }
    }
  }

  Widget getImageWithMoreTapArea() {
    {
      return Padding(
        padding: padding,
        child: getImage(),
      );
    }
  }
}
