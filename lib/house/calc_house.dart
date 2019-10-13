import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../draw/calc_draw.dart';
import 's_house.dart'; 

class CalcHouse {
  static List<House> _house = new List<House>();

  CalcHouse();

  Future parseJson() async {
    _house.clear();
    Map decoded = jsonDecode(await rootBundle.loadString('assets/data/generated.json'));
    // Order by Asc
    if (decoded != null) {
      for (var i in decoded['houses']) {
        _house.add(new House(i['id'], i['id_by_asc'], i['sign'], i['pos_circle_360']));
      }
    }
  }

  List<House> calcDrawZodiac(CalcDraw calcDraw, double size) {
    List<House> z = new List<House>();
    // test null if file don't exist
    if (_house != null) {
      for (var i in _house) {
        /*
        // 0° + 15°
        double degre15 = i.posCricle360 + 15.0;
        if (degre15 > 360.0) {
          degre15 -= 360.0;
        }
        Offset xy = calcDraw.getOffsetCenterZodiac(size, calcDraw.pointTrigo(degre15, calcDraw.getRadiusCircleZodiac()));*/
        z.add(new House(i.id, i.idByAsc, i.sign, i.posCricle360));
      }
    }
    return z;
  }
}