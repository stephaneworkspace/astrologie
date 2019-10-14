import 'dart:async' show Future;
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import '../draw/calc_draw.dart';
import 's_planet.dart'; 

class CalcPlanet {
  static List<Planet> _angle = new List<Planet>();

  CalcPlanet();

  Future parseJson() async {
    _angle.clear();
    Map decoded = jsonDecode(await rootBundle.loadString('assets/data/generated.json'));
    // Order by Asc
    if (decoded != null) {
      for (var i in decoded['planets']) {
        _angle.add(new Planet(i['id'], i['sign'], i['sign_pos'], i['svg'], i['svg_degre'], i['pos_circle_360'], new Offset(0.0, 0.0)));
      }
    }
  }

  List<Planet> calcDrawPlanet(CalcDraw calcDraw, double size) {
    List<Planet> z = new List<Planet>();
    // test null if file don't exist
    if (_angle != null) {
      for (var i in _angle) {
        // 0° todo... colision detector
        Offset xy = calcDraw.getOffsetCenterPlanet(size, calcDraw.pointTrigo(i.posCricle360, calcDraw.getRadiusCircle(4)));
        // todo, calc of position outside circle with text
        z.add(new Planet(i.id, i.sign, i.signPos, i.svg, i.svgDegre, i.posCricle360, xy));
      }
    }
    return z;
  }
}