import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Locale-aware date formatting. Falls back to French for languages intl
/// has no data for (Tamazight).
abstract final class DateFormats {
  static String get _locale {
    final code = Get.locale?.languageCode ?? 'fr';
    return DateFormat.localeExists(code) ? code : 'fr';
  }

  /// `12 Nov, 14:05` (list rows, where space is tight)
  static String compact(DateTime date) => DateFormat.MMMd(_locale).add_Hm().format(date.toLocal());

  /// `12 Nov 2026, 14:05`
  static String dateTime(DateTime date) =>
      DateFormat.yMMMd(_locale).add_Hm().format(date.toLocal());

  /// `Thursday 12 November 2026`
  static String longDate(DateTime date) => DateFormat.yMMMMEEEEd(_locale).format(date.toLocal());

  /// Fixed format for thermal tickets: `2026-11-12 14:05`.
  static String ticket(DateTime date) => DateFormat('yyyy-MM-dd HH:mm').format(date.toLocal());
}
