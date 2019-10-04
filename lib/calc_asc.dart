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
const POISSON = 11;

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
  List<MonthDaySignHour> data = [];

  CalcAsc() {
    print('hello world');
    initData();
  }

  Future<String> _loadJsonAscAsset() async {
    return await rootBundle.loadString('assets/data/asc.json');
  }

  Future loadJsonAsc() async {
    String jsonString = await _loadJsonAscAsset();
    _parseJsonAsc(jsonString);
  }

  void _parseJsonAsc(String jsonString) {
    Map decoded = jsonDecode(jsonString);

    for (var i in decoded['data']) {
      print(i['month'].toString());
    }
    
  }

  initData() {
    loadJsonAsc();
    List<SignHour> sign = [];
    SignHour signHour;
    MonthDaySignHour monthDaySignHour;
    signHour = new SignHour(TypeAsc.Belier, d('11:00'), d('11:59'));
    sign.add(signHour);
    signHour = new SignHour(TypeAsc.Taureau, d('12:00'), d('13:19'));
    sign.add(signHour);
    monthDaySignHour = new MonthDaySignHour(1, 1, 10, sign);
    data.add(monthDaySignHour);
    for (MonthDaySignHour i in data) {
      for (var j in i.signHour) {
        print (j.hourBegin);
      }
    }
  }

  // parse hour:min
  DateTime d(String s) {
    final DateFormat df = new DateFormat('HH:mm');
    return df.parseStrict(s);
  }
}