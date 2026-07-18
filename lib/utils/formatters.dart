import 'package:intl/intl.dart';

class Formatters {
  /// Format a DateTime to "12 Aug 2026"
  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date.toLocal());
  }

  /// Format salary in INR — converts raw rupee integer into
  /// a short "L" (lakh) representation, e.g. 3000000 → ₹30L
  static String formatSalary(int? amount) {
    if (amount == null) return 'N/A';
    if (amount >= 10000000) {
      // Crore range
      final cr = amount / 10000000;
      return '₹${_trimTrailingZero(cr)}Cr';
    }
    if (amount >= 100000) {
      final l = amount / 100000;
      return '₹${_trimTrailingZero(l)}L';
    }
    // Below 1 lakh — just format with comma separators
    return '₹${NumberFormat('#,##,##0').format(amount)}';
  }

  static String _trimTrailingZero(double value) {
    if (value == value.truncate()) {
      return value.truncate().toString();
    }
    return value.toStringAsFixed(1);
  }

  /// Format salary range, e.g. "₹30L – ₹35L"
  static String formatSalaryRange(int? min, int? max) {
    if (min == null && max == null) return 'Not disclosed';
    if (min != null && max != null) {
      return '${formatSalary(min)} – ${formatSalary(max)}';
    }
    if (min != null) return '${formatSalary(min)}+';
    return 'Up to ${formatSalary(max)}';
  }

  /// Format experience range, e.g. "4–14 yrs"
  static String formatExperience(int min, int max) {
    if (min == max) return '$min yr${min == 1 ? '' : 's'}';
    return '$min–$max yrs';
  }
}
