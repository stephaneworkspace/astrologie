import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

import './zodiac/s_zodiac_degre_return.dart';

const EXT0 = 30.0;
const EXT1 = 40.0;
const EXT2 = 90.0;
const EXT3 = 130.0;
const CIRC = 360.0;

class DrawAstro extends CustomPainter {
  // Feature : Make a big complete structure for paint
  ZodiacDegreReturn _zodiacDegreReturn;
  DrawAstro(ZodiacDegreReturn zodiacDegreReturn) {
    _zodiacDegreReturn = zodiacDegreReturn;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      /// size.width = 375
      /// size.height = 375
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radiusTotal = min(size.width / 2, size.height / 2);
    double radiusCircleExt0 = radiusTotal - 30.0;
    double radiusCircleExt1 = radiusTotal - 40.0;
    double radiusCircleExt2 = radiusTotal - 90.0;
    double radiusCircleExt3 = radiusTotal - 130.0;
    canvas.drawCircle(center, radiusCircleExt0, paint);
    canvas.drawCircle(center, radiusCircleExt1, paint);
    canvas.drawCircle(center, radiusCircleExt2, paint);
    canvas.drawCircle(center, radiusCircleExt3, paint);
    /*
    /// Trait à partir du centre
    // double x = 2 * pi;
    //double radius = radiusCircleExt3 * 2.0;
    double dx = centre.dx + cos(45 / CIRC * pi) * -1 * Radius.circular(radiusCircleExt3).x;
    double dy = centre.dy + sin(45 / CIRC * pi) * Radius.circular(radiusCircleExt3).y;
    //canvas.drawLine(centre, new Offset(dx, dy), paint);

    Offset centre2 = new Offset(dx, dy);
    double dx2 = centre.dx + cos(45 / CIRC * pi) * -1 * Radius.circular(radiusCircleExt0).x;
    double dy2 = centre.dy + sin(45 / CIRC * pi) * Radius.circular(radiusCircleExt0).y;
    canvas.drawLine(centre2, new Offset(dx2, dy2), paint);*/
    for(var i in _zodiacDegreReturn.zodiac) {
      List<Offset> xy = prepareLineInsideCircle(i.degre0, center, radiusCircleExt3, radiusCircleExt2);
      canvas.drawLine(xy[0], xy[1], paint);

      final String assetName = 'assets/svg/zodiac/belier.svg';
      
      /*final Widget svgIcon = new SvgPicture.asset(
        assetName,
        color: Colors.red,
        semanticsLabel: 'A red up arrow'
      );*/
      


    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  List<Offset> prepareLineInsideCircle(double angular, Offset center, double radiusCircleBegin, double radiusCircleEnd) {
    List<Offset> returnList = [];
    double dx1 = center.dx + cos(angular / CIRC * 2 * pi) * -1 * Radius.circular(radiusCircleBegin).x;
    double dy1 = center.dy + sin(angular / CIRC * 2 * pi) * Radius.circular(radiusCircleBegin).y;
    returnList.add(new Offset(dx1, dy1));
    double dx2 = center.dx + cos(angular / CIRC * 2 * pi) * -1 * Radius.circular(radiusCircleEnd).x;
    double dy2 = center.dy + sin(angular / CIRC * 2 * pi) * Radius.circular(radiusCircleEnd).y;
    returnList.add(new Offset(dx2, dy2));
    return returnList;
  }
}