// struct
import 'dart:ui';

class Planet {
  final String id;
  final String sign;
  final String signPos;
  final String svg;
  final String svgDegre;
  final double posCricle360; 
  final Offset xyPlanet; // Position of the svg planet symbol
  const Planet(this.id, this.sign, this.signPos, this.svg, this.svgDegre, this.posCricle360, this.xyPlanet);
}