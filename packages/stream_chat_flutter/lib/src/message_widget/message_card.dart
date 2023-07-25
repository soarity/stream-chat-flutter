import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/src/message_widget/bottom_row.dart';
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
    final onQuotedMessageTap = widget.onQuotedMessageTap;
    final quotedMessageBuilder = widget.quotedMessageBuilder;
    final message = widget.message;
    final showText = message.attachments.where((it) {
          return it.type == 'image' || it.type == 'giphy' || it.type == 'video';
        }).isEmpty ||
        (message.text != null && message.text!.trim().isNotEmpty);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: widget.isGiphy
          ? null
          : widget.shape ??
              RoundedRectangleBorder(
                side: widget.borderSide ??
                    BorderSide(
                      color: widget.messageTheme.messageBorderColor ??
                          Colors.transparent,
                    ),
                borderRadius: widget.borderRadiusGeometry ?? BorderRadius.zero,
              ),
      color: _getBackgroundColor,
      child: Padding(
        padding: showText ? EdgeInsets.only(bottom: 5.h) : EdgeInsets.zero,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isDm &&
                      message.user != null &&
                      widget.showUsername)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 2.h,
                        top: 8.h,
                        left: 12.w,
                      ),
                      child: Username(
                        key: const Key('usernameKey'),
                        messageTheme: widget.messageTheme,
                        message: message,
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: const Offstage(),
                    ),
                  if (widget.hasQuotedMessage)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: !widget.message.quotedMessage!.isDeleted &&
                                onQuotedMessageTap != null
                            ? () => onQuotedMessageTap(
                                widget.message.quotedMessageId)
                            : null,
                        child: quotedMessageBuilder?.call(
                              context,
                              widget.message.quotedMessage!,
                            ) ??
                            QuotedMessage(
                              isDm: widget.isDm,
                              reverse: widget.reverse,
                              message: widget.message,
                              showBorder: widget.hasUrlAttachments ||
                                  widget.hasNonUrlAttachments ||
                                  ((widget.message.text
                                                  ?.replaceAll('\n', '\n\n')
                                                  .trim() ??
                                              '')
                                          .length >
                                      20),
                              hasNonUrlAttachments: widget.hasNonUrlAttachments,
                            ),
                      ),
                    ),
                  if (widget.hasNonUrlAttachments)
                    if (showText)
                      ParseAttachments(
                        key: attachmentsKey,
                        message: widget.message,
                        attachmentBuilders: widget.attachmentBuilders,
                        attachmentPadding: widget.attachmentPadding,
                      )
                    else
                      Stack(
                        children: [
                          ParseAttachments(
                            key: attachmentsKey,
                            message: widget.message,
                            attachmentBuilders: widget.attachmentBuilders,
                            attachmentPadding: widget.attachmentPadding,
                          ),
                          Positioned(
                            right: 8.w,
                            bottom: 6.h,
                            child: BottomRow(
                              message: widget.message,
                              showInChannel: widget.showInChannel,
                              showUsername: widget.showUsername,
                              messageTheme: widget.messageTheme,
                              reverse: widget.reverse,
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
            if (showText)
              Padding(
                padding: EdgeInsets.only(
                  top: 2.h,
                  right: widget.reverse ? 4.w : 8.w,
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
      return widget.messageTheme.botBackgroundColor;
    }

    return widget.messageTheme.messageBackgroundColor;
  }
}
