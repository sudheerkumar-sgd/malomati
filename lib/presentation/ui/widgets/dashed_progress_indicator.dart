import 'dart:math';

import 'package:flutter/material.dart';
import 'package:malomati/core/common/log.dart';

class DashedProgressIndicator extends CustomPainter {
  final double percent;
  final double strokeWidth;
  final Color color;

  DashedProgressIndicator(
      {this.percent = 0, this.strokeWidth = 5, this.color = Colors.red});

  final paint1 = Paint()
    ..color = const Color.fromARGB(255, 207, 39, 39)
    ..style = PaintingStyle.stroke;

  final paint2 = Paint()
    ..color = const Color.fromARGB(255, 233, 17, 17)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    final dashSize = (size.width * 0.0004) / 2;
    double arcAngle = 1 * pi * dashSize;

    // draw dashes
    var prevPos = (-pi / 2) - .1;
    for (var i = 0; i < 31 * percent; i++) {
      printLog(message: '$prevPos  $dashSize');
      prevPos = prevPos + (i == 0 ? 0 : 0.2);
      canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
          prevPos,
          i % 3 == 1 ? arcAngle / 2 : arcAngle,
          false,
          paint1..strokeWidth = strokeWidth);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
