import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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
        _angle.add(new Angle(i['id'], i['sign'], i['sign_pos'], i['svg'], i['pos_circle_360']));
      }
    }
  }

  List<Angle> calcDrawAngle(CalcDraw calcDraw, double size) {
    List<Angle> z = new List<Angle>();
    // test null if file don't exist
    if (_angle != null) {
      for (var i in _angle) {
        // todo, calc of position outside circle
        z.add(new Angle(i.id, i.sign, i.signPos, i.svg, i.posCricle360));
      }
    }
    return z;
  }
}