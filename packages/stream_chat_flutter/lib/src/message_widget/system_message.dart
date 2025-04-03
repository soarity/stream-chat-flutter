import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
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
  final OnMessageTap? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final message = this.message.replaceMentions(linkify: false);

    final messageText = message.text;
    if (messageText == null) return const Empty();

<<<<<<< HEAD:packages/stream_chat_flutter/lib/src/misc/system_message.dart
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                messageText,
                textAlign: TextAlign.center,
                softWrap: true,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
              ),
            ),
=======
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: switch (onMessageTap) {
          final onTap? => () => onTap(message),
          _ => null,
        },
        child: Text(
          messageText,
          softWrap: true,
          textAlign: TextAlign.center,
          style: theme.textTheme.captionBold.copyWith(
            color: theme.colorTheme.textLowEmphasis,
>>>>>>> 78604c60fb775e9251282984293587b8888c7a46:packages/stream_chat_flutter/lib/src/message_widget/system_message.dart
          ),
        ),
      ),
    );
  }
}
