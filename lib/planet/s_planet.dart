// struct
import 'dart:ui';

class Planet {
  final String id;
  final String sign;
  final String signPos;
  final String svg;
  final String svgDegre;
  final String svgMin;
  final double posCricle360; 
  final Offset xyPlanet; // Position of the svg planet symbol
  final Offset xyDeg; // Position of the svg deg ° symbol
  final Offset xyMin; // Position of the svg deg ' symbol
  final Color color;
  const Planet(this.id, this.sign, this.signPos, this.svg, this.svgDegre, this.svgMin, this.posCricle360, this.xyPlanet, this.xyDeg, this.xyMin, this.color);
}