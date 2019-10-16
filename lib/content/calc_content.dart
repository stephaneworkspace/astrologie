import 'package:astrologie/content/s_content_text_rich.dart';
import 'package:flutter/material.dart';

import '../content/e_type_content.dart';
import '../content/s_content.dart';
import '../content/s_content_next.dart';
import '../content/s_content_png.dart';
import '../content/s_content_svg.dart';
import '../content/s_content_text.dart';
import '../content/s_content_title.dart';
import 's_content_next_text_rich.dart';

const STARTTAGTIT = '<TIT>'; // Title private repository
const ENDTAGTIT = '</TIT>';
const STARTTAGTEX = '<TEX>'; // Text private reposition
const ENDTAGTEX = '</TEX>';
const STARTTAGSVG = '<SVG>'; // SVG private preposition
const ENDTAGSVG = '</SVG>';
const STARTTAGSVZ = '<SVZ>'; // SVG Asset in this git repository
const ENDTAGSVZ = '</SVZ>';
const STARTTAGPNG = '<PNG>';
const ENDTAGPNG = '</PNG>';

// Param at begin of <TIT>
const STARTTAGSIZ = '<SIZ>';
const ENDTAGNES = '</SIZ>';

// Rich text inside <TEX>
const STARTRICHNORMAL = '<N>';
const ENDRICHNORMAL = '</N>';
const STARTRICHITALIC = '<I>';
const ENDRICHITALIC = '</I>';
const STARTRICHBOLD = '<B>';
const ENDRICHBOLD = '</B>';

const TITLESIZ1 = 20.0;
const TITLESIZ2 = 18.0;
const TITLESIZ3 = 16.0;

class CalcContent {
  List<Content> makeContent(String s) {
    List<Content> l = new List<Content>();
    bool swLoop = true;
    ContentNext cn = new ContentNext(TypeContent.Null,0,'');
    while(swLoop) { 
      cn = _nextContent(s);
      if (cn.type == TypeContent.Null) {
        s = '';
        swLoop = false;
      } else {
        if (s.length >= cn.nextPos)
        {
          s = s.substring(cn.nextPos);
          switch (cn.type) {
            case TypeContent.TypeTitle:
              String content = '';
              double size = 18.0;
              int startIndex = 0;
              int endIndex = 0;
              // Size
              startIndex = cn.content.indexOf(STARTTAGSIZ) == -1 ? 0 : cn.content.indexOf(STARTTAGSIZ) + STARTTAGSIZ.length;
              endIndex = cn.content.indexOf(ENDTAGNES, startIndex);
              bool swValidTitle = (startIndex > 0) && (endIndex - startIndex) > 0;
              if (!swValidTitle) {
                content = cn.content;
              } else {
                switch (cn.content.substring(startIndex, endIndex)) {
                  case '1':
                    size = TITLESIZ1;
                    break;
                  case '2':
                    size = TITLESIZ2;
                    break;
                  case '3':
                    size = TITLESIZ3;
                    break;
                  default:
                    size = TITLESIZ2;
                }
                if (cn.content.length >= endIndex + ENDTAGNES.length)
                  content = cn.content.substring(endIndex + ENDTAGNES.length);
              }
              ContentTitle itemTitle = new ContentTitle(content, size);
              l.add(new Content(TypeContent.TypeTitle, itemTitle, null, null, null));
              break;
            case TypeContent.TypeText:
              bool swLoop2 = true;
              String string2 = cn.content;
              List<ContentTextRich> listRich = new List<ContentTextRich>();
              ContentNextTextRich cntr = new ContentNextTextRich(FontStyle.normal, FontWeight.normal, 0, '');
              while(swLoop2) {
                if (cntr.fontStyle == null || cntr.fontWeight == null) {
                  string2 = '';
                  swLoop2 = false;
                } else {
                  if (string2.length >= cntr.nextPos)
                  {
                    string2 = string2.substring(cntr.nextPos); // Init at 0
                    cntr = _nextContentRichText(string2);
                    if (cntr.content != null)
                      listRich.add(new ContentTextRich(cntr.content, cntr.fontStyle, cntr.fontWeight));
                    else {
                      string2 = '';
                      swLoop2 = false;
                    }
                  } else {
                    string2 = '';
                    swLoop2 = false;
                  }
                }
              }
              ContentText itemText = new ContentText(listRich);
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
    endIndex = s.indexOf(ENDTAGTIT, startIndex);
    bool swValidTitle = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidTitle) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAGTIT.length;
        content = s.substring(startIndex, endIndex);
        type = TypeContent.TypeTitle;
      }
    }
    // Text
    startIndex = s.indexOf(STARTTAGTEX) == -1 ? 0 : s.indexOf(STARTTAGTEX) + STARTTAGTEX.length;
    endIndex = s.indexOf(ENDTAGTEX, startIndex);
    bool swValidText = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidText) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAGTEX.length;
        content = s.substring(startIndex, endIndex);
        type = TypeContent.TypeText;
      }
    }
    // Svg
    startIndex = s.indexOf(STARTTAGSVG) == -1 ? 0 : s.indexOf(STARTTAGSVG) + STARTTAGSVG.length;
    endIndex = s.indexOf(ENDTAGSVG, startIndex);
    bool swValidSvg = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidSvg) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAGSVG.length;
        content = 'assets/svg/astro_py_text/' + s.substring(startIndex, endIndex);
        type = TypeContent.TypeSvg;
      }
    }
    // Svg Zodiac local
    startIndex = s.indexOf(STARTTAGSVZ) == -1 ? 0 : s.indexOf(STARTTAGSVZ) + STARTTAGSVZ.length;
    endIndex = s.indexOf(ENDTAGSVZ, startIndex);
    bool swValidSvgz = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidSvgz) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAGSVZ.length;
        content = 'assets/svg/zodiac/' + s.substring(startIndex, endIndex);
        type = TypeContent.TypeSvg;
      }
    }
    // Png
    startIndex = s.indexOf(STARTTAGPNG) == -1 ? 0 : s.indexOf(STARTTAGPNG) + STARTTAGPNG.length;
    endIndex = s.indexOf(ENDTAGPNG, startIndex);
    bool swValidPng = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidPng) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDTAGPNG.length;
        content = 'assets/png/astro_py_text/' + s.substring(startIndex, endIndex);
        type = TypeContent.TypePng;
      }
    }
    return new ContentNext(type, nextPos, content);
  }

  ContentNextTextRich _nextContentRichText(String s) {
    // print('str: ' + s);
    int pos = s.length;
    int nextPos = 0;
    String content = '';
    FontStyle fontStyle = FontStyle.normal;
    FontWeight fontWeight = FontWeight.normal;
    int startIndex = 0;
    int endIndex = 0;
    // Normal <N> -> STARTRICHNORMAL </N> -> ENDRICHNORMAL
    startIndex = s.indexOf(STARTRICHNORMAL) == -1 ? 0 : s.indexOf(STARTRICHNORMAL) + STARTRICHNORMAL.length;
    endIndex = s.indexOf(ENDRICHNORMAL, startIndex);
    bool swValidN = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidN) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDRICHNORMAL.length;
        content = s.substring(startIndex, endIndex);
        fontStyle = FontStyle.normal;
      }
    }
    // Italic <I> -> STARTRICHITALIC </> -> ENDRICHITALIC
    startIndex = s.indexOf(STARTRICHITALIC) == -1 ? 0 : s.indexOf(STARTRICHITALIC) + STARTRICHITALIC.length;
    endIndex = s.indexOf(ENDRICHITALIC, startIndex);
    bool swValidI = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidI) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDRICHITALIC.length;
        content = s.substring(startIndex, endIndex);
        fontStyle = FontStyle.italic;
      }
    }
    // Italic <B> -> STARTRICHBOLD </> -> ENDRICHBOLD
    startIndex = s.indexOf(STARTRICHBOLD) == -1 ? 0 : s.indexOf(STARTRICHBOLD) + STARTRICHBOLD.length;
    endIndex = s.indexOf(ENDRICHBOLD, startIndex);
    bool swValidB = (startIndex > 0) && (endIndex - startIndex) > 0;
    if (!swValidB) {
      startIndex = 0;
      endIndex = 0;
    } else {
      if (pos > startIndex) {
        pos = startIndex;
        nextPos = endIndex + ENDRICHBOLD.length;
        content = s.substring(startIndex, endIndex);
        fontWeight = FontWeight.bold;
      }
    }
    if (content == '') 
      return new ContentNextTextRich(null, null, nextPos, content);
    else
      return new ContentNextTextRich(fontStyle, fontWeight, nextPos, content);
  }
}