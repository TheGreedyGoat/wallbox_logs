/// A collection of general functionalities
class Utility {
  /// as soon as compare returns 0 or smaller or if the end of the list is reached, element is inserted
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

  static String niceDateString(DateTime date) {
    return '${minDigits(date.day, 2)}.${minDigits(date.month, 2)}.${date.year}';
  }

  static String niceTimeString(DateTime date) {
    return '${minDigits(date.hour, 2)}:${minDigits(date.minute, 2)}';
  }

  static String minDigits(int number, int totalDigits) {
    String result = number.toString();
    while (result.length < totalDigits) {
      result = '0$result';
    }

    return result;
  }
}
