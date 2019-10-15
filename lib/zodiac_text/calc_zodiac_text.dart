import 'dart:convert';
import 'package:flutter/services.dart';
import '../content/calc_content.dart';
import 's_zodiac_text.dart';

class CalcZodiacText {
  static List<ZodiacText> _zodiacText = new List<ZodiacText>();

  CalcZodiacText();

  Future<List<ZodiacText>> parseJson() async {
    _zodiacText.clear();
    CalcContent content = new CalcContent();
    Map decoded = jsonDecode(await rootBundle.loadString('assets/data/generated.json'));
    // Order by Asc
    if (decoded != null) {
      for (var i in decoded['zodiac_text']) {
        _zodiacText.add(new ZodiacText(i['sign'], content.makeContent(i['content'])));
      }
    }
    return _zodiacText;
  }
}
