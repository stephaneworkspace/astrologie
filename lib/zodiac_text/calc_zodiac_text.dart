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
        print('cn null');
        s = '';
        swLoop = false;
      } else {
        print('s.lenght: ' + s.length.toString() + ' cn.nextPos: ' + cn.nextPos.toString());
        if (s.length > cn.nextPos)
        {
          s = s.substring(cn.nextPos);
          print('next: ' + s);
          switch (cn.type) {
            case TypeContent.TypeTitle:
              print('Add title: ' + cn.content);
              ContentTitle itemTitle = new ContentTitle(cn.content, 18.0);
              l.add(new Content(TypeContent.TypeTitle, itemTitle, null, null));
              break;
            case TypeContent.TypeText:
              print('Add text: ' + cn.content);
              ContentText itemText = new ContentText(cn.content);
              l.add(new Content(TypeContent.TypeText, null, itemText, null));
              break;
            case TypeContent.TypeSvg:
              print('Add svg: ' + cn.content);
              ContentSvg itemSvg = new ContentSvg(cn.content);
              l.add(new Content(TypeContent.TypeSvg, null, null, itemSvg));
              break;
            default:
              break;
          }
        } else {
          print('cn end');
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
    startIndex = s.indexOf(STARTTAGTIT) == -1 ? 0 : s.indexOf(STARTTAGTIT) + STARTTAGTIT.length;
    endIndex = s.indexOf(ENDTAG, startIndex);
    bool swValidTitle = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidTitle) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        // print('A pos :' + startIndex.toString() + ' + ' + pos.toString());
        nextPos = endIndex + ENDTAG.length;
        content = s.substring(startIndex, endIndex);
        type = TypeContent.TypeTitle;
      }
    }
    startIndex = s.indexOf(STARTTAGTEX) == -1 ? 0 : s.indexOf(STARTTAGTEX) + STARTTAGTEX.length;
    endIndex = s.indexOf(ENDTAG, startIndex);
    bool swValidText = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidText) {
      startIndex = 0;
      endIndex = 0;
    } else {
      // print('B pos :' + startIndex.toString()+ ' > ' + pos.toString());
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAG.length;
        content = s.substring(startIndex, endIndex);
        type = TypeContent.TypeText;
      }
    }
    startIndex = s.indexOf(STARTTAGSVG) == -1 ? 0 : s.indexOf(STARTTAGSVG) + STARTTAGSVG.length;
    endIndex = s.indexOf(ENDTAG, startIndex);
    bool swValidSvg = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidSvg) {
      startIndex = 0;
      endIndex = 0;
    } else {
      // print('C pos :' + startIndex.toString()+ ' > ' + pos.toString());
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAG.length;
        content = 'assets/svg/astro_py_text/' + s.substring(startIndex, endIndex);
        type = TypeContent.TypeSvg;
      }
    }
    return new ContentNext(type, nextPos, content);
  }
}
