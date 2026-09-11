class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(double amount) {
    final isWhole = amount == amount.roundToDouble();
    final value = isWhole
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2).replaceAll('.', ',');
    return '$value €';
  }
}
