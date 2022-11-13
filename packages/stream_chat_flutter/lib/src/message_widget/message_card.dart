import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/src/message_widget/bottom_row.dart';
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
    required this.botBuilder,
    required this.message,
    required this.isFailedState,
    required this.showSendingIndicator,
    required this.streamChatTheme,
    required this.streamChat,
    required this.showUserAvatar,
    required this.messageTheme,
    required this.hasQuotedMessage,
    required this.hasUrlAttachments,
    required this.hasNonUrlAttachments,
    required this.isOnlyEmoji,
    required this.isGiphy,
    required this.attachmentBuilders,
    required this.attachmentPadding,
    required this.textPadding,
    required this.reverse,
    this.shape,
    this.borderSide,
    this.borderRadiusGeometry,
    this.textBuilder,
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

  /// {@macro attachmentBuilders}
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// {@macro attachmentPadding}
  final EdgeInsetsGeometry attachmentPadding;

  /// {@macro textPadding}
  final EdgeInsets textPadding;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  /// {@macro onLinkTap}
  final void Function(String)? onLinkTap;

  /// {@macro onMentionTap}
  final void Function(User)? onMentionTap;

  /// {@macro onQuotedMessageTap}
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// {@macro reverse}
  final bool reverse;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final GlobalKey attachmentsKey = GlobalKey();
  final GlobalKey linksKey = GlobalKey();
  double? widthLimit;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final attachmentsRenderBox =
          attachmentsKey.currentContext?.findRenderObject() as RenderBox?;
      final attachmentsWidth = attachmentsRenderBox?.size.width;

      final linkRenderBox =
          linksKey.currentContext?.findRenderObject() as RenderBox?;
      final linkWidth = linkRenderBox?.size.width;

      if (mounted) {
        setState(() {
          if (attachmentsWidth != null && linkWidth != null) {
            widthLimit = max(attachmentsWidth, linkWidth);
          } else {
            widthLimit = attachmentsWidth ?? linkWidth;
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.isGiphy ? 0.0 : 0.5,
      shape: widget.isGiphy
          ? null
          : widget.shape ??
              RoundedRectangleBorder(
                side: widget.borderSide ??
                    BorderSide(
                      color:
                          widget.messageTheme.messageBorderColor ?? Colors.grey,
                    ),
                borderRadius: widget.borderRadiusGeometry ?? BorderRadius.zero,
              ),
      color: widget.isGiphy ? Colors.transparent : _getBackgroundColor,
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            if (widget.message.isDeleted && !widget.isFailedState)
              Padding(
                padding: widget.textPadding,
                child: StreamDeletedMessage(
                  borderRadiusGeometry: widget.borderRadiusGeometry,
                  borderSide: widget.borderSide,
                  shape: widget.shape,
                  messageTheme: widget.messageTheme,
                ),
              )
            else
              Column(
                children: [
                  if (widget.hasQuotedMessage)
                    QuotedMessage(
                      isDm: widget.isDm,
                      reverse: widget.reverse,
                      message: widget.message,
                      hasNonUrlAttachments: widget.hasNonUrlAttachments,
                      onQuotedMessageTap: widget.onQuotedMessageTap,
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
            Padding(
              padding: EdgeInsets.only(
                top: 2.h,
                right: widget.reverse ? 4.w : 8.w,
              ),
              child: BottomRow(
                message: widget.message,
                messageTheme: widget.messageTheme,
                hasUrlAttachments: widget.hasUrlAttachments,
                isOnlyEmoji: widget.isOnlyEmoji,
                isDeleted: widget.message.isDeleted,
                isGiphy: widget.isGiphy,
                showSendingIndicator: widget.showSendingIndicator,
                showTimeStamp: true,
                streamChatTheme: widget.streamChatTheme,
                streamChat: widget.streamChat,
                hasNonUrlAttachments: widget.hasNonUrlAttachments,
              ),
            ),
          ],
        ),
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
      return widget.messageTheme.linkBackgroundColor;
    }

    if (widget.isOnlyEmoji) {
      return Colors.transparent;
    }

    if (widget.isGiphy) {
      return Colors.transparent;
    }

    if (widget.message.user!.id == 'wer6bot') {
      return widget.messageTheme.botBackgroundColor;
    }

    return widget.messageTheme.messageBackgroundColor;
  }
}
