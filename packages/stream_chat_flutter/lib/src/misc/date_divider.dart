import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final createdAt = Jiffy(dateTime);
    final now = Jiffy(DateTime.now());

    var dayInfo = createdAt.MMMd;
    if (createdAt.isSame(now, Units.DAY)) {
      dayInfo = context.translations.todayLabel;
    } else if (createdAt.isSame(now.subtract(days: 1), Units.DAY)) {
      dayInfo = context.translations.yesterdayLabel;
    } else if (createdAt.isAfter(now.subtract(days: 7), Units.DAY)) {
      dayInfo = createdAt.EEEE;
    } else if (createdAt.isAfter(now.subtract(years: 1), Units.DAY)) {
      dayInfo = createdAt.MMMd;
    }

    if (uppercase) dayInfo = dayInfo.toUpperCase();

    return Center(
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        color: Theme.of(context).colorScheme.onSecondary,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          child: Text(
            dayInfo,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
      ),
    );
  }
}
