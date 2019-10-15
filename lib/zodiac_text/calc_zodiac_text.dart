import 'dart:convert';

import 'package:astrologie/zodiac_text/s_zodiac_text_pictogramme.dart';
import 'package:flutter/services.dart';

import 'e_type_content.dart';
import 's_content.dart';
import 's_content_next.dart';
import 's_content_svg.dart';
import 's_content_texte.dart';
import 's_content_title.dart';
import 's_zodiac_text.dart';

const STARTTAGTIT = '#TIT:';
const STARTTAGTEX = '#TEX:';
const STARTTAGSVG = '#SVG:';
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
              var item = new ContentTitle(cn.content, 18.0);
              print('add title');
              l.add(new Content(TypeContent.TypeTitle, item, null, null));
              break;
            case TypeContent.TypeText:
              var item = new ContentText(cn.content);
              print('add text');
              l.add(new Content(TypeContent.TypeTitle, null, item, null));
              break;
            case TypeContent.TypeSvg:
              var item = new ContentSvg(cn.content);
              print('add svg');
              l.add(new Content(TypeContent.TypeTitle, null, null, item));
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
    int pos = 0;
    int nextPos = 0;
    String content = '';
    TypeContent type = TypeContent.Null;
    int startIndexTitle = s.indexOf(STARTTAGTIT) + STARTTAGTIT.length;
    int endIndexTitle = s.indexOf(ENDTAG, startIndexTitle);
    bool swValidTitle = (startIndexTitle > 0) && (endIndexTitle - startIndexTitle) > 0;
    if (!swValidTitle) {
      startIndexTitle = 0;
      endIndexTitle = 0;
    } else {
      pos = startIndexTitle;
      nextPos = endIndexTitle + ENDTAG.length;
      content = s.substring(startIndexTitle, endIndexTitle);
      type = TypeContent.TypeTitle;
    }
    int startIndexText = s.indexOf(STARTTAGTEX) + STARTTAGTEX.length;
    int endIndexText = s.indexOf(ENDTAG, startIndexText);
    bool swValidText = (startIndexText > 0) && (endIndexText - startIndexText) > 0;
    if (!swValidText) {
      startIndexText = 0;
      endIndexText = 0;
    } else {
      if (startIndexText < pos) {
        pos = startIndexText;
        nextPos = endIndexText + ENDTAG.length;
        content = s.substring(startIndexText, endIndexText);
        type = TypeContent.TypeText;
      }
    }
    int startIndexSvg = s.indexOf(STARTTAGSVG) + STARTTAGSVG.length;
    int endIndexSvg = s.indexOf(ENDTAG, startIndexSvg);
    bool swValidSvg = (startIndexSvg > 0) && (endIndexSvg - startIndexSvg) > 0;
    if (!swValidSvg) {
      startIndexSvg = 0;
      endIndexSvg = 0;
    } else {
      if (startIndexSvg < pos) {
        pos = startIndexSvg;
        nextPos = endIndexSvg + ENDTAG.length;
        content = s.substring(startIndexSvg, endIndexSvg);
        type = TypeContent.TypeSvg;
      }
    }
    return new ContentNext(type, nextPos, content);
  }
}
