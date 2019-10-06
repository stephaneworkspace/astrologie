import 'dart:async' show Future;
import 'dart:convert';
import 'package:astrologie/zodiac/s_zodiac_svg_return.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import './s_zodiac_degre_return.dart';
import './s_zodiac_degre.dart';
import '../draw/calc_draw.dart';

// struct
class Element {
  final String name;
  final Color color;
  const Element(this.name, this.color);
}

// struct
class Zodiac {
  final int id;
  final int idByAsc;
  final String name;
  final String symbol;
  final Element element;
  final String svg;
  const Zodiac(this.id, this.idByAsc, this.name, this.symbol, this.element, this.svg);
}

class CalcZodiac {
  static double _degreAsc;
  static int _signAsc;
  static List<Zodiac> _zodiac;
  
  CalcZodiac(double degreAsc, int signAsc) {
    _setAsc(degreAsc, signAsc);
  }

  void _setAsc(double degreAsc, int signAsc) {
    _degreAsc = degreAsc;
    _signAsc = signAsc;
  }

  Future<String> _setJson() async {
    return await rootBundle.loadString('assets/data/zodiac.json');
  }

  Future setJson() async {
    String jsonString = await _setJson();
    _parseJson(jsonString);
  }

  void _parseJson(String jsonString) {
    List<Zodiac> data = new List<Zodiac>();
    Map decoded = jsonDecode(jsonString);
    int idByAsc = _signAsc;
    // Order by Asc
    for (var i in decoded['data']) {
      switch (_signAsc) {
        case 1:
          idByAsc = i['id'];
          break;
        case 2:
          switch(i['id']) {
            case 2:
              idByAsc = 1;
              break;
            case 3:
              idByAsc = 2;
              break;
            case 4:
              idByAsc = 3;
              break;
            case 5:
              idByAsc = 4;
              break;
            case 6:
              idByAsc = 5;
              break;
            case 7:
              idByAsc = 6;
              break;
            case 8:
              idByAsc = 7;
              break;
            case 9:
              idByAsc = 8;
              break;
            case 10:
              idByAsc = 9;
              break;
            case 11:
              idByAsc = 10;
              break;
            case 12:
              idByAsc = 11;
              break;
            default:
              idByAsc = 11 + i['id'];
              break;
          }
          break;
        case 3:
          switch(i['id']) {
            case 3:
              idByAsc = 1;
              break;
            case 4:
              idByAsc = 2;
              break;
            case 5:
              idByAsc = 3;
              break;
            case 6:
              idByAsc = 4;
              break;
            case 7:
              idByAsc = 5;
              break;
            case 8:
              idByAsc = 6;
              break;
            case 9:
              idByAsc = 7;
              break;
            case 10:
              idByAsc = 8;
              break;
            case 11:
              idByAsc = 9;
              break;
            case 12:
              idByAsc = 10;
              break;
            default:
              idByAsc = 10 + i['id'];
              break;
          }
          break;
        case 4:
          switch(i['id']) {
            case 4:
              idByAsc = 1;
              break;
            case 5:
              idByAsc = 2;
              break;
            case 6:
              idByAsc = 3;
              break;
            case 7:
              idByAsc = 4;
              break;
            case 8:
              idByAsc = 5;
              break;
            case 9:
              idByAsc = 6;
              break;
            case 10:
              idByAsc = 7;
              break;
            case 11:
              idByAsc = 8;
              break;
            case 12:
              idByAsc = 9;
              break;
            default:
              idByAsc = 9 + i['id'];
              break;
          }
          break;
        case 5:
          switch(i['id']) {
            case 5:
              idByAsc = 1;
              break;
            case 6:
              idByAsc = 2;
              break;
            case 7:
              idByAsc = 3;
              break;
            case 8:
              idByAsc = 4;
              break;
            case 9:
              idByAsc = 5;
              break;
            case 10:
              idByAsc = 6;
              break;
            case 11:
              idByAsc = 7;
              break;
            case 12:
              idByAsc = 8;
              break;
            default:
              idByAsc = 8 + i['id'];
              break;
          }
          break;
        case 6:
          switch(i['id']) {
            case 6:
              idByAsc = 1;
              break;
            case 7:
              idByAsc = 2;
              break;
            case 8:
              idByAsc = 3;
              break;
            case 9:
              idByAsc = 4;
              break;
            case 10:
              idByAsc = 5;
              break;
            case 11:
              idByAsc = 6;
              break;
            case 12:
              idByAsc = 7;
              break;
            default:
              idByAsc = 7 + i['id'];
              break;
          }
          break;
        case 7:
          switch(i['id']) {
            case 7:
              idByAsc = 1;
              break;
            case 8:
              idByAsc = 2;
              break;
            case 9:
              idByAsc = 3;
              break;
            case 10:
              idByAsc = 4;
              break;
            case 11:
              idByAsc = 5;
              break;
            case 12:
              idByAsc = 6;
              break;
            default:
              idByAsc = 6 + i['id'];
              break;
          }
          break;
        case 8:
          switch(i['id']) {
            case 8:
              idByAsc = 1;
              break;
            case 9:
              idByAsc = 2;
              break;
            case 10:
              idByAsc = 3;
              break;
            case 11:
              idByAsc = 4;
              break;
            case 12:
              idByAsc = 5;
              break;
            default:
              idByAsc = 5 + i['id'];
              break;
          }
          break;
        case 9:
          switch(i['id']) {
            case 9:
              idByAsc = 1;
              break;
            case 10:
              idByAsc = 2;
              break;
            case 11:
              idByAsc = 3;
              break;
            case 12:
              idByAsc = 4;
              break;
            default:
              idByAsc = 4 + i['id'];
              break;
          }
          break;
        case 10:
          switch(i['id']) {
            case 10:
              idByAsc = 1;
              break;
            case 11:
              idByAsc = 2;
              break;
            case 12:
              idByAsc = 3;
              break;
            default:
              idByAsc = 3 + i['id'];
              break;
          }
          break;
        case 11:
          switch(i['id']) {
            case 11:
              idByAsc = 1;
              break;
            case 12:
              idByAsc = 2;
              break;
            default:
              idByAsc = 2 + i['id'];
              break;
          }
          break;
        case 12:
          switch(i['id']) {
            case 12:
              idByAsc = 1;
              break;
            default:
              idByAsc = 1 + i['id'];
              break;
          }
          break;
      }
      Color color = Colors.black;
      switch(i['element']) {
        case 'Feu':
          color = Colors.red;
          break;
        case 'Terre':
          color = Colors.deepOrange;
          break;
        case 'Air':
          color = Colors.green;
          break;
        case 'Eau':
          color = Colors.blue;
          break;
      }
      data.add(new Zodiac(i['id'], idByAsc, i['sign'], i['symbol'], new Element(i['element'], color), i['svg']));
    }
    // debug
    /*for (var i in data) {
      print(' -> ' + i.id.toString() + ' ' + i.idByAsc.toString() + ' ' + i.symbol);
    }*/
    _zodiac = data;
  }

  ZodiacDegreReturn getDegre() {
    List<Zodiac> dataSorted = new List<Zodiac>();
    dataSorted = _zodiac;
    dataSorted.sort((a,b) => a.idByAsc.compareTo(b.idByAsc));
    List<ZodiacDegre> zodiacDegre = new List<ZodiacDegre>();
    for (Zodiac i in dataSorted) {
      double degre = ((i.idByAsc - 1) * 30.0) - _degreAsc;
      if (degre < 0) {
        degre = 360.0 - (degre * - 1);
      }
      zodiacDegre.add(new ZodiacDegre(i, degre, degre + 15.0));
    }
    return new ZodiacDegreReturn(zodiacDegre);
  }

  List<ZodiacSvgReturn> getZodiacSvg(CalcDraw calcDraw, double size) {
    List<ZodiacSvgReturn> zodiacSvg = List<ZodiacSvgReturn>();
    for(ZodiacDegre z in getDegre().zodiac)
    {
      Offset xy = calcDraw.getOffsetCenterZodiac(size, calcDraw.pointTrigo(z.degre15, calcDraw.getRadiusCircleZodiac()));
      zodiacSvg.add(new ZodiacSvgReturn(z.zodiac, xy));
    }
    return zodiacSvg;
  }


    /*
    List<MonthDaySignHour> data = [];
    List<SignHour> sign = [];
    SignHour signHour;
    MonthDaySignHour monthDaySignHour;
    TypeSigne signEnum;
    Map decoded = jsonDecode(jsonString);
    for (var i in decoded['data']) {
      sign = [];
      for (var j in i['sign']) {
        switch(j['sign']) {
          case 'Belier':
            signEnum = TypeSigne.Belier;
            break;
          case 'Taureau':
            signEnum = TypeSigne.Taureau;
            break;
          case 'Gemaux':
            signEnum = TypeSigne.Gemaux;
            break;
          case 'Cancer':
            signEnum = TypeSigne.Cancer;
            break;
          case 'Lion':
            signEnum = TypeSigne.Lion;
            break;
          case 'Vierge':
            signEnum = TypeSigne.Vierge;
            break;
          case 'Balance':
            signEnum = TypeSigne.Balance;
            break;
          case 'Scorpion':
            signEnum = TypeSigne.Scorpion;
            break;
          case 'Sagittaire':
            signEnum = TypeSigne.Sagittaire;
            break;
          case 'Capricorne':
            signEnum = TypeSigne.Capricorne;
            break;
          case 'Verseau':
            signEnum = TypeSigne.Verseau;
            break;
          case 'Poisson':
            signEnum = TypeSigne.Poisson;
            break;
        }
        signHour = new SignHour(signEnum, _hm(j['hourBegin']), _hm(j['hourEnd']));
        sign.add(signHour);
      }
      monthDaySignHour = new MonthDaySignHour(i['month'], i['dayBegin'], i['dayEnd'], sign);
      data.add(monthDaySignHour);
    }
    _asc = new Asc(data);
    /*
    for (var i in data) {
      for (var j in i.signHour) {
        print (j.hourBegin);
      }
    }*/ 
  }

  AscReturn getAsc() {
    double degreInSign = 0.0;
    TypeSigne sign;
    int dayMax = 0;
    /*for (var i in _asc.monthDaySignHour) {
      for (var j in i.signHour) {
        print (j.hourBegin);
      }
    }*/
    for (var i in _asc.monthDaySignHour) {
      if (i.month == _natal.month) {
        // Calcul at the day
        degreInSign = 0;
        if (i.dayEnd > dayMax) {
          dayMax = i.dayEnd;
        }
        if (_natal.day >= i.dayBegin && _natal.day <= i.dayEnd) {
          for (var j in i.signHour) {
            Duration diffBegin = _hourMinNatal.difference(j.hourBegin);
            Duration diffEnd = j.hourEnd.difference(_hourMinNatal);
            //if (_hourMinNatal >= j.hourBegin && _hourMinNatal <= j.hourEnd) { 
            if (!diffBegin.isNegative && !diffEnd.isNegative) {
              sign = j.typeAsc;
            }
          }
        }
        degreInSign = 0;
        int maxMin = 24 * 60;
        int hourCalc = _hourMinNatal.hour * 60;
        int minCalc = _hourMinNatal.minute;
        degreInSign = ((hourCalc + minCalc) / maxMin) * 30.0;
      }
    }
    return new AscReturn(sign, degreInSign);
  }*/
}