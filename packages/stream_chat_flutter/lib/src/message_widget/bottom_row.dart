import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/sending_indicator_builder.dart';
<<<<<<< HEAD
=======
import 'package:stream_chat_flutter/src/message_widget/thread_painter.dart';
import 'package:stream_chat_flutter/src/message_widget/thread_participants.dart';
import 'package:stream_chat_flutter/src/message_widget/username.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
>>>>>>> 78604c60fb775e9251282984293587b8888c7a46
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
    required this.showEditedLabel,
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

  /// {@macro showEdited}
  final bool showEditedLabel;

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
    bool? showEditedLabel,
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
        showEditedLabel: showEditedLabel ?? this.showEditedLabel,
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

    final isEdited = message.messageTextUpdatedAt != null;

<<<<<<< HEAD
    final mediaQueryData = MediaQuery.of(context);
=======
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
        return onThreadTap?.call(message);
      } catch (e, stk) {
        debugPrint('Error while fetching message: $e, $stk');
      }
    }

    const usernameKey = Key('username');

    final children = [
      if (showSendingIndicator)
        switch (sendingIndicatorBuilder) {
          final builder? => builder(context, message),
          _ => SendingIndicatorBuilder(
              messageTheme: messageTheme,
              message: message,
              hasNonUrlAttachments: hasNonUrlAttachments,
              streamChat: streamChat,
              streamChatTheme: streamChatTheme,
            ),
        },
      if (showUsername)
        switch (usernameBuilder) {
          final builder? => builder(context, message),
          _ => Username(
              key: usernameKey,
              message: message,
              messageTheme: messageTheme,
            ),
        },
      if (showEditedLabel && isEdited)
        Text(
          context.translations.editedMessageLabel,
          style: messageTheme.createdAtStyle,
        ),
      if (showTimeStamp)
        StreamTimestamp(
          date: message.createdAt.toLocal(),
          style: messageTheme.createdAtStyle,
          formatter: (_, date) => Jiffy.parseFromDateTime(date).jm,
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

>>>>>>> 78604c60fb775e9251282984293587b8888c7a46
    return Text.rich(
      TextSpan(
        children: [
          if (showEditedLabel && isEdited)
            WidgetSpan(
              child: MediaQuery(
                data: mediaQueryData.copyWith(textScaler: TextScaler.noScaling),
                child: Text(
                  context.translations.editedMessageLabel,
                  style: messageTheme.createdAtStyle,
                ),
              ),
            ),
          if (showTimeStamp)
            WidgetSpan(
              child: MediaQuery(
                data: mediaQueryData.copyWith(textScaler: TextScaler.noScaling),
                child: Text(
                  Jiffy.parseFromDateTime(message.createdAt.toLocal()).jm,
                  style: messageTheme.createdAtStyle,
                ),
              ),
            ),
          if (showSendingIndicator)
            WidgetSpan(
              child: MediaQuery(
                data: mediaQueryData.copyWith(textScaler: TextScaler.noScaling),
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
