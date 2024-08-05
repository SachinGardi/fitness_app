
import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  double get mediaQueryHeight => MediaQuery.of(this).size.height;
  double get mediaQueryWidth => MediaQuery.of(this).size.width;
}
