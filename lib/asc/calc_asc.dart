import 'package:intl/intl.dart';

import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import './e_type_signe.dart';
import './s_asc.dart';
import './s_asc_return.dart';
import './s_month_day_sign_hour.dart';
import './s_sign_hour.dart';

class CalcAsc {
  static Asc _asc;
  static DateTime _natal;
  DateTime _hourMinNatal;

  CalcAsc(DateTime natal) {
    _natal = natal;
    _hourMinNatal = _hm(_natal.hour.toString() + ':' + _natal.minute.toString());
    loadJsonAsc();
  }

  Future<String> _loadJsonAscAsset() async {
    return await rootBundle.loadString('assets/data/asc.json');
  }

  Future loadJsonAsc() async {
    String jsonString = await _loadJsonAscAsset();
    _parseJsonAsc(jsonString);
  }

  // parse hour:min
  DateTime _hm(String s) {
    final DateFormat df = new DateFormat('HH:mm');
    return df.parseStrict(s);
  }

  void _parseJsonAsc(String jsonString) {
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
    if (_asc != null && _asc.monthDaySignHour != null) {
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
    }
    return new AscReturn(sign, degreInSign);
  }
}