import 'dart:ui';
import '../element/s_el.dart';

// struct
class Zodiac {
  final int id;
  final int idByAsc;
  final String sign;
  final String symbol;
  final El element;
  final String svg;
  final double posCricle360; // Position angular at 0°
  final Offset xyZodiac; // Position of the svg zodiac
  const Zodiac(this.id, this.idByAsc, this.sign, this.symbol, this.element, this.svg, this.posCricle360, this.xyZodiac);
}