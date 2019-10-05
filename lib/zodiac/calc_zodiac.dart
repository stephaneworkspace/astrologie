import 'package:intl/intl.dart';

import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// struct
class Element {
  final String name;
  const Element(this.name);
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
  
  CalcZodiac(double degreAsc, int signAsc) {
    _degreAsc = degreAsc;
    _signAsc = signAsc;
    loadJsonAsc();
  }

  Future<String> _loadJsonZodiacAsset() async {
    return await rootBundle.loadString('assets/data/zodiac.json');
  }

  Future loadJsonAsc() async {
    String jsonString = await _loadJsonZodiacAsset();
    _parseJsonAsc(jsonString);
  }

  /// idByAsc = 11/12 Verseau (10 without + 1 on enum 0-11)
  ///
  /// 1 3    3 + 10 = 1
  /// 2 4    4 + 10 = 2
  /// 3 5    5 + 10 = 3
  /// 4 6    6 + 10 = 4
  /// 5 7    7 + 10 = 5
  /// 6 8    8 + 10 = 6
  /// 7 9    9 + 10 = 7
  /// 8 10   10 + 10 = 8
  /// 9 11   11 + 10 = 9
  /// 10 12  12 + 10 = 10 
  /// 11 1   1 + 10 = 11
  /// 12 2   2 + 10 = 12
  void _parseJsonAsc(String jsonString) {
    List<Zodiac> data = [];
    Map decoded = jsonDecode(jsonString);
    int idByAsc = _signAsc;
    for (var i in decoded['data']) {
      idByAsc = _signAsc + i['id'];
      if (idByAsc > 12) {
        idByAsc -= 12;
      }
      data.add(new Zodiac(i['id'], idByAsc, 'test', i['symbol'], new Element(i['element']), i['svg']));
    }/*
    for (var i in data) {
        print(i.id.toString() + '-' + i.idByAsc.toString());
    }*/
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