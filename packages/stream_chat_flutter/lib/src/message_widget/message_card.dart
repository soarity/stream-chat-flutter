import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/src/message_widget/bottom_row.dart';
import 'package:stream_chat_flutter/src/message_widget/chat_bubble.dart';
import 'package:stream_chat_flutter/src/message_widget/message_widget_content.dart';
import 'package:stream_chat_flutter/src/message_widget/username.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template messageCard}
/// The widget containing a quoted message.
///
/// Used in [MessageWidgetContent]. Should not be used elsewhere.
/// {@endtemplate}
class MessageCard extends StatefulWidget {
  /// {@macro messageCard}
  const MessageCard({
    super.key,
    this.isDm = false,
    this.showTailBubble = false,
    required this.botBuilder,
    required this.message,
    required this.isFailedState,
    required this.showSendingIndicator,
    required this.streamChatTheme,
    required this.streamChat,
    required this.showUserAvatar,
    required this.showInChannel,
    required this.showTimeStamp,
    required this.showUsername,
    required this.reverse,
    required this.messageTheme,
    required this.hasQuotedMessage,
    required this.hasUrlAttachments,
    required this.hasNonUrlAttachments,
    required this.isOnlyEmoji,
    required this.isGiphy,
    required this.attachmentBuilders,
    required this.attachmentPadding,
    required this.textPadding,
    this.shape,
    this.borderSide,
    this.borderRadiusGeometry,
    this.textBuilder,
    this.quotedMessageBuilder,
    this.onLinkTap,
    this.onMentionTap,
    this.onQuotedMessageTap,
  });

  /// {@macro isFailedState}
  final bool isFailedState;

  ///
  final bool showSendingIndicator;

  ///
  final bool isDm;

  ///  Whether the widget should show bubble on left or right
  ///
  final bool showTailBubble;

  /// {@macro streamChatThemeData}
  final StreamChatThemeData streamChatTheme;

  /// {@macro streamChat}
  final StreamChatState streamChat;

  /// Widget builder for building bot message
  final Widget Function(BuildContext, Message)? botBuilder;

  /// {@macro showUserAvatar}
  final DisplayWidget showUserAvatar;

  /// {@macro shape}
  final ShapeBorder? shape;

  /// {@macro borderSide}
  final BorderSide? borderSide;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  /// {@macro borderRadiusGeometry}
  final BorderRadiusGeometry? borderRadiusGeometry;

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

  /// {@macro attachmentBuilders}
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// {@macro attachmentPadding}
  final EdgeInsetsGeometry attachmentPadding;

  /// {@macro textPadding}
  final EdgeInsets textPadding;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  /// {@macro quotedMessageBuilder}
  final Widget Function(BuildContext, Message)? quotedMessageBuilder;

  /// {@macro onLinkTap}
  final void Function(String)? onLinkTap;

  /// {@macro onMentionTap}
  final void Function(User)? onMentionTap;

  /// {@macro onQuotedMessageTap}
  final OnQuotedMessageTap? onQuotedMessageTap;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final GlobalKey attachmentsKey = GlobalKey();
  final GlobalKey linksKey = GlobalKey();
  final GlobalKey quotedWidgetKey = GlobalKey();
  final GlobalKey textBubbleKey = GlobalKey();
  final GlobalKey usernameKey = GlobalKey();
  double widthLimit = 0;
  double quotedMessageHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final attachmentsRenderBox =
          attachmentsKey.currentContext?.findRenderObject() as RenderBox?;
      final attachmentsWidth = attachmentsRenderBox?.size.width ?? 0;

      final linkRenderBox =
          linksKey.currentContext?.findRenderObject() as RenderBox?;
      final linkWidth = linkRenderBox?.size.width ?? 0;

      final quotedRenderBox =
          quotedWidgetKey.currentContext?.findRenderObject() as RenderBox?;
      final quotedWidth = quotedRenderBox?.size.width ?? 0;
      quotedMessageHeight = quotedRenderBox?.size.height ?? 0;

      final textBubbleRenderBox =
          textBubbleKey.currentContext?.findRenderObject() as RenderBox?;
      final textBubbleWidth = textBubbleRenderBox?.size.width ?? 0;

      final usernameRenderBox =
          usernameKey.currentContext?.findRenderObject() as RenderBox?;
      final usernameWidth = usernameRenderBox?.size.width ?? 0;

      if (mounted) {
        final widthLimit1 = max(attachmentsWidth, linkWidth);
        final widthLimit2 = max(quotedWidth, textBubbleWidth);
        widthLimit = max(usernameWidth, max(widthLimit1, widthLimit2));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final onQuotedMessageTap = widget.onQuotedMessageTap;
    final message = widget.message;
    return BubbleChat(
      isMyMessage: widget.reverse,
      tail: !widget.isGiphy && widget.showTailBubble,
      color: _getBackgroundColor ?? Colors.transparent,
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          if (widget.message.isDeleted && !widget.isFailedState)
            StreamDeletedMessage(
              borderRadiusGeometry: widget.borderRadiusGeometry,
              borderSide: widget.borderSide,
              shape: widget.shape,
              messageTheme: widget.messageTheme,
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widthLimit > 0 ? widthLimit : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isDm &&
                      message.user != null &&
                      widget.showUsername)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Username(
                        key: usernameKey,
                        messageTheme: widget.messageTheme,
                        message: message,
                      ),
                    ),
                  if (widget.hasQuotedMessage)
                    InkWell(
                      onTap: !widget.message.quotedMessage!.isDeleted &&
                              onQuotedMessageTap != null
                          ? () =>
                              onQuotedMessageTap(widget.message.quotedMessageId)
                          : null,
                      child: widthLimit > 0 && quotedMessageHeight > 0
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: SizedBox(
                                width: widthLimit,
                                height: quotedMessageHeight,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12.r),
                                          bottom: Radius.circular(6.r),
                                        ),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outlineVariant
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    QuotedMessage(
                                      key: quotedWidgetKey,
                                      isDm: widget.isDm,
                                      minimumWidth: widthLimit,
                                      reverse: widget.reverse,
                                      message: widget.message,
                                      hasNonUrlAttachments:
                                          widget.hasNonUrlAttachments,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: QuotedMessage(
                                key: quotedWidgetKey,
                                isDm: widget.isDm,
                                minimumWidth: widthLimit,
                                reverse: widget.reverse,
                                message: widget.message,
                                hasNonUrlAttachments:
                                    widget.hasNonUrlAttachments,
                              ),
                            ),
                    ),
                  if (widget.hasNonUrlAttachments)
                    ParseAttachments(
                      key: attachmentsKey,
                      message: widget.message,
                      attachmentBuilders: widget.attachmentBuilders,
                      attachmentPadding: widget.attachmentPadding,
                    ),
                  if (!widget.isGiphy)
                    TextBubble(
                      key: textBubbleKey,
                      messageTheme: widget.messageTheme,
                      botBuilder: widget.botBuilder,
                      message: widget.message,
                      textPadding: widget.textPadding,
                      textBuilder: widget.textBuilder,
                      isOnlyEmoji: widget.isOnlyEmoji,
                      hasQuotedMessage: widget.hasQuotedMessage,
                      hasUrlAttachments: widget.hasUrlAttachments,
                      onLinkTap: widget.onLinkTap,
                      onMentionTap: widget.onMentionTap,
                    ),
                  if (widget.hasUrlAttachments && !widget.hasQuotedMessage)
                    _buildUrlAttachment(),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.only(
              top: 2.h,
              left: 8.w,
            ),
            child: BottomRow(
              message: widget.message,
              showInChannel: widget.showInChannel,
              showUsername: widget.showUsername,
              reverse: widget.reverse,
              messageTheme: widget.messageTheme,
              hasUrlAttachments: widget.hasUrlAttachments,
              isOnlyEmoji: widget.isOnlyEmoji,
              isDeleted: widget.message.isDeleted,
              isGiphy: widget.isGiphy,
              showSendingIndicator: widget.showSendingIndicator,
              showTimeStamp: widget.showTimeStamp,
              streamChatTheme: widget.streamChatTheme,
              streamChat: widget.streamChat,
              hasNonUrlAttachments: widget.hasNonUrlAttachments,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlAttachment() {
    final urlAttachment = widget.message.attachments
        .firstWhere((element) => element.titleLink != null);

    final host = Uri.parse(urlAttachment.titleLink!).host;
    final splitList = host.split('.');
    final hostName = splitList.length == 3 ? splitList[1] : splitList[0];
    final hostDisplayName = urlAttachment.authorName?.capitalize() ??
        getWebsiteName(hostName.toLowerCase()) ??
        hostName.capitalize();

    return StreamUrlAttachment(
      key: linksKey,
      onLinkTap: widget.onLinkTap,
      urlAttachment: urlAttachment,
      hostDisplayName: hostDisplayName,
      textPadding: widget.textPadding,
      messageTheme: widget.messageTheme,
    );
  }

  Color? get _getBackgroundColor {
    if (widget.hasQuotedMessage) {
      return widget.messageTheme.messageBackgroundColor;
    }

    if (widget.hasUrlAttachments) {
      return widget.messageTheme.urlAttachmentBackgroundColor;
    }

    if (widget.isOnlyEmoji) {
      return Colors.transparent;
    }

    if (widget.isGiphy) {
      return Colors.transparent;
    }

    if (widget.message.user!.id == 'wer6bot') {
      return widget.messageTheme.messageBackgroundColor;
    }

    return widget.messageTheme.messageBackgroundColor;
  }
}
