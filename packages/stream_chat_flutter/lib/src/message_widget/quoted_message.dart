import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/quoted_message_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template quotedMessage}
/// A quoted message in a chat.
///
/// Used in [QuotedMessageCard]. Should not be used elsewhere.
/// {@endtemplate}
class QuotedMessage extends StatelessWidget {
  /// {@macro quotedMessage}
  const QuotedMessage({
    super.key,
    required this.message,
<<<<<<< HEAD
    required this.reverse,
    this.isDm = false,
=======
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
    required this.hasNonUrlAttachments,
    this.textBuilder,
  });

  /// {@macro message}
  final Message message;

<<<<<<< HEAD
  /// {@macro reverse}
  final bool reverse;

  ///
  final bool isDm;

=======
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final chatThemeData = StreamChatTheme.of(context);

    final isMyMessage = message.user?.id == streamChat.currentUser?.id;
    final isMyQuotedMessage =
        message.quotedMessage?.user?.id == streamChat.currentUser?.id;
    return StreamQuotedMessageWidget(
      isDm: isDm,
      message: message.quotedMessage!,
      messageTheme: isMyMessage
          ? chatThemeData.otherMessageTheme
          : chatThemeData.ownMessageTheme,
<<<<<<< HEAD
      reverse: reverse,
      showBorder: false,
=======
      reverse: !isMyQuotedMessage,
      textBuilder: textBuilder,
      padding: EdgeInsets.only(
        right: 8,
        left: 8,
        top: 8,
        bottom: hasNonUrlAttachments ? 8 : 0,
      ),
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
    );
  }
}
