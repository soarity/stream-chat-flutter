import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template unreadMessagesSeparator}
/// {@endtemplate}
class UnreadMessagesSeparator extends StatelessWidget {
  /// {@macro unreadMessagesSeparator}
  const UnreadMessagesSeparator({
    super.key,
    required this.unreadCount,
  });

  /// Number of unread messages.
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          child: Text(
            context.translations.unreadMessagesSeparatorText(unreadCount),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ),
      ),
    );
  }
}
