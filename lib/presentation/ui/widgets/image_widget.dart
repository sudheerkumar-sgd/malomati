import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class ImageWidget {
  String path;
  double? width;
  double? height;
  BoxFit? boxType;
  Color? backgroundTint;
  ImageWidget(
      {required this.path,
      this.width,
      this.height,
      this.boxType,
      this.backgroundTint});
  Widget get loadImage => getImage();

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
}
