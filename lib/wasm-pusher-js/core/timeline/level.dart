enum TimelineLevel {
  error(3),
  info(6),
  debug(7);

  const TimelineLevel(this.value);

  final int value;
}
