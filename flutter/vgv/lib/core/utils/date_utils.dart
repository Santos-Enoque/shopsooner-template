import 'package:intl/intl.dart';

/// Utilities for working with dates
class AppDateUtils {
  /// Format a date as a readable string (e.g., "Jan 1, 2023")
  static String formatDate(DateTime date) {
    final formatter = DateFormat.yMMMd();
    return formatter.format(date);
  }

  /// Format a date with time (e.g., "Jan 1, 2023 12:30 PM")
  static String formatDateTime(DateTime date) {
    final formatter = DateFormat.yMMMd().add_jm();
    return formatter.format(date);
  }

  /// Get relative time description (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
