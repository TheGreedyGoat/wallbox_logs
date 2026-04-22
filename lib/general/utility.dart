import 'dart:math';

class Utility {
  /// rounds x to have a max number of `digits` after the .
  /// example:
  ///
  /// ```dart
  /// Utility.roundDouble(1.2345678, 3); // => 1.235
  /// ```
  ///
  static double roundDouble(double x, int digits) {
    var split = x.toString().split('.');
    split[1].replaceRange(min(digits, split.length - 1), null, '');

    return double.parse('${split[0]}.${split[1]}');
  }
}
