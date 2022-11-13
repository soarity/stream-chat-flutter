import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/sending_indicator_wrapper.dart';

import 'package:stream_chat_flutter/src/message_widget/username.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template bottomRow}
/// The bottom row of a [StreamMessageWidget].
///
/// Used in [MessageWidgetContent]. Should not be used elsewhere.
/// {@endtemplate}
class BottomRow extends StatelessWidget {
  /// {@macro bottomRow}
  const BottomRow({
    super.key,
    required this.isDeleted,
    required this.message,
    required this.showTimeStamp,
    required this.showUsername,
    required this.reverse,
    required this.showSendingIndicator,
    required this.hasUrlAttachments,
    required this.isGiphy,
    required this.isOnlyEmoji,
    required this.messageTheme,
    required this.streamChatTheme,
    required this.hasNonUrlAttachments,
    required this.streamChat,
    this.deletedBottomRowBuilder,
    this.usernameBuilder,
  });

  /// {@macro messageIsDeleted}
  final bool isDeleted;

  /// {@macro deletedBottomRowBuilder}
  final Widget Function(BuildContext, Message)? deletedBottomRowBuilder;

  /// {@macro message}
  final Message message;

  /// {@macro showTimestamp}
  final bool showTimeStamp;

  /// {@macro showUsername}
  final bool showUsername;

  /// {@macro reverse}
  final bool reverse;

  /// {@macro showSendingIndicator}
  final bool showSendingIndicator;

  /// {@macro hasUrlAttachments}
  final bool hasUrlAttachments;

  /// {@macro isGiphy}
  final bool isGiphy;

  /// {@macro isOnlyEmoji}
  final bool isOnlyEmoji;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  /// {@macro streamChatThemeData}
  final StreamChatThemeData streamChatTheme;

  /// {@macro streamChat}
  final StreamChatState streamChat;

  /// {@macro usernameBuilder}
  final Widget Function(BuildContext, Message)? usernameBuilder;

  @override
  Widget build(BuildContext context) {
    if (isDeleted) {
      return deletedBottomRowBuilder?.call(
            context,
            message,
          ) ??
          const Offstage();
    }

    final children = <WidgetSpan>[];

    const usernameKey = Key('username');

    children.addAll([
      if (showUsername)
        WidgetSpan(
          child: usernameBuilder?.call(context, message) ??
              Username(
                key: usernameKey,
                message: message,
                messageTheme: messageTheme,
              ),
        ),
      if (showTimeStamp)
        WidgetSpan(
          child: Text(
            Jiffy(message.createdAt.toLocal()).jm,
            style: messageTheme.createdAtStyle,
          ),
        ),
      if (showSendingIndicator)
        WidgetSpan(
          child: SendingIndicatorWrapper(
            messageTheme: messageTheme,
            message: message,
            hasNonUrlAttachments: hasNonUrlAttachments,
            streamChat: streamChat,
            streamChatTheme: streamChatTheme,
          ),
        ),
    ]);

    return Text.rich(
      TextSpan(
        children: [
          ...children,
        ].insertBetween(const WidgetSpan(child: SizedBox(width: 8))),
      ),
      maxLines: 1,
      textAlign: reverse ? TextAlign.right : TextAlign.left,
    );
  }
}
