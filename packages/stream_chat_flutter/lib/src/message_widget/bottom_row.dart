import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/sending_indicator_builder.dart';
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
    required this.showInChannel,
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
    this.sendingIndicatorBuilder,
  });

  /// {@macro messageIsDeleted}
  final bool isDeleted;

  /// {@macro deletedBottomRowBuilder}
  final Widget Function(BuildContext, Message)? deletedBottomRowBuilder;

  /// {@macro message}
  final Message message;

  /// {@macro showInChannelIndicator}
  final bool showInChannel;

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

  /// {@macro sendingIndicatorBuilder}
  final Widget Function(BuildContext, Message)? sendingIndicatorBuilder;

  /// {@template copyWith}
  /// Creates a copy of [BottomRow] with specified attributes
  /// overridden.
  /// {@endtemplate}
  BottomRow copyWith({
    Key? key,
    bool? isDeleted,
    Message? message,
    bool? showInChannel,
    bool? showTimeStamp,
    bool? showUsername,
    bool? reverse,
    bool? showSendingIndicator,
    bool? hasUrlAttachments,
    bool? isGiphy,
    bool? isOnlyEmoji,
    StreamMessageThemeData? messageTheme,
    StreamChatThemeData? streamChatTheme,
    bool? hasNonUrlAttachments,
    StreamChatState? streamChat,
    Widget Function(BuildContext, Message)? deletedBottomRowBuilder,
    Widget Function(BuildContext, Message)? usernameBuilder,
    Widget Function(BuildContext, Message)? sendingIndicatorBuilder,
  }) =>
      BottomRow(
        key: key ?? this.key,
        isDeleted: isDeleted ?? this.isDeleted,
        message: message ?? this.message,
        showInChannel: showInChannel ?? this.showInChannel,
        showTimeStamp: showTimeStamp ?? this.showTimeStamp,
        showUsername: showUsername ?? this.showUsername,
        reverse: reverse ?? this.reverse,
        showSendingIndicator: showSendingIndicator ?? this.showSendingIndicator,
        hasUrlAttachments: hasUrlAttachments ?? this.hasUrlAttachments,
        isGiphy: isGiphy ?? this.isGiphy,
        isOnlyEmoji: isOnlyEmoji ?? this.isOnlyEmoji,
        messageTheme: messageTheme ?? this.messageTheme,
        streamChatTheme: streamChatTheme ?? this.streamChatTheme,
        hasNonUrlAttachments: hasNonUrlAttachments ?? this.hasNonUrlAttachments,
        streamChat: streamChat ?? this.streamChat,
        deletedBottomRowBuilder:
            deletedBottomRowBuilder ?? this.deletedBottomRowBuilder,
        usernameBuilder: usernameBuilder ?? this.usernameBuilder,
        sendingIndicatorBuilder:
            sendingIndicatorBuilder ?? this.sendingIndicatorBuilder,
      );

  @override
  Widget build(BuildContext context) {
    if (isDeleted) {
      final deletedBottomRowBuilder = this.deletedBottomRowBuilder;
      if (deletedBottomRowBuilder != null) {
        return deletedBottomRowBuilder(context, message);
      }
    }

<<<<<<< HEAD
    final mediaQueryData = MediaQuery.of(context);
=======
    final threadParticipants = message.threadParticipants?.take(2);
    final showThreadParticipants = threadParticipants?.isNotEmpty == true;
    final replyCount = message.replyCount;

    var msg = context.translations.threadReplyLabel;
    if (showThreadReplyIndicator && replyCount! > 1) {
      msg = context.translations.threadReplyCountText(replyCount);
    }

    Future<void> _onThreadTap() async {
      try {
        var message = this.message;
        if (showInChannel) {
          final channel = StreamChannel.of(context);
          message = await channel.getMessage(message.parentId!);
        }
        return onThreadTap!(message);
      } catch (e, stk) {
        debugPrint('Error while fetching message: $e, $stk');
      }
    }

    const usernameKey = Key('username');

    final children = [
      if (showUsername)
        usernameBuilder?.call(context, message) ??
            Username(
              key: usernameKey,
              message: message,
              messageTheme: messageTheme,
            ),
      if (showTimeStamp)
        Text(
          Jiffy.parseFromDateTime(message.createdAt.toLocal()).jm,
          style: messageTheme.createdAtStyle,
        ),
      if (showSendingIndicator)
        sendingIndicatorBuilder?.call(context, message) ??
            SendingIndicatorBuilder(
              messageTheme: messageTheme,
              message: message,
              hasNonUrlAttachments: hasNonUrlAttachments,
              streamChat: streamChat,
              streamChatTheme: streamChatTheme,
            ),
    ];

    final showThreadTail =
        (showThreadReplyIndicator || showInChannel) && !isOnlyEmoji;

    final threadIndicatorWidgets = [
      if (showThreadTail)
        // Added builder to use the nearest context to get the right
        // textScaleFactor value.
        Builder(
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: context.textScaleFactor *
                    ((messageTheme.repliesStyle?.fontSize ?? 1) / 2),
              ),
              child: CustomPaint(
                size: const Size(16, 32) * context.textScaleFactor,
                painter: ThreadReplyPainter(
                  context: context,
                  color: messageTheme.messageBorderColor,
                  reverse: reverse,
                ),
              ),
            );
          },
        ),
      if (showInChannel || showThreadReplyIndicator) ...[
        if (showThreadParticipants)
          SizedBox.fromSize(
            size: Size((threadParticipants!.length * 8.0) + 8, 16),
            child: ThreadParticipants(
              threadParticipants: threadParticipants,
              streamChatTheme: streamChatTheme,
            ),
          ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _onThreadTap,
            child: Text(msg, style: messageTheme.repliesStyle),
          ),
        ),
      ],
    ];

    if (reverse) {
      children.addAll(threadIndicatorWidgets.reversed);
    } else {
      children.insertAll(0, threadIndicatorWidgets);
    }

>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
    return Text.rich(
      TextSpan(
        children: [
          if (showTimeStamp)
            WidgetSpan(
              child: MediaQuery(
                data: mediaQueryData.copyWith(textScaleFactor: 1),
                child: Text(
                  Jiffy.parseFromDateTime(message.createdAt.toLocal()).jm,
                  style: messageTheme.createdAtStyle,
                ),
              ),
            ),
          if (showSendingIndicator)
            WidgetSpan(
              child: MediaQuery(
                data: mediaQueryData.copyWith(textScaleFactor: 1),
                child: SendingIndicatorBuilder(
                  messageTheme: messageTheme,
                  message: message,
                  hasNonUrlAttachments: hasNonUrlAttachments,
                  streamChat: streamChat,
                  streamChatTheme: streamChatTheme,
                ),
              ),
            ),
        ].insertBetween(const WidgetSpan(child: SizedBox(width: 6))),
      ),
      maxLines: 1,
      textAlign: TextAlign.right,
    );
  }
}
