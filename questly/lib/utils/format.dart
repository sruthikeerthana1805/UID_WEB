/// Formats 1240 as "1,240".
String formatNumber(int number) {
  final digits = number.abs().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return number < 0 ? '-$buffer' : buffer.toString();
}
