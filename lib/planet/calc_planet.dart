import 'dart:async' show Future;
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import '../component/hex_color.dart';
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
        Color c;
        switch (i['id']) {
          case 'Soleil':
            c = HexColor('#d79a3f');
            break;
          case 'Lune':
            c = HexColor('#a78500');
            break;
          case 'Mercure':
            c = HexColor('#755175');
            break;
          case 'Venus':
            c = HexColor('#c55d81');
            break;
          case 'Mars':
            c = HexColor('#bd3036');
            break;
          case 'Jupiter':
            c = HexColor('#478c89');
            break;
          case 'Saturne':
            c = HexColor('#b44b45');
            break;
          case 'Uranus':
            c = HexColor('#895349');
            break;
          case 'Neptune':
            c = HexColor('#5e6d59');
            break;
          case 'Pluton':
            c = HexColor('#db5053');
            break;
          case 'Chiron':
          case 'Noeud nord':
          case 'Noeud sud':
          case 'Part de fortune':
            c = HexColor('#7c7459');
            break;
          default:
            c = HexColor('#000000');
        }
        _angle.add(new Planet(i['id'], i['sign'], i['sign_pos'], i['svg'], i['svg_degre'], i['svg_min'], i['pos_circle_360'], new Offset(0.0, 0.0), new Offset(0.0, 0.0), new Offset(0.0, 0.0), c));
      }
    }
  }

  List<Planet> calcDrawPlanet(CalcDraw calcDraw, double sizePlanet, double sizeDegre, double sizeMin) {
    List<Planet> z = new List<Planet>();
    // test null if file don't exist
    if (_angle != null) {
      for (var i in _angle) {
        // 0° todo... colision detector
        Offset xy1 = calcDraw.getOffsetCenterPlanet(sizePlanet, calcDraw.pointTrigo(i.posCricle360, calcDraw.getRadiusCircle(4))); // symbol
        Offset xy2 = calcDraw.getOffsetCenterPlanet(sizeDegre, calcDraw.pointTrigo(i.posCricle360, calcDraw.getRadiusCircle(5))); // °
        Offset xy3 = calcDraw.getOffsetCenterPlanet(sizeMin, calcDraw.pointTrigo(i.posCricle360, calcDraw.getRadiusCircle(6))); // '
        // todo, calc of position outside circle with text
        z.add(new Planet(i.id, i.sign, i.signPos, i.svg, i.svgDegre, i.svgMin, i.posCricle360, xy1, xy2, xy3, i.color));
      }
    }
    return z;
  }
}