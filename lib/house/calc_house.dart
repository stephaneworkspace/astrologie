import 'dart:async' show Future;
import 'dart:convert';
import 'dart:ui';
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
        _house.add(new House(i['id'], i['id_by_asc'], i['sign'], i['pos_circle_360'], new Offset(0.0, 0.0)));
      }
    }
  }

  List<House> calcDrawHouse(CalcDraw calcDraw, double size) {
    List<House> z = new List<House>();
    Map<int, House> map = _house.asMap();
    // test null if file don't exist
    if (_house != null) {
      for (var i in _house) {
        // 0° -> to 0° next house
        // 0° -> to 0° next house
        double degreNext = 0.0;
        switch (i.id) {
          case 12:
            degreNext = map[0].posCricle360;
            break;
          default:
            degreNext = map[i.id].posCricle360;
            break;
        }
        double temp = 0.0;
        if (i.posCricle360 > degreNext) {
          temp = 360.0 + degreNext - i.posCricle360;
        } else {
          temp = degreNext - i.posCricle360;
        }
        double degreMid = i.posCricle360 + (temp / 2);
        if (degreMid > 360.0) {
          degreMid -= 360.0;
        }
        Offset xy = calcDraw.getOffsetCenterHouse(size, calcDraw.pointTrigo(degreMid, calcDraw.getRadiusCircleHouse()));
        z.add(new House(i.id, i.idByAsc, i.sign, i.posCricle360, xy));
      }
    }
    return z;
  }
}