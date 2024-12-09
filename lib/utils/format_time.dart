import 'package:intl/intl.dart';

String formatTime(String inputDate) {
  final DateTime inputTime =
      DateTime.parse(inputDate).toUtc(); // Parse input and convert to UTC
  final DateTime convertedTime =
      inputTime.add(const Duration(hours: 5)); // Convert to UTC+05:00
  final DateTime now = DateTime.now()
      .toUtc()
      .add(const Duration(hours: 5)); // Current time in UTC+05:00

  // Calculate difference
  final Duration difference = now.difference(convertedTime);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else {
    final DateFormat dateFormat = DateFormat('d MMM yyyy');
    return dateFormat.format(inputTime);
  }
}
