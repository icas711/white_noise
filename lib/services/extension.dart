
extension FormatDuration on Duration {
  String format() {

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final twoDigitHours = twoDigits(inHours);
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }
}

