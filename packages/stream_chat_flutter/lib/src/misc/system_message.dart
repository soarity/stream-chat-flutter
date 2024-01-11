import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamSystemMessage}
/// {@endtemplate}
class StreamSystemMessage extends StatelessWidget {
  /// {@macro streamSystemMessage}
  const StreamSystemMessage({
    super.key,
    required this.message,
    this.onMessageTap,
  });

  /// The message to display.
  final Message message;

  /// The action to perform when tapping on the message.
  final void Function(Message)? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final message = this.message.replaceMentions();

    final messageText = message.text;
    if (messageText == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
        horizontal: 20.w,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onMessageTap == null ? null : () => onMessageTap!(message),
        child: Center(
          child: Material(
            shape: const StadiumBorder(),
            elevation: 1,
            color: Theme.of(context).colorScheme.onSecondary,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              child: Text(
                messageText,
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
