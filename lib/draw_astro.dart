import 'dart:ui';

import 'package:flutter/material.dart';

import './zodiac/s_zodiac.dart';
import './draw/calc_draw.dart';
import './draw/e_type_trait.dart';

const EXT0 = 30.0;
const EXT1 = 40.0;
const EXT2 = 90.0;
const EXT3 = 130.0;

class DrawAstro extends CustomPainter {
  // Feature : Make a big complete structure for paint
  List<Zodiac> _zodiac;
  CalcDraw _calcDraw;

  DrawAstro(List<Zodiac> zodiac) {
    _zodiac = zodiac;
  }

  @override
  void paint(Canvas canvas, Size size) {
    _calcDraw = new CalcDraw(size.width, size.height);
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(_calcDraw.getCenter(), _calcDraw.getRadiusCircle(0), paint);
    canvas.drawCircle(_calcDraw.getCenter(), _calcDraw.getRadiusCircle(1), paint);
    canvas.drawCircle(_calcDraw.getCenter(), _calcDraw.getRadiusCircle(2), paint);
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
    for(var i in _zodiac) {
      // 0°
      List<Offset> xy = _calcDraw.lineTrigo(i.posCricle360, _calcDraw.getRadiusCircle(1), _calcDraw.getRadiusCircle(0));
      canvas.drawLine(xy[0], xy[1], paint);
      // 1° -> 29 °
      for (int j = 1; j < 15; j++) {
        var typeTrait = TypeTrait.Petit;
        if (j == 5 || j == 10 || j == 15) {
          typeTrait = TypeTrait.Grand;
        }
        // calc angular
        double angular = i.posCricle360 + j.toDouble() * 2.0;
        if (angular > 360.0) {
          angular -= 360.0;
        }
        xy = _calcDraw.lineTrigo(angular, _calcDraw.getRadiusCircle(1), _calcDraw.getRadiusRulesInsideCircleZodiac(typeTrait));
        canvas.drawLine(xy[0], xy[1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }


}