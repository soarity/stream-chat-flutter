import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    required this.reverse,
    this.isDm = false,
    required this.hasNonUrlAttachments,
  });

  /// {@macro message}
  final Message message;

  /// {@macro reverse}
  final bool reverse;

  ///
  final bool isDm;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final chatThemeData = StreamChatTheme.of(context);

    final isMyMessage = message.user?.id == streamChat.currentUser?.id;
    return StreamQuotedMessageWidget(
      isDm: isDm,
      message: message.quotedMessage!,
      messageTheme: isMyMessage
          ? chatThemeData.otherMessageTheme
          : chatThemeData.ownMessageTheme,
      reverse: reverse,
      padding: EdgeInsets.only(
        right: 3.w,
        left: 3.w,
        top: 3.h,
        bottom: hasNonUrlAttachments ? 3.h : 0,
      ),
    );
  }
}
