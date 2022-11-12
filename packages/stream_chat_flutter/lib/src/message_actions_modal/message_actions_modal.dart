import 'dart:ui';

import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:stream_chat_flutter/src/message_actions_modal/mam_widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template messageActionsModal}
/// Constructs a modal with actions for a message
/// {@endtemplate}
class MessageActionsModal extends StatefulWidget {
  /// {@macro messageActionsModal}
  const MessageActionsModal({
    super.key,
    required this.message,
    required this.messageWidget,
    required this.messageTheme,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.onReplyTap,
    this.showCopyMessage = true,
    this.showReplyMessage = true,
    this.showResendMessage = true,
    this.showFlagButton = true,
    this.showPinButton = true,
    this.editMessageInputBuilder,
    this.reverse = false,
    this.customActions = const [],
    this.onCopyTap,
  });

  /// Widget that shows the message
  final Widget messageWidget;

  /// Builder for edit message
  final EditMessageInputBuilder? editMessageInputBuilder;

  /// The action to perform when "reply" is tapped
  final OnMessageTap? onReplyTap;

  /// Message in focus for actions
  final Message message;

  /// [StreamMessageThemeData] for message
  final StreamMessageThemeData messageTheme;

  /// Flag for showing reactions
  final bool showReactions;

  /// Callback when copy is tapped
  final OnMessageTap? onCopyTap;

  /// Callback when delete is tapped
  final bool showDeleteMessage;

  /// Flag for showing copy action
  final bool showCopyMessage;

  /// Flag for showing edit action
  final bool showEditMessage;

  /// Flag for showing resend action
  final bool showResendMessage;

  /// Flag for showing reply action
  final bool showReplyMessage;

  /// Flag for showing flag action
  final bool showFlagButton;

  /// Flag for showing pin action
  final bool showPinButton;

  /// Flag for reversing message
  final bool reverse;

  /// List of custom actions
  final List<StreamMessageAction> customActions;

  @override
  _MessageActionsModalState createState() => _MessageActionsModalState();
}

class _MessageActionsModalState extends State<MessageActionsModal> {
  bool _showActions = true;

  @override
  Widget build(BuildContext context) => _showMessageOptionsModal();

  Widget _showMessageOptionsModal() {
    final mediaQueryData = MediaQuery.of(context);
    final size = mediaQueryData.size;
    final user = StreamChat.of(context).currentUser;

    final roughMaxSize = size.width * 2 / 3;
    var messageTextLength = widget.message.text!.length;
    if (widget.message.quotedMessage != null) {
      var quotedMessageLength =
          (widget.message.quotedMessage!.text?.length ?? 0) + 40;
      if (widget.message.quotedMessage!.attachments.isNotEmpty) {
        quotedMessageLength += 40;
      }
      if (quotedMessageLength > messageTextLength) {
        messageTextLength = quotedMessageLength;
      }
    }
    final roughSentenceSize = messageTextLength *
        (widget.messageTheme.messageTextStyle?.fontSize ?? 1) *
        1.2;
    final divFactor = widget.message.attachments.isNotEmpty
        ? 1
        : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / roughMaxSize));

    final streamChatThemeData = StreamChatTheme.of(context);

    final numberOfReactions =
        StreamChatConfiguration.of(context).reactionIcons.length;
    final shiftFactor =
        numberOfReactions < 5 ? (5 - numberOfReactions) * 0.1 : 0.0;
    final channel = StreamChannel.of(context).channel;

    final child = Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: widget.reverse
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.showReactions &&
                  (widget.message.status == MessageSendingStatus.sent))
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Align(
                      alignment: Alignment(
                        _calculateReactionsHorizontalAlignmentValue(
                          user,
                          divFactor,
                          shiftFactor,
                          constraints,
                        ),
                        0,
                      ),
                      child: StreamReactionPicker(
                        message: widget.message,
                      ),
                    );
                  },
                ),
              const SizedBox(height: 8),
              IgnorePointer(
                child: widget.messageWidget,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(
                  left: widget.reverse ? 0 : 40,
                ),
                child: SizedBox(
                  width: mediaQueryData.size.width * 0.75,
                  child: Material(
                    color: streamChatThemeData.colorTheme.appBg,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.showReplyMessage &&
                            widget.message.status == MessageSendingStatus.sent)
                          ReplyButton(
                            onTap: () {
                              Navigator.of(context).pop();
                              if (widget.onReplyTap != null) {
                                widget.onReplyTap?.call(widget.message);
                              }
                            },
                          ),
                        if (widget.showResendMessage)
                          ResendMessageButton(
                            message: widget.message,
                            channel: channel,
                          ),
                        if (widget.showEditMessage)
                          EditMessageButton(
                            onTap: () {
                              Navigator.of(context).pop();
                              _showEditBottomSheet(context);
                            },
                          ),
                        if (widget.showCopyMessage)
                          CopyMessageButton(
                            onTap: () {
                              widget.onCopyTap?.call(widget.message);
                              Navigator.of(context).pop();
                            },
                          ),
                        if (widget.showFlagButton)
                          FlagMessageButton(
                            onTap: _showFlagDialog,
                          ),
                        if (widget.showPinButton)
                          PinMessageButton(
                            onTap: _togglePin,
                            pinned: widget.message.pinned,
                          ),
                        if (widget.showDeleteMessage)
                          DeleteMessageButton(
                            isDeleteFailed: widget.message.status ==
                                MessageSendingStatus.failed_delete,
                            onTap: _showDeleteBottomSheet,
                          ),
                        ...widget.customActions
                            .map((action) => _buildCustomAction(
                                  context,
                                  action,
                                )),
                      ].insertBetween(
                        Container(
                          height: 1,
                          color: streamChatThemeData.colorTheme.borders,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).maybePop(),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: ColoredBox(
                color: streamChatThemeData.colorTheme.overlay,
              ),
            ),
          ),
          if (_showActions)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              builder: (context, val, child) => Transform.scale(
                scale: val,
                child: child,
              ),
              child: child,
            ),
        ],
      ),
    );
  }

  double _calculateReactionsHorizontalAlignmentValue(
    User? user,
    num divFactor,
    double shiftFactor,
    BoxConstraints constraints,
  ) {
    var result = 0.0;
    var cont = true;
    if (user?.id == widget.message.user?.id) {
      if (divFactor >= 1.0) {
        // This calculation is hacky and does not cover all bases!!!
        // A better option is needed!

        // Landscape calculations
        if (constraints.maxWidth == 1350) {
          // 12.7 iPad Pro
          result = shiftFactor + 0.5;
          cont = false;
        } else if (constraints.maxWidth == 1178) {
          // 11 inch iPad Pro
          result = shiftFactor + 0.42;
          cont = false;
        } else if (constraints.maxWidth == 1164) {
          // iPad Air 4
          result = shiftFactor + 0.4;
          cont = false;
        } else if (constraints.maxWidth == 1117) {
          // iPad Mini 6
          result = shiftFactor + 0.37;
          cont = false;
        } else if (constraints.maxWidth == 1064) {
          // iPad 9th gen
          result = shiftFactor + 0.33;
          cont = false;
        } else if (constraints.maxWidth == 1008) {
          // 9.7 inch iPad Pro
          result = shiftFactor + 0.3;
          cont = false;
        } else if (constraints.maxWidth >= 200 && constraints.maxWidth <= 400) {
          // Phone (?)
          result = shiftFactor - 0.2;
          cont = false;
        }

        if (cont) {
          // Portrait calculations
          if (constraints.maxWidth == 1008) {
            // 12.7 iPad Pro
            result = shiftFactor + 0.3;
          } else if (constraints.maxWidth == 818) {
            // 11 inch iPad Pro
            result = shiftFactor + 0.07;
          } else if (constraints.maxWidth == 804) {
            // iPad Air 4
            result = shiftFactor + 0.04;
          } else if (constraints.maxWidth == 794) {
            // iPad 9th gen
            result = shiftFactor + 0.02;
          } else if (constraints.maxWidth >= 752) {
            // 9.7 inch iPad Pro
            result = shiftFactor - 0.05;
          } else if (constraints.maxWidth == 728) {
            // iPad Mini 6
            result = shiftFactor - 0.1;
          }
        }
      } else {
        result = 1.2 - divFactor;
      }
    } else {
      if (divFactor >= 1.0) {
        result = shiftFactor + 0.2;
      } else {
        result = -(1.2 - divFactor);
      }
    }

    // Ensure reactions don't get pushed past the edge of the screen.
    //
    // Hacky!!! Needs improvement!!!
    if (result > 1) {
      return 1;
    } else {
      return result;
    }
  }

  InkWell _buildCustomAction(
    BuildContext context,
    StreamMessageAction messageAction,
  ) {
    return InkWell(
      onTap: () => messageAction.onTap?.call(widget.message),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
        child: Row(
          children: [
            messageAction.leading ?? const Offstage(),
            SizedBox(width: 16.w),
            messageAction.title ?? const Offstage(),
          ],
        ),
      ),
    );
  }

  Future<void> _showFlagDialog() async {
    final client = StreamChat.of(context).client;

    final streamChatThemeData = StreamChatTheme.of(context);
    final answer = await showConfirmationBottomSheet(
      context,
      title: context.translations.flagMessageLabel,
      icon: StreamSvgIcon.flag(
        color: streamChatThemeData.colorTheme.accentError,
        size: 24.r,
      ),
      question: context.translations.flagMessageQuestion,
      okText: context.translations.flagLabel,
      cancelText: context.translations.cancelLabel,
    );

    final theme = streamChatThemeData;
    if (answer == true) {
      try {
        await client.flagMessage(widget.message.id);
        await showInfoBottomSheet(
          context,
          icon: StreamSvgIcon.flag(
            color: theme.colorTheme.accentError,
            size: 24.r,
          ),
          details: context.translations.flagMessageSuccessfulText,
          title: context.translations.flagMessageSuccessfulLabel,
          okText: context.translations.okLabel,
        );
      } catch (err) {
        if (err is StreamChatNetworkError &&
            err.errorCode == ChatErrorCode.inputError) {
          await showInfoBottomSheet(
            context,
            icon: StreamSvgIcon.flag(
              color: theme.colorTheme.accentError,
              size: 24.r,
            ),
            details: context.translations.flagMessageSuccessfulText,
            title: context.translations.flagMessageSuccessfulLabel,
            okText: context.translations.okLabel,
          );
        } else {
          _showErrorAlertBottomSheet();
        }
      }
    }
  }

  Future<void> _togglePin() async {
    final channel = StreamChannel.of(context).channel;

    Navigator.of(context).pop();
    try {
      if (!widget.message.pinned) {
        await channel.pinMessage(widget.message);
      } else {
        await channel.unpinMessage(widget.message);
      }
    } catch (e) {
      _showErrorAlertBottomSheet();
    }
  }

  /// Shows a "delete message" bottom sheet on mobile platforms.
  Future<void> _showDeleteBottomSheet() async {
    setState(() => _showActions = false);
    final answer = await showConfirmationBottomSheet(
      context,
      title: context.translations.deleteMessageLabel,
      icon: StreamSvgIcon.flag(
        color: StreamChatTheme.of(context).colorTheme.accentError,
        size: 24.r,
      ),
      question: context.translations.deleteMessageQuestion,
      okText: context.translations.deleteLabel,
      cancelText: context.translations.cancelLabel,
    );

    if (answer == true) {
      try {
        Navigator.of(context).pop();
        await StreamChannel.of(context).channel.deleteMessage(widget.message);
      } catch (err) {
        _showErrorAlertBottomSheet();
      }
    } else {
      setState(() => _showActions = true);
    }
  }

  void _showErrorAlertBottomSheet() {
    showInfoBottomSheet(
      context,
      icon: StreamSvgIcon.error(
        color: StreamChatTheme.of(context).colorTheme.accentError,
        size: 24.r,
      ),
      details: context.translations.operationCouldNotBeCompletedText,
      title: context.translations.somethingWentWrongError,
      okText: context.translations.okLabel,
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showModalBottomSheet(
      context: context,
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      backgroundColor: StreamMessageInputTheme.of(context).inputBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => EditMessageSheet(
        message: widget.message,
        channel: channel,
      ),
    );
  }
}
