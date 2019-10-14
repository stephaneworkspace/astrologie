import 'dart:ui';
// struct
class Angle {
  final String id;
  final String sign;
  final String signPos;
  final String svg;
  final String svgDegre;
  final double posCricle360; 
  final Offset xyAngle;
  final Offset xyDeg;
  final Color color;
  const Angle(this.id, this.sign, this.signPos, this.svg, this.svgDegre, this.posCricle360, this.xyAngle, this.xyDeg, this.color);
}