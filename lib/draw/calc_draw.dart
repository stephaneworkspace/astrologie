import 'dart:math';

import 'dart:ui';

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

  Offset getCenter() {
    //return new Offset(size.width / 2, size.height / 2);
    return new Offset(getSizeWH() / 2, getSizeWH() / 2);
  }
}