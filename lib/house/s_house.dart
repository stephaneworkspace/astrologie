// struct
import 'dart:ui';

class House {
  final int id;
  final int idByAsc;
  final String sign;
  final String svg;
  final double posCricle360; 
  final Offset xyHouse;// Position angular at 0°
  const House(this.id, this.idByAsc, this.sign, this.svg, this.posCricle360, this.xyHouse);
}