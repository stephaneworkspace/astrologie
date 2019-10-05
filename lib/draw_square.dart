import 'dart:ui';

import 'package:flutter/material.dart';


const EXT0 = 30.0;
const EXT1 = 40.0;
const EXT2 = 90.0;
const EXT3 = 130.0;
const CIRC = 360.0;

class DrawSquare extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      /// size.width = 375
      /// size.height = 375
    canvas.drawLine(new Offset(0.0, size.height), new Offset(size.width, 0.0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}