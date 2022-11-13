import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/src/message_widget/message_widget_content_components.dart';
import 'package:stream_chat_flutter/src/message_widget/username.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template messageWidgetContent}
/// The main content of a [StreamMessageWidget].
///
/// Should not be used outside of [MessageWidget.
/// {@endtemplate}
class MessageWidgetContent extends StatelessWidget {
  /// {@macro messageWidgetContent}
  const MessageWidgetContent({
    super.key,
    required this.isDm,
    required this.hideUsername,
    required this.botBuilder,
    required this.reverse,
    required this.isPinned,
    required this.showPinHighlight,
    required this.showBottomRow,
    required this.message,
    required this.showUserAvatar,
    required this.avatarWidth,
    required this.showReactions,
    required this.messageTheme,
    required this.shouldShowReactions,
    required this.streamChatTheme,
    required this.isFailedState,
    required this.hasQuotedMessage,
    required this.hasUrlAttachments,
    required this.hasNonUrlAttachments,
    required this.isOnlyEmoji,
    required this.isGiphy,
    required this.attachmentBuilders,
    required this.attachmentPadding,
    required this.textPadding,
    required this.showReactionPickerIndicator,
    required this.translateUserAvatar,
    required this.bottomRowPadding,
    required this.streamChat,
    required this.showSendingIndicator,
    required this.showTimeStamp,
    required this.showUsername,
    required this.messageWidget,
    this.onUserAvatarTap,
    this.borderRadiusGeometry,
    this.borderSide,
    this.shape,
    this.onQuotedMessageTap,
    this.onMentionTap,
    this.onLinkTap,
    this.textBuilder,
    this.bottomRowBuilder,
    this.deletedBottomRowBuilder,
    this.userAvatarBuilder,
    this.usernameBuilder,
  });

  ///  Whether the widget is to be used for Direct Message or Group Message
  ///
  /// Defaults to false
  final bool isDm;

  /// checks if the username should be hidden
  final bool hideUsername;

  /// Widget builder for building bot message
  final Widget Function(BuildContext, Message)? botBuilder;

  /// {@macro reverse}
  final bool reverse;

  /// {@macro isPinned}
  final bool isPinned;

  /// {@macro showPinHighlight}
  final bool showPinHighlight;

  /// {@macro showBottomRow}
  final bool showBottomRow;

  /// {@macro message}
  final Message message;

  /// {@macro showUserAvatar}
  final DisplayWidget showUserAvatar;

  /// The width of the avatar.
  final double avatarWidth;

  /// {@macro showReactions}
  final bool showReactions;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  /// {@macro shouldShowReactions}
  final bool shouldShowReactions;

  /// {@macro onUserAvatarTap}
  final void Function(User)? onUserAvatarTap;

  /// {@macro streamChatThemeData}
  final StreamChatThemeData streamChatTheme;

  /// {@macro isFailedState}
  final bool isFailedState;

  /// {@macro borderRadiusGeometry}
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// {@macro borderSide}
  final BorderSide? borderSide;

  /// {@macro shape}
  final ShapeBorder? shape;

  /// {@macro hasQuotedMessage}
  final bool hasQuotedMessage;

  /// {@macro hasUrlAttachments}
  final bool hasUrlAttachments;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  /// {@macro isOnlyEmoji}
  final bool isOnlyEmoji;

  /// {@macro isGiphy}
  final bool isGiphy;

  /// {@macro attachmentBuilders}
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// {@macro attachmentPadding}
  final EdgeInsetsGeometry attachmentPadding;

  /// {@macro textPadding}
  final EdgeInsets textPadding;

  /// {@macro onQuotedMessageTap}
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// {@macro onMentionTap}
  final void Function(User)? onMentionTap;

  /// {@macro onLinkTap}
  final void Function(String)? onLinkTap;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  /// {@macro showReactionPickerIndicator}
  final bool showReactionPickerIndicator;

  /// {@macro translateUserAvatar}
  final bool translateUserAvatar;

  /// The padding to use for this widget.
  final double bottomRowPadding;

  /// {@macro bottomRowBuilder}
  final Widget Function(BuildContext, Message)? bottomRowBuilder;

  /// {@macro streamChat}
  final StreamChatState streamChat;

  /// {@macro showSendingIndicator}
  final bool showSendingIndicator;

  /// {@macro showTimestamp}
  final bool showTimeStamp;

  /// {@macro showUsername}
  final bool showUsername;

  /// {@macro deletedBottomRowBuilder}
  final Widget Function(BuildContext, Message)? deletedBottomRowBuilder;

  /// {@macro messageWidget}
  final StreamMessageWidget messageWidget;

  /// {@macro userAvatarBuilder}
  final Widget Function(BuildContext, User)? userAvatarBuilder;

  /// {@macro usernameBuilder}
  final Widget Function(BuildContext, Message)? usernameBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isPinned && showPinHighlight
          ? EdgeInsets.symmetric(vertical: 10.h)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment:
            reverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message.pinned && message.pinnedBy != null && showPinHighlight)
            PinnedMessage(
              pinnedBy: message.pinnedBy!,
              currentUser: streamChat.currentUser!,
            ),
          if (!isDm &&
              !reverse &&
              showUserAvatar == DisplayWidget.show &&
              message.user != null &&
              !hideUsername)
            Padding(
              padding: EdgeInsets.only(bottom: 2.h, left: 8.w),
              child: Username(
                key: const Key('usernameKey'),
                messageTheme: messageTheme,
                message: message,
              ),
            ),
          PortalTarget(
            visible: isMobileDevice && showReactions,
            portalFollower: isMobileDevice && showReactions
                ? ReactionIndicator(
                    message: message,
                    messageTheme: messageTheme,
                    ownId: streamChat.currentUser!.id,
                    reverse: reverse,
                    shouldShowReactions: shouldShowReactions,
                    onTap: () => _showMessageReactionsModal(
                      context,
                    ),
                  )
                : null,
            anchor: Aligned(
              follower: Alignment(reverse ? 1 : -1, -1),
              target: Alignment(reverse ? -1 : 1, -1),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: showReactions
                      ? EdgeInsets.only(top: 10.h)
                      : EdgeInsets.zero,
                  child: MessageCard(
                    message: message,
                    isDm: isDm,
                    botBuilder: botBuilder,
                    isFailedState: isFailedState,
                    showSendingIndicator: showSendingIndicator,
                    showUserAvatar: showUserAvatar,
                    messageTheme: messageTheme,
                    hasQuotedMessage: hasQuotedMessage,
                    hasUrlAttachments: hasUrlAttachments,
                    hasNonUrlAttachments: hasNonUrlAttachments,
                    isOnlyEmoji: isOnlyEmoji,
                    isGiphy: isGiphy,
                    streamChat: streamChat,
                    streamChatTheme: streamChatTheme,
                    attachmentBuilders: attachmentBuilders,
                    attachmentPadding: attachmentPadding,
                    textPadding: textPadding,
                    reverse: reverse,
                    onQuotedMessageTap: onQuotedMessageTap,
                    onMentionTap: onMentionTap,
                    onLinkTap: onLinkTap,
                    textBuilder: textBuilder,
                    borderRadiusGeometry: borderRadiusGeometry,
                    borderSide: borderSide,
                    shape: shape,
                  ),
                ),
                if (showReactionPickerIndicator)
                  Positioned(
                    right: reverse ? null : 4,
                    left: reverse ? 4 : null,
                    top: -8,
                    child: CustomPaint(
                      painter: ReactionBubblePainter(
                        streamChatTheme.colorTheme.barsBg,
                        Colors.transparent,
                        Colors.transparent,
                        tailCirclesSpace: 1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isFailedState) StreamSvgIcon.error(size: 20.r),
        ],
      ),
    );
  }

  void _showMessageReactionsModal(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: streamChatTheme.colorTheme.overlay,
      builder: (context) => StreamChannel(
        channel: channel,
        child: StreamMessageReactionsModal(
          messageWidget: messageWidget.copyWith(
            key: const Key('MessageWidget'),
            message: message.copyWith(
              text: (message.text?.length ?? 0) > 200
                  ? '${message.text!.substring(0, 200)}...'
                  : message.text,
            ),
            showReactions: false,
            showUsername: false,
            showTimestamp: false,
            translateUserAvatar: false,
            showSendingIndicator: false,
            padding: EdgeInsets.zero,
            showReactionPickerIndicator:
                showReactions && (message.status == MessageSendingStatus.sent),
            showPinHighlight: false,
            showUserAvatar:
                message.user!.id == channel.client.state.currentUser!.id
                    ? DisplayWidget.gone
                    : DisplayWidget.show,
          ),
          onUserAvatarTap: onUserAvatarTap,
          messageTheme: messageTheme,
          reverse: reverse,
          message: message,
          showReactions: showReactions,
        ),
      ),
    );
  }
}
