import 'dart:convert';

import 'package:astrologie/zodiac_text/s_zodiac_text_pictogramme.dart';
import 'package:flutter/services.dart';

import 's_zodiac_text.dart';

class CalcZodiacText {
  static List<ZodiacText> _zodiacText = new List<ZodiacText>();

  CalcZodiacText();

  Future<List<ZodiacText>> parseJson() async {
    _zodiacText.clear();
    Map decoded = jsonDecode(await rootBundle.loadString('assets/data/generated.json'));
    // Order by Asc
    if (decoded != null) {
      for (var i in decoded['zodiac_text']) {
        _zodiacText.add(new ZodiacText(i['sign'], new ZodiacTextPictogramme(i['struct']['pictogramme']['titre'], i['struct']['pictogramme']['contenu'])));
      }
    }
    return _zodiacText;
  }
}