class AppNumberFormatter {
  AppNumberFormatter._();

  static String compact(num value) {
    if (value < 1000) {
      return value.toInt().toString();
    }

    if (value < 1000000) {
      return _formatWithSuffix(value / 1000, 'K');
    }

    if (value < 1000000000) {
      return _formatWithSuffix(value / 1000000, 'M');
    }

    return _formatWithSuffix(value / 1000000000, 'B');
  }

  static String _formatWithSuffix(double value, String suffix) {
    final rounded = double.parse(value.toStringAsFixed(1));

    final isWhole = rounded == rounded.truncateToDouble();

    final formatted = isWhole ? rounded.toInt().toString() : rounded.toString();

    return '$formatted$suffix';
  }
}

extension NumberFormattingExtension on num {
  String get compact => AppNumberFormatter.compact(this);
}