import 'package:intl/intl.dart';



/// Converting the date string to a formatted date
/// Input date format: yyyy-MM-dd
/// Output date format: MMMM d, y
String? dateFormatter(String date) {
  if(date.isEmpty) return null;
  try{
    final DateTime dateTime = DateTime.parse(date);
    final String formattedDate = DateFormat("MMMM d, y").format(dateTime);
    return formattedDate;
  }catch(_) {
    return date;
  }

}


DateTime? formatTimestamp(double? timestamp) {
  if (timestamp == null) return null;
  try {
    // Convert timestamp (seconds) to milliseconds
    int millisecondsSinceEpoch = (timestamp * 1000).toInt();
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

  return dateTime;
  } catch (_) {
    return null;
  }
}