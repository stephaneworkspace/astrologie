import 'dart:math';

import 'dart:ui';

const CIRC = 360.0;

const CIRCLE0 = 35;
const CIRCLE1 = 55;
const CIRCLE2 = 60;

/// This draw class is optimized for circle in a care
class CalcDraw {
  static double _sizeMinWorkingCanvasWidthHeight;

  CalcDraw(double mediaSizeWidth, double mediaSizeHeight) {
    _sizeMinWorkingCanvasWidthHeight = min(mediaSizeWidth , mediaSizeHeight);
  }

  /// Size (Width Max - Height Max) -> The min value
  double getSizeWH() {
    return _sizeMinWorkingCanvasWidthHeight;
  } 

  double getRadiusTotal() {
    //_radiusTotal = min(size.width / 2, size.height / 2);
    return getSizeWH() / 2;
  }

  double getRadiusCircle(int i) {
    switch (i) {
      case 0:
        return (getRadiusTotal() * CIRCLE0) / 100;
      case 1:
        return (getRadiusTotal() * CIRCLE1) / 100;
      case 2:
        return (getRadiusTotal() * CIRCLE2) / 100;
      default:
        return getRadiusTotal();
    }
  }

  double getRadiusCircleZodiac() {
    return (getRadiusTotal() * (((CIRCLE1 - CIRCLE0) / 2) + CIRCLE0)) / 100;
  }

  Offset getCenter() {
    //return new Offset(size.width / 2, size.height / 2);
    return new Offset(getRadiusTotal(), getRadiusTotal());
  }

  // Theorem Pythagoras => Distance between 2 offset
  double sizeZodiac(Offset xy1, Offset xy2) {
    double a = xy1.dx - xy2.dx;
    double b = xy1.dy - xy2.dy;
    return sqrt(a*a + b*b);
  }

  /// Center for the svg zodiac
  /// 
  /// 0.0 - 0.0 = top left of the screen
  /// so this method is a helper for find the position of the sign
  Offset getOffsetCenterZodiac(double sizeZodiac, Offset xy00) {
    return new Offset(xy00.dx - (sizeZodiac / 2), xy00.dy - (sizeZodiac / 2));
  }

  // Trigonometry
  List<Offset> lineTrigo(double angular, double radiusCircleBegin, double radiusCircleEnd) {
    List<Offset> returnList = List<Offset>();
    double dx1 = getCenter().dx + cos(angular / CIRC * 2 * pi) * -1 * Radius.circular(radiusCircleBegin).x;
    double dy1 = getCenter().dy + sin(angular / CIRC * 2 * pi) * Radius.circular(radiusCircleBegin).y;
    returnList.add(new Offset(dx1, dy1));
    double dx2 = getCenter().dx + cos(angular / CIRC * 2 * pi) * -1 * Radius.circular(radiusCircleEnd).x;
    double dy2 = getCenter().dy + sin(angular / CIRC * 2 * pi) * Radius.circular(radiusCircleEnd).y;
    returnList.add(new Offset(dx2, dy2));
    return returnList;
  }

  // Trigonometry
  Offset pointTrigo(double angular, double radiusCircle) {
    double dx = getCenter().dx + cos(angular / CIRC * 2 * pi) * -1 * Radius.circular(radiusCircle).x;
    double dy = getCenter().dy + sin(angular / CIRC * 2 * pi) * Radius.circular(radiusCircle).y;
    return new Offset(dx, dy);
  }
}