class DateTimeHelper {
  /// Convert a digit to 2 digits, with a preceding 0.
  ///
  /// This is for like 1 -> 01, 9 -> 09.
  static String convertToTwoChars(int num) =>
      "$num".length > 1 ? "$num" : "0$num";

  /// Convert a datetime to a common full Date
  static String toDate(DateTime dt) => "${convertToTwoChars(dt.month)}/"
      "${convertToTwoChars(dt.day)}/"
      "${convertToTwoChars(dt.year)}";

  /// Convert a datetime to a common full Date + Time
  static String toDateAndTime(DateTime dt) => "${convertToTwoChars(dt.year)}-"
      "${convertToTwoChars(dt.month)}-"
      "${convertToTwoChars(dt.day)} "
      "${convertToTwoChars(dt.hour)}:"
      "${convertToTwoChars(dt.minute)}:"
      "${convertToTwoChars(dt.second)}";

  /// Convert a string to a datetime from mm/dd/yyyy
  static DateTime fromDate(String date) => DateTime.parse(
      "${date.substring(6, 10)}-${date.substring(3, 5)}-${date.substring(0, 2)}");
}
