import 'package:intl/intl.dart';

final DateFormat shortDate = DateFormat('dd MMM yyyy');
final DateFormat fullDate = DateFormat('EEEE, dd MMMM yyyy');
String money(double value) => NumberFormat('#,##0.00').format(value);
