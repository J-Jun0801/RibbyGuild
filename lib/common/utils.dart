import 'package:intl/intl.dart';

String withComma(int number) {
  var f = NumberFormat('###,###,###,###');
  return f.format(number);
}
