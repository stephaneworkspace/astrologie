import 'dart:convert';

import 'package:astrologie/zodiac_text/s_zodiac_text_pictogramme.dart';
import 'package:flutter/services.dart';

import 'e_type_content.dart';
import 's_content.dart';
import 's_content_next.dart';
import 's_content_png.dart';
import 's_content_svg.dart';
import 's_content_texte.dart';
import 's_content_title.dart';
import 's_zodiac_text.dart';

const STARTTAGTIT = '#TIT:';
const STARTTAGTEX = '#TEX:';
const STARTTAGSVG = '#SVG:';
const STARTTAGPNG = '#PNG:';
const ENDTAG = ':END#';

class CalcZodiacText {
  static List<ZodiacText> _zodiacText = new List<ZodiacText>();

  CalcZodiacText();

  Future<List<ZodiacText>> parseJson() async {
    _zodiacText.clear();
    Map decoded = jsonDecode(await rootBundle.loadString('assets/data/generated.json'));
    // Order by Asc
    if (decoded != null) {
      for (var i in decoded['zodiac_text']) {
        _zodiacText.add(new ZodiacText(i['sign'], new ZodiacTextPictogramme(i['struct']['pictogramme']['titre'], i['struct']['pictogramme']['contenu']), _makeContent(i['struct']['pictogramme']['contenu'])));
      }
    }
    return _zodiacText;
  }

  List<Content> _makeContent(String s) {
    List<Content> l = new List<Content>();
    /*String startTag = "#IMG:";
    String endTag = ":END#";
    int startIndex = s.indexOf(startTag) + startTag.length;
    int endIndex = s.indexOf(endTag, startIndex);
    print('here: ' + (endIndex - startIndex).toString());
    if (endIndex - startIndex > 0) {
      print(s.substring(startIndex, endIndex));
    }*/
    bool swLoop = true;
    ContentNext cn = new ContentNext(TypeContent.Null,0,'');
    while(swLoop) { 
      cn = _nextContent(s);
      if (cn.type == TypeContent.Null) {
        s = '';
        swLoop = false;
      } else {
        if (s.length > cn.nextPos)
        {
          s = s.substring(cn.nextPos);
          switch (cn.type) {
            case TypeContent.TypeTitle:
              ContentTitle itemTitle = new ContentTitle(cn.content, 18.0);
              l.add(new Content(TypeContent.TypeTitle, itemTitle, null, null, null));
              break;
            case TypeContent.TypeText:
              ContentText itemText = new ContentText(cn.content);
              l.add(new Content(TypeContent.TypeText, null, itemText, null, null));
              break;
            case TypeContent.TypeSvg:
              ContentSvg itemSvg = new ContentSvg(cn.content);
              l.add(new Content(TypeContent.TypeSvg, null, null, itemSvg, null));
              break;
            case TypeContent.TypePng:
              ContentPng itemPng = new ContentPng(cn.content);
              l.add(new Content(TypeContent.TypePng, null, null, null, itemPng));
              break;
            default:
              break;
          }
        } else {
          s = '';
          swLoop = false;
        }
      }
    } 
    return l;
  }

  /// Next item detection
  /// Return a object ContentNext with the type of element and position in string
  ContentNext _nextContent(String s) {
    // print('str: ' + s);
    int pos = s.length;
    int nextPos = 0;
    String content = '';
    TypeContent type = TypeContent.Null;
    int startIndex = 0;
    int endIndex = 0;
    // Title
    startIndex = s.indexOf(STARTTAGTIT) == -1 ? 0 : s.indexOf(STARTTAGTIT) + STARTTAGTIT.length;
    endIndex = s.indexOf(ENDTAG, startIndex);
    bool swValidTitle = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidTitle) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAG.length;
        content = s.substring(startIndex, endIndex);
        type = TypeContent.TypeTitle;
      }
    }
    // Text
    startIndex = s.indexOf(STARTTAGTEX) == -1 ? 0 : s.indexOf(STARTTAGTEX) + STARTTAGTEX.length;
    endIndex = s.indexOf(ENDTAG, startIndex);
    bool swValidText = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidText) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAG.length;
        content = s.substring(startIndex, endIndex);
        type = TypeContent.TypeText;
      }
    }
    // Svg
    startIndex = s.indexOf(STARTTAGSVG) == -1 ? 0 : s.indexOf(STARTTAGSVG) + STARTTAGSVG.length;
    endIndex = s.indexOf(ENDTAG, startIndex);
    bool swValidSvg = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidSvg) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAG.length;
        content = 'assets/svg/astro_py_text/' + s.substring(startIndex, endIndex);
        type = TypeContent.TypeSvg;
      }
    }
    // Png
    startIndex = s.indexOf(STARTTAGPNG) == -1 ? 0 : s.indexOf(STARTTAGPNG) + STARTTAGPNG.length;
    endIndex = s.indexOf(ENDTAG, startIndex);
    bool swValidPng = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidPng) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAG.length;
        content = 'assets/png/astro_py_text/' + s.substring(startIndex, endIndex);
        type = TypeContent.TypePng;
      }
    }
    return new ContentNext(type, nextPos, content);
  }
}
