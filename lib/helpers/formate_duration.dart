String formatDuration(Duration duration) {
  int days = duration.inDays;
  int hours = duration.inHours % 24;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  List<String> parts = [];

  if (days > 0) {
    parts.add('$days days');
  }
  if (hours > 0) {
    parts.add('$hours hours');
  }
  if (minutes > 0) {
    parts.add('$minutes minutes');
  }
  if (seconds > 0) {
    parts.add('$seconds seconds');
  }

  return parts.join(' ');
}
