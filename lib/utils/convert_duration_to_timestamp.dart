String convertDurationToTimestamp(String durationInMinutes) {
  // Convert the string to an integer
  int minutes = int.parse(durationInMinutes);

  // Create a Duration object from the minutes
  Duration duration = Duration(minutes: minutes);

  // Get the current DateTime
  DateTime now = DateTime.now();

  // Add the duration to the current DateTime to get the timestamp
  DateTime timestamp = now.add(duration);

  // Return the timestamp as a string in ISO 8601 format
  return timestamp.toIso8601String();
}
