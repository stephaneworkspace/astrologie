import 's_content.dart';
import 's_zodiac_text_pictogramme.dart';

// struct
class ZodiacText {
  final String sign;
  final ZodiacTextPictogramme pictogramme;
  final List<Content> content;
  const ZodiacText(this.sign, this.pictogramme, this.content);
}