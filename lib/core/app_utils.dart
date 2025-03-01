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

String? timeAgoFormatter(DateTime? dateTime) {
  if(dateTime == null) return null;
   try{
    final Duration difference = DateTime.now().difference(dateTime);
     if(difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()}y ago";
    } else if(difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()}m ago";
    } else if(difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if(difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if(difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }catch(_) {
    return null;
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