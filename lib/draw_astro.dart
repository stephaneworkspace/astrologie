import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

const EXT0 = 30.0;
const EXT1 = 40.0;
const EXT2 = 90.0;
const EXT3 = 130.0;
const CIRC = 360.0;

class DrawAstro extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      /// size.width = 375
      /// size.height = 375
    Offset centre = new Offset(size.width / 2, size.height / 2);
    double radiusTotal = min(size.width / 2, size.height / 2);
    double radiusCircleExt0 = radiusTotal - 30.0;
    double radiusCircleExt1 = radiusTotal - 40.0;
    double radiusCircleExt2 = radiusTotal - 90.0;
    double radiusCircleExt3 = radiusTotal - 130.0;
    canvas.drawCircle(centre, radiusCircleExt0, paint);
    canvas.drawCircle(centre, radiusCircleExt1, paint);
    canvas.drawCircle(centre, radiusCircleExt2, paint);
    canvas.drawCircle(centre, radiusCircleExt3, paint);
    /// Trait à partir du centre
    double x = 2 * pi;
    //double radius = radiusCircleExt3 * 2.0;
    double dx = centre.dx + cos(45 / CIRC * pi) * -1 * Radius.circular(radiusCircleExt3).x;
    double dy = centre.dy + sin(45 / CIRC * pi) * Radius.circular(radiusCircleExt3).y;
    //canvas.drawLine(centre, new Offset(dx, dy), paint);

    Offset centre2 = new Offset(dx, dy);
    double dx2 = centre.dx + cos(45 / CIRC * pi) * -1 * Radius.circular(radiusCircleExt0).x;
    double dy2 = centre.dy + sin(45 / CIRC * pi) * Radius.circular(radiusCircleExt0).y;
    canvas.drawLine(centre2, new Offset(dx2, dy2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}