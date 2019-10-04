/*@JS()
library eph;*/

//import 'dart:ffi';
//import 'dart:ui';
//import 'dart:math';
import 'package:intl/intl.dart';
//import 'package:intl/date_symbol_data_local.dart';
//initializeDateFormatting("fr_CH", null).then((_) => runMyCode());
//import 'package:date_format/date_format.dart';
// https://github.com/dart-lang/sdk/tree/master/pkg/js
//import 'package:js/js.dart';

/*@JS('getAllPlanets')
//external set _getAllPlanets(void Function(String '1986-04-03', -71.13, 42.27, 30) f);
external void getAllPlanets(String date, double long, double lat, double height);
*/

import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/*
const BELIER = 0;
const TAUREAU = 1;
const GEMAUX = 2;
const CANCER = 3;
const LION = 4;
const VIERGE = 5;
const BALANCE = 6;
const SCORPION = 7;
const SAGITTAIRE = 8;
const CAPRICORNE = 9;
const VERSEAU = 10;
const POISSON = 11;*/

enum TypeAsc {
  Belier,
  Taureau,
  Gemaux,
  Cancer,
  Lion,
  Vierge,
  Balance,
  Scorpion,
  Sagittaire,
  Capricorne,
  Verseau,
  Poisson,
}

// struc
class Asc {
  final List<MonthDaySignHour> monthDaySignHour;
  const Asc(this.monthDaySignHour); 
}

// struct
class MonthDaySignHour {
  final int month;
  final int dayBegin;
  final int dayEnd;
  final List<SignHour> signHour;
  const MonthDaySignHour(this.month, this.dayBegin, this.dayEnd, this.signHour);
}

// struct
class SignHour {
  final TypeAsc typeAsc;
  final DateTime hourBegin;
  final DateTime hourEnd;
  const SignHour(this.typeAsc, this.hourBegin, this.hourEnd);
}

// struct
class AscReturn {
  final String sign;
  final TypeAsc typeAsc;
  final double degre;
  const AscReturn(this.sign, this.typeAsc, this.degre);
} 

// main class
class CalcAsc {
  static Asc _asc;
  DateTime _natal;
  DateTime _hourMinNatal;

  CalcAsc(DateTime natal) {
    this._natal = natal;
    this._hourMinNatal = _hm(_natal.hour.toString() + ':' + _natal.minute.toString());
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
    TypeAsc signEnum;
    Map decoded = jsonDecode(jsonString);
    for (var i in decoded['data']) {
      sign = [];
      for (var j in i['sign']) {
        switch(j['sign']) {
          case 'Belier':
            signEnum = TypeAsc.Belier;
            break;
          case 'Taureau':
            signEnum = TypeAsc.Taureau;
            break;
          case 'Gemaux':
            signEnum = TypeAsc.Gemaux;
            break;
          case 'Cancer':
            signEnum = TypeAsc.Cancer;
            break;
          case 'Lion':
            signEnum = TypeAsc.Lion;
            break;
          case 'Vierge':
            signEnum = TypeAsc.Vierge;
            break;
          case 'Balance':
            signEnum = TypeAsc.Balance;
            break;
          case 'Scorpion':
            signEnum = TypeAsc.Scorpion;
            break;
          case 'Sagittaire':
            signEnum = TypeAsc.Sagittaire;
            break;
          case 'Capricorne':
            signEnum = TypeAsc.Capricorne;
            break;
          case 'Verseau':
            signEnum = TypeAsc.Verseau;
            break;
          case 'Poisson':
            signEnum = TypeAsc.Poisson;
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
    String signText = '?';
    double degreInSign = 0.0;
    TypeAsc sign;
    int dayMax = 0;
     for (var i in _asc.monthDaySignHour) {
      for (var j in i.signHour) {
        print (j.hourBegin);
      }
    }  
    /*
    for (var i in _asc.monthDaySignHour) {
      if (i.month == _natal.month) {
        // Calcul at the day
        degreInSign = 0;
        if (i.dayEnd > dayMax) {
          dayMax = i.dayEnd;
        }
        if (_natal.day >= i.dayBegin && _natal.day <= i.dayEnd) {
          for (var j in i.signHour) {
            print(j.hourBegin.toString() + ' ' + j.typeAsc.toString());
            Duration difference = _hourMinNatal.difference(j.hourBegin);
            //if (_hourMinNatal >= j.hourBegin) {
            if (!difference.isNegative) {
              print(_hourMinNatal.toString() + ' >= ' + j.hourBegin.toString() + ' == true');
            } else {
              print(_hourMinNatal.toString() + ' >= ' + j.hourBegin.toString() + ' == false');
            }
          }
        }

      }
    }*/
    return new AscReturn(signText, sign, degreInSign);
  }
}