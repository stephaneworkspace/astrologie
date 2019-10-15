import 'e_type_content.dart';
import 's_content_svg.dart';
import 's_content_texte.dart';
import 's_content_title.dart';

// struct
class Content {
  final TypeContent typeContent;
  final ContentTitle contentTitle;
  final ContentText contentText;
  final ContentSvg contentSvg;
  Content(this.typeContent, this.contentTitle, this.contentText, this.contentSvg);
}