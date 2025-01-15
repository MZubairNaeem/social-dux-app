import 'package:intl/intl.dart';

/// Converts a backend time string (e.g., "20:36:00") in UTC to local time
/// and formats it as per the provided pattern.
///
/// [backendTime] - Time string in "HH:mm:ss" format (assumed UTC).
/// [date] - Optional date to combine with the time; defaults to today.
/// [format] - The desired output format; defaults to 'hh:mm a'.
String formatBackendTimeToLocal({
  required String backendTime,
  DateTime? date,
  String format = 'hh:mm a',
}) {
  try {
    // Use the provided date or today's date
    String dateString =
        (date ?? DateTime.now()).toIso8601String().split('T').first;

    // Combine date and backend time into a DateTime object
    DateTime utcDateTime = DateTime.parse("$dateString$backendTime");

    // Convert to local time
    DateTime localDateTime = utcDateTime.toLocal();

    // Format the local time
    return DateFormat(format).format(localDateTime);
  } catch (e) {
    // Return a fallback value or handle errors
    return 'Invalid time';
  }
}
