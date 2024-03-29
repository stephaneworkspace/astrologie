import 'e_type_content.dart';
import 's_content_png.dart';
import 's_content_svg.dart';
import 's_content_text.dart';
import 's_content_title.dart';

// struct
class Content {
  final TypeContent typeContent;
  final ContentTitle contentTitle;
  final ContentText contentText;
  final ContentSvg contentSvg;
  final ContentPng contentPng;
  Content(this.typeContent, this.contentTitle, this.contentText, this.contentSvg, this.contentPng);
}