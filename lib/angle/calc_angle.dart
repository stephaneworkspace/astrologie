import 'dart:async' show Future;
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import '../component/hex_color.dart';
import '../draw/calc_draw.dart';
import 's_angle.dart'; 

class CalcAngle {
  static List<Angle> _angle = new List<Angle>();

  CalcAngle();

  Future parseJson() async {
    _angle.clear();
    Map decoded = jsonDecode(await rootBundle.loadString('assets/data/generated.json'));
    // Order by Asc
    if (decoded != null) {
      for (var i in decoded['angles']) {
        _angle.add(new Angle(i['id'], i['sign'], i['sign_pos'], i['svg'], i['svg_degre'], i['svg_min'], i['pos_circle_360'], new Offset(0.0, 0.0), new Offset(0.0, 0.0), new Offset(0.0, 0.0), HexColor('#7c7459')));
      }
    }
  }

  List<Angle> calcDrawAngle(CalcDraw calcDraw, double sizeAngle, double sizeDegre, double sizeMin) {
    List<Angle> z = new List<Angle>();
    // test null if file don't exist
    if (_angle != null) {
      for (var i in _angle) {
        // 0° todo... colision detector
        Offset xy1 = calcDraw.getOffsetCenterPlanet(sizeAngle, calcDraw.pointTrigo(i.posCricle360, calcDraw.getRadiusCircle(4))); // symbol
        Offset xy2 = calcDraw.getOffsetCenterPlanet(sizeDegre, calcDraw.pointTrigo(i.posCricle360, calcDraw.getRadiusCircle(5))); // °
        Offset xy3 = calcDraw.getOffsetCenterPlanet(sizeDegre, calcDraw.pointTrigo(i.posCricle360, calcDraw.getRadiusCircle(6))); // '
        z.add(new Angle(i.id, i.sign, i.signPos, i.svg, i.svgDegre, i.svgMin, i.posCricle360, xy1, xy2, xy3, i.color));
      }
    }
    return z;
  }
}