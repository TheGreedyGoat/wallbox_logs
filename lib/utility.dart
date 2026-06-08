/// A collection of general functionalities
class Utility {
  /// inserts the [element] into the [list].
  /// ---
  /// - [list] : The list to insert the element to. NOTE: This list should already be sorted according to the same logic as passed with [compare].
  /// - [element] : The element to insert
  /// - [compare] : int function to check if a one element is supposed to come before or after the other:
  /// as soon as compare returns 0 or smaller, the [element] gets inserted.
  static void insertToList<T>(
    List<T> list,
    T element,
    int Function(T, T) compare,
  ) {
    int i = 0;
    for (; i < list.length; i++) {
      int check = compare(element, list[i]);
      if (check <= 0) {
        break;
      }
    }
    list.insert(i, element);
  }

  static RegExp doubleInputRegExp(int fractions, [bool addPrefix = true]) =>
      RegExp(r'^\d+[.,]?\d{0,#}|^$'.replaceAll('#', fractions.toString()));

  static String niceFullDateString(DateTime date) =>
      '${niceDateString(date)}, ${niceTimeString(date)}';

  /// extracts a nicely readable only-date- String from [date] eg 02.10.2024
  static String niceDateString(DateTime date) {
    return '${minDigits(date.day, 2)}.${minDigits(date.month, 2)}.${date.year}';
  }

  /// extracts a nicely readable time-only-String from [date]
  static String niceTimeString(DateTime date, [bool showSeconds = false]) {
    return '${minDigits(date.hour, 2)}:${minDigits(date.minute, 2)}${showSeconds ? ':${minDigits(date.second, 2)}' : ''}';
  }

  /// returns the [number] as a String. If it has less than [numDigits] digits, they are filled with leading zeros:

  /// ___
  /// Example
  /// ```dart
  /// print(minDigits(6, 2)); // => '06'
  /// print(minDigits(1, 5)); // => '00001'
  ///
  /// print(minDigits(10, 2)); // => '10'
  /// print(minDigits(10, 3)); // => '10'
  ///
  /// ```
  static String minDigits(int number, int numDigits) {
    String result = number.toString();
    while (result.length < numDigits) {
      result = '0$result';
    }

    return result;
  }

  static int euroToCents(double euros) => (euros * 100).floor();
  static double centsToEuros(int cents) => cents.toDouble() / 100;

  static String costsDisplay(int cents) =>
      '${centsToEuros(cents).toStringAsFixed(2)} €';

  static const List<String> _monthNames = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];

  static String monthName(int month) {
    while (month < 1) month += 12;
    while (month > 12) month -= 12;
    return _monthNames[month - 1];
  }
}

void printList(List list) {
  for (final e in list) {
    print('$e \n');
  }
}
