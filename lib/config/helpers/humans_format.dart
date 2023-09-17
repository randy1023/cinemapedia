import 'package:intl/intl.dart';

class HumansFormat {
  static String number(double number, [int decimals = 0]) {
    final formatterNumber = NumberFormat.compactCurrency(
            decimalDigits: decimals, symbol: '', locale: 'en')
        .format(number);

    return formatterNumber;
  }
}
