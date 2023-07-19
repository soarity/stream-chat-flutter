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
    final theme = StreamChatTheme.of(context);
    final message = this.message.replaceMentions(linkify: false);

    final messageText = message.text;
    if (messageText == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: SizedBox(
        width: 240.w,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onMessageTap == null ? null : () => onMessageTap!(message),
          child: Center(
            child: Material(
              shape: const StadiumBorder(),
              elevation: 1,
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                child: Text(
                  message.text!,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: theme.textTheme.footnote.copyWith(
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
