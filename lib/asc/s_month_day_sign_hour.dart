import './s_sign_hour.dart';

// struct
class MonthDaySignHour {
  final int month;
  final int dayBegin;
  final int dayEnd;
  final List<SignHour> signHour;
  const MonthDaySignHour(this.month, this.dayBegin, this.dayEnd, this.signHour);
}