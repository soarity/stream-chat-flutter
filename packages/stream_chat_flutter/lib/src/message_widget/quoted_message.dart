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
    this.minimumWidth = 0,
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

  /// {@macro minimumWidth}
  final double minimumWidth;

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
      showBorder: false,
      minimumWidth: minimumWidth,
      padding: EdgeInsets.only(bottom: 6.h),
    );
  }
}
