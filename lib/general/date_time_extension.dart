import 'package:wallbox_logs/general/utility.dart';

extension DateTimeExtension on DateTime {
  String toNiceDateString() =>
      '${Utility.minDigits(day, 2)}.${Utility.minDigits(month, 2)}.$year';

  /// extracts a nicely readable time-only-String from [date]
  String toNiceTimeString([bool showSeconds = false]) =>
      '${Utility.minDigits(hour, 2)}:${Utility.minDigits(minute, 2)}${showSeconds ? ':${Utility.minDigits(second, 2)}' : ''}';
}
