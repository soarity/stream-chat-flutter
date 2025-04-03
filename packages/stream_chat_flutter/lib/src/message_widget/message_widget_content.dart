import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:meta/meta.dart';
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
    required this.showTailBubble,
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
    required this.onReactionsHover,
    required this.messageTheme,
    required this.streamChatTheme,
    required this.isFailedState,
    required this.hasQuotedMessage,
    required this.hasUrlAttachments,
    required this.hasNonUrlAttachments,
    required this.hasPoll,
    required this.isOnlyEmoji,
    required this.isGiphy,
    required this.attachmentBuilders,
    required this.attachmentPadding,
    required this.attachmentShape,
    required this.onAttachmentTap,
    required this.onShowMessage,
    required this.onReplyTap,
    required this.attachmentActionsModalBuilder,
    required this.textPadding,
    required this.showReactionPickerTail,
    required this.translateUserAvatar,
    required this.bottomRowPadding,
    required this.streamChat,
    required this.showSendingIndicator,
    required this.showTimeStamp,
    required this.showUsername,
    required this.showEditedLabel,
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
    this.bottomRowBuilderWithDefaultWidget,
    this.userAvatarBuilder,
  });

  ///  Whether the widget is to be used for Direct Message or Group Message
  ///
  /// Defaults to false
  final bool isDm;

  ///  Whether the widget should show bubble on left or right
  ///
  final bool showTailBubble;

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

  /// {@macro onReactionsTap}
  final VoidCallback onReactionsTap;

  /// {@macro onReactionsHover}
  final OnReactionsHover? onReactionsHover;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

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

  /// {@macro hasPoll}
  final bool hasPoll;

  /// {@macro isOnlyEmoji}
  final bool isOnlyEmoji;

  /// {@macro isGiphy}
  final bool isGiphy;

  /// {@macro attachmentBuilders}
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// {@macro attachmentPadding}
  final EdgeInsetsGeometry attachmentPadding;

  /// {@macro attachmentShape}
  final ShapeBorder? attachmentShape;

  /// {@macro onAttachmentTap}
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  /// {@macro onShowMessage}
  final ShowMessageCallback? onShowMessage;

  /// {@macro onReplyTap}
  final void Function(Message)? onReplyTap;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

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

  /// {@macro showEdited}
  final bool showEditedLabel;

  /// {@macro messageWidget}
  final StreamMessageWidget messageWidget;

  /// {@macro userAvatarBuilder}
  final Widget Function(BuildContext, User)? userAvatarBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    ? const EdgeInsets.only(top: 12)
                    : EdgeInsets.zero,
                child: Stack(
                  alignment:
                      reverse ? Alignment.bottomRight : Alignment.bottomLeft,
                  children: [
                    Padding(
                      padding: showUserAvatar == DisplayWidget.gone
                          ? EdgeInsets.zero
                          : const EdgeInsets.only(left: 40),
                      child: MessageCard(
                        message: message,
                        isDm: isDm,
                        showTailBubble: showTailBubble,
                        botBuilder: botBuilder,
                        showInChannel: showInChannel,
                        showUsername: showUsername,
                        showEditedLabel: showEditedLabel,
                        isFailedState: isFailedState,
                        showSendingIndicator: showSendingIndicator,
                        showUserAvatar: showUserAvatar,
                        showTimeStamp: showTimeStamp,
                        messageTheme: messageTheme,
                        hasQuotedMessage: hasQuotedMessage,
                        hasUrlAttachments: hasUrlAttachments,
                        hasNonUrlAttachments: hasNonUrlAttachments,
                        hasPoll: hasPoll,
                        isOnlyEmoji: isOnlyEmoji,
                        isGiphy: isGiphy,
                        attachmentBuilders: attachmentBuilders,
                        attachmentPadding: attachmentPadding,
                        attachmentShape: attachmentShape,
                        onAttachmentTap: onAttachmentTap,
                        onReplyTap: onReplyTap,
                        onShowMessage: onShowMessage,
                        attachmentActionsModalBuilder:
                            attachmentActionsModalBuilder,
                        streamChat: streamChat,
                        streamChatTheme: streamChatTheme,
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
                    if (!isDm || showUserAvatar == DisplayWidget.show)
                      UserAvatar(
                        showUserAvatar: showUserAvatar,
                        message: message,
                        isDm: isDm,
                      ),
                  ],
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
        if (isFailedState)
          const StreamSvgIcon(
            size: 20,
            icon: StreamSvgIcons.error,
          ),
      ],
    );
  }
}

/// {@template UserAvatar}
/// Widget for the UserAvatar
/// {@endtemplate}

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
    if (showUserAvatar == DisplayWidget.gone) {
      return const Offstage();
    } else if (showUserAvatar == DisplayWidget.hide) {
      return const SizedBox(width: 40);
    }

    final user = message.user!;
    return ProfilePicture(
      showBorder: true,
      picURL: user.image ?? '',
      fullName: user.name,
      radius: 20,
    );
  }
}

///
class ProfilePicture extends StatelessWidget {
  ///
  const ProfilePicture({
    super.key,
    required this.picURL,
    this.radius,
    this.backgroundColor,
    this.fullName = '',
    this.style,
    this.border,
    this.showBorder = false,
  });

  ///
  final String picURL;

  ///
  final double? radius;

  ///
  final Color? backgroundColor;

  ///
  final String fullName;

  ///
  final TextStyle? style;

  ///
  final bool showBorder;

  ///
  final BorderSide? border;

  @override
  Widget build(BuildContext context) {
    final background =
        backgroundColor ?? Theme.of(context).colorScheme.secondaryContainer;
    final diameter = (radius ?? 26) * 2;
    ImageProvider<Object>? image;
    Widget? child;

    // show profile image if available
    if (picURL.isNotEmpty) {
      image = CachedNetworkImageProvider(picURL);
    } else {
      // show Initials of name if available
      if (fullName.trim().isNotEmpty) {
        child = Center(
          child: Text(
            parseName(fullName),
            textScaler: TextScaler.noScaling,
            style: style ??
                Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: diameter / 2.2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
          ),
        );
      } else {
        // show default image
        image = const AssetImage('assets/images/avatar.png');
      }
    }

    return Container(
      width: diameter,
      height: diameter,
      decoration: ShapeDecoration(
        color: image != null ? background : Theme.of(context).primaryColor,
        image: image != null
            ? DecorationImage(
                image: image,
                fit: image is AssetImage ? BoxFit.contain : BoxFit.cover,
              )
            : null,
        shape: CircleBorder(
          side: showBorder
              ? border ??
                  BorderSide(
                    width: diameter / (2 * 24.0),
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
              : BorderSide.none,
        ),
      ),
      child: child,
    );
  }

  ///
  String parseName(String fullName) {
    try {
      final parts = fullName.trim().split(' ')
        // remove from the list where text is empty
        ..removeWhere((p) => p.trim().isEmpty);

      if (parts.length > 1) {
        return (parts[0][0] + parts[1][0]).toUpperCase();
      } else if (parts.isNotEmpty && parts.first.isNotEmpty) {
        return parts[0][0].toUpperCase();
      } else {
        return 'CP';
      }
    } catch (_) {
      return 'CP';
    }
  }
}
