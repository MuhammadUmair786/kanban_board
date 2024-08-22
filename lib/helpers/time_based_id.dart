String getTimeBasedId() {
  return DateTime.now().microsecondsSinceEpoch.remainder(1 << 31).toString();
}
