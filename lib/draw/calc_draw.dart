import 'dart:math';

import 'dart:ui';

import './e_type_trait.dart';

const CIRC = 360.0;

const CIRCLE0 = 35;
const CIRCLE1 = 62;
const CIRCLE2 = 67;
const CIRCLE3INVISIBLE = 75;
const CIRCLE4INVISIBLE = 80;
const CIRCLE5INVISIBLE = 87;
const CIRCLE6INVISIBLE = 94;

const DIVTRAITPETIT = 0.1;
const DIVTRAITGRAND = 0.2;

const DIVTRAITPOINTER = 1.5;

const APPBARHEIGHT = 50.0;
const BOTTOMHEIGHTSPACING = 30.0;
const FLOATINGACTIONBUTTON = 160.0;

/// This draw class is optimized for circle in a care
class CalcDraw {
  static double _sizeMinWorkingCanvasWidthHeight;
  static double _sizeMediaHeight;

  CalcDraw(double mediaSizeWidth, double mediaSizeHeight) {
    _sizeMinWorkingCanvasWidthHeight = min(mediaSizeWidth , mediaSizeHeight);
    _sizeMediaHeight = mediaSizeHeight;
  }

  /// Size (Width Max - Height Max) -> The min value for draw the main content
  double getSizeWH() {
    return _sizeMinWorkingCanvasWidthHeight;
  } 

  double getSizeHBottom() {
    return _sizeMediaHeight - getSizeWH();
  }

  // for background
  double getSizeHWithFloatingButtonBottom() {
    return _sizeMediaHeight - getSizeWH();
  }

  double getSizeHMinusFloatingButtonBottom() {
    //print(_sizeMediaHeight.toString() + ' - ' + getSizeWH().toString());
    return _sizeMediaHeight - getSizeWH() - FLOATINGACTIONBUTTON;
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
      case 3:
        return (getRadiusTotal() * CIRCLE3INVISIBLE) / 100; // For planet (no circle, outside of circle)
      case 4: 
        return (getRadiusTotal() * CIRCLE4INVISIBLE) / 100; // For planet (no circle, outside of circle)
      case 5:
        return (getRadiusTotal() * CIRCLE5INVISIBLE) / 100;
      case 6:
        return (getRadiusTotal() * CIRCLE6INVISIBLE) / 100;
      default:
        return getRadiusTotal();
    }
  }

  double getRadiusCircleZodiac() {
    return (getRadiusTotal() * (((CIRCLE1 - CIRCLE0) / (2.0 + DIVTRAITGRAND)) + CIRCLE0)) / 100;
  }

  double getRadiusCircleHouse() {
    return (getRadiusTotal() * (((CIRCLE2 - CIRCLE1) / 2.0) + CIRCLE1)) / 100;
  }

  double getRadiusCircleZodiacCIRCLE1WithoutLine() {
    return getRadiusRulesInsideCircleZodiac(TypeTrait.Grand);
  }

  double getRadiusCircleHouseCIRCLE2WithoutLine() {
    return (getRadiusTotal() * ((CIRCLE2 - CIRCLE1) + CIRCLE0)) / 100; // - CIRCLE2
  }

  double getRadiusCirclePlanetCIRCLE3INVISIBLEWithoutLine() {
    return (getRadiusTotal() * ((CIRCLE3INVISIBLE - CIRCLE2) + CIRCLE0)) / 100; // - CIRCLE3INVISIBLE
  }

  double getRadiusCirclePlanetCIRCLE4INVISIBLEWithoutLine() {
    return (getRadiusTotal() * ((CIRCLE4INVISIBLE - CIRCLE3INVISIBLE) + CIRCLE0)) / 100; // - CIRCLE4INVISIBLE
  }

  double getRadiusCirclePlanetCIRCLE5INVISIBLEWithoutLine() {
    return (getRadiusTotal() * ((CIRCLE5INVISIBLE - CIRCLE4INVISIBLE) + CIRCLE0)) / 100; // - CIRCLE5INVISIBLE for °
  }

  double getRadiusCirclePlanetCIRCLE6INVISIBLEWithoutLine() {
    return (getRadiusTotal() * ((CIRCLE6INVISIBLE - CIRCLE5INVISIBLE) + CIRCLE0)) / 100; // - CIRCLE5INVISIBLE for '
  }

  double getRadiusRulesInsideCircleZodiac(TypeTrait typeTrait) {
    var divTrait;
    switch (typeTrait) {
      case TypeTrait.Petit:
        divTrait = 1.0 + DIVTRAITPETIT;
        break;
      case TypeTrait.Grand:
        divTrait = 1.0 + DIVTRAITGRAND;
        break;
    }
    return (getRadiusTotal() * (((CIRCLE1 - CIRCLE0) / divTrait) + CIRCLE0)) / 100; // - CIRCLE1
  }

  /// Bottom of Pointer
  ///     ..
  ///    /  \
  ///     II
  ///     II
  ///    HERE
  double  getRadiusRulesInsideCircleHouseForPointerBottom() {
    return (getRadiusTotal() * (((CIRCLE2 - CIRCLE1) / DIVTRAITPOINTER) - CIRCLE2)) / 100; // - CIRCLE2
  }

  /// Top of Pointer
  ///    HERE
  ///    /  \
  ///     II
  ///     II
  double  getRadiusRulesInsideCircleHouseForPointerTop() {
    return (getRadiusTotal() * ((CIRCLE2 - CIRCLE1) - CIRCLE2)) / 100; // - CIRCLE2
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

  // Theorem Pythagoras => Distance between 2 offset
  double sizeHouse(Offset xy1, Offset xy2) {
    double a = xy1.dx - xy2.dx;
    double b = xy1.dy - xy2.dy;
    return sqrt(a*a + b*b);
  }

  // Theorem Pythagoras => Distance between 2 offset
  double sizePlanet(Offset xy1, Offset xy2) {
    double a = xy1.dx - xy2.dx;
    double b = xy1.dy - xy2.dy;
    return sqrt(a*a + b*b);
  }

  // Theorem Pythagoras => Distance between 2 offset
  double sizeAngle(Offset xy1, Offset xy2) {
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

  /// Center for the text house
  Offset getOffsetCenterHouse(double sizeHouse, Offset xy00) {
    return new Offset(xy00.dx - (sizeHouse / 2), xy00.dy - (sizeHouse / 2));
  }

  Offset getOffsetCenterPlanet(double sizePlanet, Offset xy00) {
    return new Offset(xy00.dx - (sizePlanet / 2), xy00.dy - (sizePlanet / 2));
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

  // Not return radiusCircleEnd
  List<Offset> pathTrianglePointer(double angular, double angularPointer, double radiusCircleBegin, double radiusCircleEnd) {
    List<Offset> returnList = List<Offset>();
    double angular1 = angular - angularPointer;
    if (angular1 > 360) {
      angular1 -= 360;
    }
    double angular2 = angular + angularPointer;
    if (angular2 > 360) {
      angular2 -= 360;
    }
    double dx1 = getCenter().dx + cos(angular1 / CIRC * 2 * pi) * -1 * Radius.circular(radiusCircleBegin).x;
    double dy1 = getCenter().dy + sin(angular1 / CIRC * 2 * pi) * Radius.circular(radiusCircleBegin).y;
    returnList.add(new Offset(dx1, dy1));
    double dx2 = getCenter().dx + cos(angular2 / CIRC * 2 * pi) * -1 * Radius.circular(radiusCircleBegin).x;
    double dy2 = getCenter().dy + sin(angular2 / CIRC * 2 * pi) * Radius.circular(radiusCircleBegin).y;
    returnList.add(new Offset(dx2, dy2));
    double dx3 = getCenter().dx + cos(angular / CIRC * 2 * pi) * -1 * Radius.circular(radiusCircleEnd).x;
    double dy3 = getCenter().dy + sin(angular / CIRC * 2 * pi) * Radius.circular(radiusCircleEnd).y;
    returnList.add(new Offset(dx3, dy3));
    return returnList;
  }

  
}