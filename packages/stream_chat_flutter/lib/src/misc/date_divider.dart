import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/src/utils/date_formatter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamDateDivider}
/// Shows a date divider depending on the date difference
/// {@endtemplate}
class StreamDateDivider extends StatelessWidget {
  /// {@macro streamDateDivider}
  const StreamDateDivider({
    super.key,
    required this.dateTime,
    this.uppercase = false,
    this.formatter,
  });

  /// [DateTime] to display
  final DateTime dateTime;

  /// If text is uppercase
  final bool uppercase;

  /// Custom formatter for the date
  final DateFormatter? formatter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Theme.of(context).colorScheme.onSecondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: StreamTimestamp(
            date: dateTime.toLocal(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
            formatter: (context, date) {
              final timestamp = switch (date) {
                _ when date.isToday => context.translations.todayLabel,
                _ when date.isYesterday => context.translations.yesterdayLabel,
                _ when date.isWithinAWeek => Jiffy.parseFromDateTime(date).EEEE,
                _ when date.isWithinAYear => Jiffy.parseFromDateTime(date).MMMd,
                _ => Jiffy.parseFromDateTime(date).yMMMd,
              };

              if (uppercase) return timestamp.toUpperCase();
              return timestamp;
            },
          ),
        ),
      ),
    );
  }
}
