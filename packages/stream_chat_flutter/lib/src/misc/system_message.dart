import 'package:flutter/material.dart';
<<<<<<< HEAD:packages/stream_chat_flutter/lib/src/system_message.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/src/extension.dart';
=======
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0:packages/stream_chat_flutter/lib/src/misc/system_message.dart
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
              color: theme.colorTheme.overlay,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                child: Text(
                  message.text!,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: theme.textTheme.footnote.copyWith(
                    color: theme.colorTheme.barsBg,
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
