import './e_type_signe.dart';

// struct
class SignHour {
  final TypeSigne typeAsc;
  final DateTime hourBegin;
  final DateTime hourEnd;
  const SignHour(this.typeAsc, this.hourBegin, this.hourEnd);
}