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
  });

  /// [DateTime] to display
  final DateTime dateTime;

  /// If text is uppercase
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final createdAt = Jiffy.parseFromDateTime(dateTime);
    final now = Jiffy.parseFromDateTime(DateTime.now());

    var dayInfo = createdAt.MMMd;
    if (createdAt.isSame(now, unit: Unit.day)) {
      dayInfo = context.translations.todayLabel;
    } else if (createdAt.isSame(now.subtract(days: 1), unit: Unit.day)) {
      dayInfo = context.translations.yesterdayLabel;
    } else if (createdAt.isAfter(now.subtract(days: 7), unit: Unit.day)) {
      dayInfo = createdAt.EEEE;
    } else if (createdAt.isAfter(now.subtract(years: 1), unit: Unit.day)) {
      dayInfo = createdAt.MMMd;
    }

    if (uppercase) dayInfo = dayInfo.toUpperCase();

    return Center(
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Theme.of(context).colorScheme.onSecondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            dayInfo,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
=======
    final chatThemeData = StreamChatTheme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
          color: chatThemeData.colorTheme.overlayDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: StreamTimestamp(
          date: dateTime.toLocal(),
          style: chatThemeData.textTheme.footnote.copyWith(
            color: chatThemeData.colorTheme.barsBg,
>>>>>>> 78604c60fb775e9251282984293587b8888c7a46
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
    );
  }
}
