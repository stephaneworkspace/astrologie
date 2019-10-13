import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../draw/calc_draw.dart';
import '../element/s_el.dart';
import 's_zodiac.dart'; 

class CalcZodiac {
  static List<Zodiac> _zodiac = new List<Zodiac>();

  CalcZodiac();

  Future parseJson() async {
    _zodiac.clear();
    Map decoded = jsonDecode(await rootBundle.loadString('assets/data/generated.json'));
    // Order by Asc
    for (var i in decoded['zodiac']) {
      Color color = Colors.black;
      switch(i['element']) {
        case 'Feu':
          color = Colors.red;
          break;
        case 'Terre':
          color = Colors.orange;
          break;
        case 'Air':
          color = Colors.green;
          break;
        case 'Eau':
          color = Colors.blue;
          break;
      }
      _zodiac.add(new Zodiac(i['id'], i['id_by_asc'], i['sign'], i['symbol'], new El(i['element'], color), i['svg'], i['pos_circle_360'], new Offset(0.0, 0.0)));
    }
  }

  List<Zodiac> calcDrawZodiac(CalcDraw calcDraw, double size) {
    List<Zodiac> z = new List<Zodiac>();
    // test null if file don't exist
    if (_zodiac != null) {
      for (var i in _zodiac) {
        // 0° + 15°
        double degre15 = i.posCricle360 + 15.0;
        if (degre15 > 360.0) {
          degre15 -= 360.0;
        }
        Offset xy = calcDraw.getOffsetCenterZodiac(size, calcDraw.pointTrigo(degre15, calcDraw.getRadiusCircleZodiac()));
        z.add(new Zodiac(i.id, i.idByAsc, i.sign, i.symbol, i.element, i.svg, i.posCricle360, xy));
      }
    }
    return z;
  }
}