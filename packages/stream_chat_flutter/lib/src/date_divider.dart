import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// {@macro date_divider}
@Deprecated("Use 'StreamDateDivider' instead")
typedef DateDivider = StreamDateDivider;

/// {@template date_divider}
/// It shows a date divider depending on the date difference
/// {@endtemplate}
class StreamDateDivider extends StatelessWidget {
  /// Constructor for creating a [StreamDateDivider]
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

    final chatThemeData = StreamChatTheme.of(context);
    return Center(
      child: Material(
        shape: const StadiumBorder(),
        elevation: 1,
        color: chatThemeData.colorTheme.overlayDark,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          child: Text(
            dayInfo,
            style: chatThemeData.textTheme.footnoteBold.copyWith(
              color: chatThemeData.colorTheme.barsBg,
            ),
          ),
        ),
      ),
    );
  }
}
