import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta/meta.dart';
import 'package:stream_chat_flutter/src/message_widget/message_widget_content_components.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Signature for the builder function that will be called when the message
/// bottom row is built. Includes the [Message].
typedef BottomRowBuilder = Widget Function(BuildContext, Message);

/// Signature for the builder function that will be called when the message
/// bottom row is built. Includes the [Message] and the default [BottomRow].
typedef BottomRowBuilderWithDefaultWidget = Widget Function(
  BuildContext,
  Message,
  BottomRow,
);

/// {@template messageWidgetContent}
/// The main content of a [StreamMessageWidget].
///
/// Should not be used outside of [MessageWidget.
/// {@endtemplate}
@internal
class MessageWidgetContent extends StatelessWidget {
  /// {@macro messageWidgetContent}
  const MessageWidgetContent({
    super.key,
    required this.isDm,
    required this.showInChannel,
    required this.botBuilder,
    required this.reverse,
    required this.isPinned,
    required this.showPinHighlight,
    required this.showBottomRow,
    required this.message,
    required this.showUserAvatar,
    required this.avatarWidth,
    required this.showReactions,
    required this.onReactionsTap,
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
    required this.showReactionPickerTail,
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
    this.quotedMessageBuilder,
    @Deprecated('''
    Use [bottomRowBuilderWithDefaultWidget] instead.
    Will be removed in the next major version.
    ''') this.bottomRowBuilder,
    this.bottomRowBuilderWithDefaultWidget,
    @Deprecated('''
    Use [bottomRowBuilderWithDefaultWidget] instead.
    Will be removed in the next major version.
    ''') this.deletedBottomRowBuilder,
    this.userAvatarBuilder,
    @Deprecated('''
    Use [bottomRowBuilderWithDefaultWidget] instead.
    Will be removed in the next major version.
    ''') this.usernameBuilder,
  }) : assert(
          bottomRowBuilder == null || bottomRowBuilderWithDefaultWidget == null,
          'You can only use one of the two bottom row builders',
        );

  ///  Whether the widget is to be used for Direct Message or Group Message
  ///
  /// Defaults to false
  final bool isDm;

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

  /// Callback called when the reactions icon is tapped.
  ///
  /// Do not confuse this with the tap action on the reactions picker.
  final VoidCallback onReactionsTap;

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

  /// {@macro quotedMessageBuilder}
  final Widget Function(BuildContext, Message)? quotedMessageBuilder;

  /// {@macro showReactionPickerTail}
  final bool showReactionPickerTail;

  /// {@macro translateUserAvatar}
  final bool translateUserAvatar;

  /// The padding to use for this widget.
  final double bottomRowPadding;

  /// {@macro bottomRowBuilder}
  final BottomRowBuilder? bottomRowBuilder;

  /// {@macro bottomRowBuilderWithDefaultWidget}
  final BottomRowBuilderWithDefaultWidget? bottomRowBuilderWithDefaultWidget;

  /// {@macro showInChannelIndicator}
  final bool showInChannel;

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
          PortalTarget(
            visible: isMobileDevice && showReactions,
            portalFollower: isMobileDevice && showReactions
                ? ReactionIndicator(
                    message: message,
                    messageTheme: messageTheme,
                    ownId: streamChat.currentUser!.id,
                    reverse: reverse,
                    shouldShowReactions: shouldShowReactions,
                    onTap: onReactionsTap,
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
                    showInChannel: showInChannel,
                    showUsername: showUsername,
                    isFailedState: isFailedState,
                    showSendingIndicator: showSendingIndicator,
                    showUserAvatar: showUserAvatar,
                    showTimeStamp: showTimeStamp,
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
                if (showReactionPickerTail)
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
}

/// {@template UserAvatar}

class UserAvatar extends StatelessWidget {
  ///
  const UserAvatar({
    super.key,
    required this.showUserAvatar,
    required this.message,
    required this.isDm,
  });

  /// {@macro showUserAvatar}
  final DisplayWidget showUserAvatar;

  /// {@macro message}
  final Message message;

  /// {@macro isDm}
  final bool isDm;

  @override
  Widget build(BuildContext context) {
    final streamChatConfig = StreamChatConfiguration.of(context);
    if (showUserAvatar == DisplayWidget.gone || isDm) {
      return const Offstage();
    } else if (showUserAvatar == DisplayWidget.hide) {
      return SizedBox(width: 46.w);
    }
    return Padding(
      padding: EdgeInsets.only(right: 6.w),
      child: streamChatConfig.defaultUserImage(context, message.user!),
    );
  }
}
