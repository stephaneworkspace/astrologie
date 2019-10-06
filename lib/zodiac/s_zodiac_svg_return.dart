// struct
import 'dart:ui';

import './calc_zodiac.dart';

class ZodiacSvgReturn {
  final Zodiac zodiac;
  final Offset xyZodiac; // Position of the svg zodiac
  const ZodiacSvgReturn(this.zodiac, this.xyZodiac);
}