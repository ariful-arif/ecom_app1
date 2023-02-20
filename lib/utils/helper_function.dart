

import 'package:intl/intl.dart';

String getFormattedDate(DateTime dateTime, String format) {
  return DateFormat(format).format(dateTime);
}