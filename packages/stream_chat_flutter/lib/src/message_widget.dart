import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/src/attachment/url_attachment.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/image_group.dart';
import 'package:stream_chat_flutter/src/message_actions_modal.dart';
import 'package:stream_chat_flutter/src/message_reactions_modal.dart';
import 'package:stream_chat_flutter/src/quoted_message_widget.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget builder for building attachments
typedef AttachmentBuilder = Widget Function(
  BuildContext,
  Message,
  List<Attachment>,
);

/// Callback for when quoted message is tapped
typedef OnQuotedMessageTap = void Function(String?);

/// The display behaviour of a widget
enum DisplayWidget {
  /// Hides the widget replacing its space with a spacer
  hide,

  /// Hides the widget not replacing its space
  gone,

  /// Shows the widget normally
  show,
}

/// {@macro message_widget}
@Deprecated("Use 'StreamMessageWidget' instead")
typedef MessageWidget = StreamMessageWidget;

/// {@template message_widget}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_widget.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_widget_paint.png)
///
/// It shows a message with reactions, replies and user avatar.
///
/// Usually you don't use this widget as it's the default message widget used by
/// [StreamMessageListView].
///
/// The widget components render the ui based on the first ancestor of type
/// [StreamChatTheme].
/// Modify it to change the widget appearance.
/// {@endtemplate}
class StreamMessageWidget extends StatefulWidget {
  /// Creates a new instance of the message widget.
  StreamMessageWidget({
    Key? key,
    required this.message,
    required this.messageTheme,
    this.botBuilder,
    this.reverse = false,
    this.translateUserAvatar = true,
    this.shape,
    this.attachmentShape,
    this.borderSide,
    this.attachmentBorderSide,
    this.borderRadiusGeometry,
    this.attachmentBorderRadiusGeometry,
    this.onMentionTap,
    this.onMessageTap,
    this.showReactionPickerIndicator = false,
    this.showUserAvatar = DisplayWidget.show,
    this.showSendingIndicator = true,
    this.showInChannelIndicator = false,
    this.onReplyTap,
    this.showUsername = true,
    this.showTimestamp = true,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.showReplyMessage = true,
    this.showResendMessage = true,
    this.showCopyMessage = true,
    this.showFlagButton = true,
    this.showPinButton = true,
    this.showPinHighlight = true,
    this.hideUsername = false,
    this.onUserAvatarTap,
    this.onLinkTap,
    this.onMessageActions,
    this.onShowMessage,
    this.userAvatarBuilder,
    this.editMessageInputBuilder,
    this.textBuilder,
    this.bottomRowBuilder,
    this.deletedBottomRowBuilder,
    this.onReturnAction,
    this.customAttachmentBuilders,
    this.padding,
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    this.attachmentPadding = EdgeInsets.zero,
    this.onQuotedMessageTap,
    this.customActions = const [],
    this.onAttachmentTap,
    this.usernameBuilder,
  })  : attachmentBuilders = {
          'image': (context, message, attachments) {
            final border = RoundedRectangleBorder(
              borderRadius: attachmentBorderRadiusGeometry ?? BorderRadius.zero,
            );

            final mediaQueryData = MediaQuery.of(context);
            if (attachments.length > 1) {
              return Padding(
                padding: attachmentPadding,
                child: wrapAttachmentWidget(
                  context,
                  Material(
                    color: messageTheme.messageBackgroundColor,
                    child: StreamImageGroup(
                      size: Size(
                        mediaQueryData.size.width * 0.85,
                        mediaQueryData.size.height * 0.3,
                      ),
                      images: attachments,
                      message: message,
                      messageTheme: messageTheme,
                      onShowMessage: onShowMessage,
                      onReturnAction: onReturnAction,
                      onAttachmentTap: onAttachmentTap,
                    ),
                  ),
                  border,
                  reverse,
                ),
              );
            }

            return wrapAttachmentWidget(
              context,
              StreamImageAttachment(
                attachment: attachments[0],
                message: message,
                messageTheme: messageTheme,
                size: Size(
                  mediaQueryData.size.width * 0.85,
                  mediaQueryData.size.height * 0.3,
                ),
                onShowMessage: onShowMessage,
                onReturnAction: onReturnAction,
                onAttachmentTap: onAttachmentTap != null
                    ? () {
                        onAttachmentTap.call(message, attachments[0]);
                      }
                    : null,
              ),
              border,
              reverse,
            );
          },
          'video': (context, message, attachments) {
            final border = RoundedRectangleBorder(
              borderRadius: attachmentBorderRadiusGeometry ?? BorderRadius.zero,
            );

            return wrapAttachmentWidget(
              context,
              Column(
                children: attachments.map((attachment) {
                  final mediaQueryData = MediaQuery.of(context);
                  return StreamVideoAttachment(
                    attachment: attachment,
                    messageTheme: messageTheme,
                    size: Size(
                      mediaQueryData.size.width * 0.85,
                      mediaQueryData.size.height * 0.3,
                    ),
                    message: message,
                    onShowMessage: onShowMessage,
                    onReturnAction: onReturnAction,
                    onAttachmentTap: onAttachmentTap != null
                        ? () {
                            onAttachmentTap(message, attachment);
                          }
                        : null,
                  );
                }).toList(),
              ),
              border,
              reverse,
            );
          },
          'giphy': (context, message, attachments) {
            final border = RoundedRectangleBorder(
              borderRadius: attachmentBorderRadiusGeometry ?? BorderRadius.zero,
            );

            return wrapAttachmentWidget(
              context,
              Column(
                children: attachments.map((attachment) {
                  final mediaQueryData = MediaQuery.of(context);
                  return StreamGiphyAttachment(
                    attachment: attachment,
                    message: message,
                    size: Size(
                      mediaQueryData.size.width * 0.85,
                      mediaQueryData.size.height * 0.3,
                    ),
                    onShowMessage: onShowMessage,
                    onReturnAction: onReturnAction,
                    onAttachmentTap: onAttachmentTap != null
                        ? () {
                            onAttachmentTap(message, attachment);
                          }
                        : null,
                  );
                }).toList(),
              ),
              border,
              reverse,
            );
          },
          'file': (context, message, attachments) {
            final border = RoundedRectangleBorder(
              side: attachmentBorderSide ??
                  BorderSide(
                    color: StreamChatTheme.of(context).colorTheme.borders,
                  ),
              borderRadius: attachmentBorderRadiusGeometry ?? BorderRadius.zero,
            );

            return Column(
              children: attachments
                  .map<Widget>((attachment) {
                    final mediaQueryData = MediaQuery.of(context);
                    return wrapAttachmentWidget(
                      context,
                      StreamFileAttachment(
                        message: message,
                        attachment: attachment,
                        size: Size(
                          mediaQueryData.size.width * 0.85,
                          mediaQueryData.size.height * 0.3,
                        ),
                        onAttachmentTap: onAttachmentTap != null
                            ? () {
                                onAttachmentTap(message, attachment);
                              }
                            : null,
                      ),
                      border,
                      reverse,
                    );
                  })
                  .insertBetween(SizedBox(
                    height: attachmentPadding.vertical / 2,
                  ))
                  .toList(),
            );
          },
        }..addAll(customAttachmentBuilders ?? {}),
        super(key: key);

  /// Function called on mention tap
  final void Function(User)? onMentionTap;

  /// The function called when tapping on replies
  final void Function(Message)? onReplyTap;

  /// Widget builder for edit message layout
  final Widget Function(BuildContext, Message)? editMessageInputBuilder;

  /// Widget builder for building text
  final Widget Function(BuildContext, Message)? textBuilder;

  /// Widget builder for building username
  final Widget Function(BuildContext, Message)? usernameBuilder;

  /// Widget builder for building bot message
  final Widget Function(BuildContext, Message)? botBuilder;

  /// Function called on long press
  final void Function(BuildContext, Message)? onMessageActions;

  /// Widget builder for building a bottom row below the message
  final Widget Function(BuildContext, Message)? bottomRowBuilder;

  /// Widget builder for building a bottom row below a deleted message
  final Widget Function(BuildContext, Message)? deletedBottomRowBuilder;

  /// Widget builder for building user avatar
  final Widget Function(BuildContext, User)? userAvatarBuilder;

  /// The message
  final Message message;

  /// The message theme
  final StreamMessageThemeData messageTheme;

  /// If true the widget will be mirrored
  final bool reverse;

  /// The shape of the message text
  final ShapeBorder? shape;

  /// The shape of an attachment
  final ShapeBorder? attachmentShape;

  /// The borderside of the message text
  final BorderSide? borderSide;

  /// The borderside of an attachment
  final BorderSide? attachmentBorderSide;

  /// The border radius of the message text
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// The border radius of an attachment
  final BorderRadiusGeometry? attachmentBorderRadiusGeometry;

  /// The padding of the widget
  final EdgeInsetsGeometry? padding;

  /// The internal padding of the message text
  final EdgeInsets textPadding;

  /// The internal padding of an attachment
  final EdgeInsetsGeometry attachmentPadding;

  /// It controls the display behaviour of the user avatar
  final DisplayWidget showUserAvatar;

  /// It controls the display behaviour of the sending indicator
  final bool showSendingIndicator;

  /// If true the widget will show the reactions
  final bool showReactions;

  /// If true the widget will show the show in channel indicator
  final bool showInChannelIndicator;

  /// The function called when tapping on UserAvatar
  final void Function(User)? onUserAvatarTap;

  /// The function called when tapping on a link
  final void Function(String)? onLinkTap;

  /// Used in [StreamMessageReactionsModal] and [StreamMessageActionsModal]
  final bool showReactionPickerIndicator;

  /// Callback when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Handle return actions like reply message
  final ValueChanged<ReturnActionType>? onReturnAction;

  /// If true show the users username next to the timestamp of the message
  final bool showUsername;

  /// Show message timestamp
  final bool showTimestamp;

  /// Show reply action
  final bool showReplyMessage;

  /// Show edit action
  final bool showEditMessage;

  /// Show copy action
  final bool showCopyMessage;

  /// Show delete action
  final bool showDeleteMessage;

  /// Show resend action
  final bool showResendMessage;

  /// Show flag action
  final bool showFlagButton;

  /// Show flag action
  final bool showPinButton;

  /// Display Pin Highlight
  final bool showPinHighlight;

  /// checks if the username should be hidden
  final bool hideUsername;

  /// Builder for respective attachment types
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// Builder for respective attachment types (user facing builder)
  final Map<String, AttachmentBuilder>? customAttachmentBuilders;

  /// Center user avatar with bottom of the message
  final bool translateUserAvatar;

  /// Function called when quotedMessage is tapped
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// Function called when message is tapped
  final void Function(Message)? onMessageTap;

  /// List of custom actions shown on message long tap
  final List<StreamMessageAction> customActions;

  /// Customize onTap on attachment
  final void Function(Message message, Attachment attachment)? onAttachmentTap;

  /// Creates a copy of [StreamMessageWidget] with
  /// specified attributes overridden.
  StreamMessageWidget copyWith({
    Key? key,
    void Function(User)? onMentionTap,
    void Function(Message)? onReplyTap,
    Widget Function(BuildContext, Message)? editMessageInputBuilder,
    Widget Function(BuildContext, Message)? textBuilder,
    Widget Function(BuildContext, Message)? usernameBuilder,
    Widget Function(BuildContext, Message)? botBuilder,
    Widget Function(BuildContext, Message)? bottomRowBuilder,
    Widget Function(BuildContext, Message)? deletedBottomRowBuilder,
    void Function(BuildContext, Message)? onMessageActions,
    Message? message,
    StreamMessageThemeData? messageTheme,
    bool? reverse,
    ShapeBorder? shape,
    ShapeBorder? attachmentShape,
    BorderSide? borderSide,
    BorderSide? attachmentBorderSide,
    BorderRadiusGeometry? borderRadiusGeometry,
    BorderRadiusGeometry? attachmentBorderRadiusGeometry,
    EdgeInsetsGeometry? padding,
    EdgeInsets? textPadding,
    EdgeInsetsGeometry? attachmentPadding,
    DisplayWidget? showUserAvatar,
    bool? showSendingIndicator,
    bool? showReactions,
    bool? allRead,
    bool? showInChannelIndicator,
    void Function(User)? onUserAvatarTap,
    void Function(String)? onLinkTap,
    bool? showReactionPickerIndicator,
    List<Read>? readList,
    ShowMessageCallback? onShowMessage,
    ValueChanged<ReturnActionType>? onReturnAction,
    bool? showUsername,
    bool? showTimestamp,
    bool? showReplyMessage,
    bool? showEditMessage,
    bool? showCopyMessage,
    bool? showDeleteMessage,
    bool? showResendMessage,
    bool? showFlagButton,
    bool? showPinButton,
    bool? showPinHighlight,
    Map<String, AttachmentBuilder>? customAttachmentBuilders,
    bool? translateUserAvatar,
    OnQuotedMessageTap? onQuotedMessageTap,
    void Function(Message)? onMessageTap,
    List<StreamMessageAction>? customActions,
    void Function(Message message, Attachment attachment)? onAttachmentTap,
    Widget Function(BuildContext, User)? userAvatarBuilder,
  }) =>
      StreamMessageWidget(
        key: key ?? this.key,
        onMentionTap: onMentionTap ?? this.onMentionTap,
        onReplyTap: onReplyTap ?? this.onReplyTap,
        editMessageInputBuilder:
            editMessageInputBuilder ?? this.editMessageInputBuilder,
        textBuilder: textBuilder ?? this.textBuilder,
        usernameBuilder: usernameBuilder ?? this.usernameBuilder,
        botBuilder: botBuilder ?? this.botBuilder,
        bottomRowBuilder: bottomRowBuilder ?? this.bottomRowBuilder,
        deletedBottomRowBuilder:
            deletedBottomRowBuilder ?? this.deletedBottomRowBuilder,
        onMessageActions: onMessageActions ?? this.onMessageActions,
        message: message ?? this.message,
        messageTheme: messageTheme ?? this.messageTheme,
        reverse: reverse ?? this.reverse,
        shape: shape ?? this.shape,
        attachmentShape: attachmentShape ?? this.attachmentShape,
        borderSide: borderSide ?? this.borderSide,
        attachmentBorderSide: attachmentBorderSide ?? this.attachmentBorderSide,
        borderRadiusGeometry: borderRadiusGeometry ?? this.borderRadiusGeometry,
        attachmentBorderRadiusGeometry: attachmentBorderRadiusGeometry ??
            this.attachmentBorderRadiusGeometry,
        padding: padding ?? this.padding,
        textPadding: textPadding ?? this.textPadding,
        attachmentPadding: attachmentPadding ?? this.attachmentPadding,
        showUserAvatar: showUserAvatar ?? this.showUserAvatar,
        showSendingIndicator: showSendingIndicator ?? this.showSendingIndicator,
        showReactions: showReactions ?? this.showReactions,
        showInChannelIndicator:
            showInChannelIndicator ?? this.showInChannelIndicator,
        onUserAvatarTap: onUserAvatarTap ?? this.onUserAvatarTap,
        onLinkTap: onLinkTap ?? this.onLinkTap,
        showReactionPickerIndicator:
            showReactionPickerIndicator ?? this.showReactionPickerIndicator,
        onShowMessage: onShowMessage ?? this.onShowMessage,
        onReturnAction: onReturnAction ?? this.onReturnAction,
        showUsername: showUsername ?? this.showUsername,
        showTimestamp: showTimestamp ?? this.showTimestamp,
        showReplyMessage: showReplyMessage ?? this.showReplyMessage,
        showEditMessage: showEditMessage ?? this.showEditMessage,
        showCopyMessage: showCopyMessage ?? this.showCopyMessage,
        showDeleteMessage: showDeleteMessage ?? this.showDeleteMessage,
        showResendMessage: showResendMessage ?? this.showResendMessage,
        showFlagButton: showFlagButton ?? this.showFlagButton,
        showPinButton: showPinButton ?? this.showPinButton,
        showPinHighlight: showPinHighlight ?? this.showPinHighlight,
        customAttachmentBuilders:
            customAttachmentBuilders ?? this.customAttachmentBuilders,
        translateUserAvatar: translateUserAvatar ?? this.translateUserAvatar,
        onQuotedMessageTap: onQuotedMessageTap ?? this.onQuotedMessageTap,
        onMessageTap: onMessageTap ?? this.onMessageTap,
        customActions: customActions ?? this.customActions,
        onAttachmentTap: onAttachmentTap ?? this.onAttachmentTap,
        userAvatarBuilder: userAvatarBuilder ?? this.userAvatarBuilder,
      );

  @override
  _StreamMessageWidgetState createState() => _StreamMessageWidgetState();
}

class _StreamMessageWidgetState extends State<StreamMessageWidget>
    with AutomaticKeepAliveClientMixin<StreamMessageWidget> {
  final usernameColor = const Color(0XFF0001f6);

  bool get showSendingIndicator => widget.showSendingIndicator;

  bool get isDeleted => widget.message.isDeleted;

  bool get showUsername => widget.showUsername;

  bool get showTimeStamp => widget.showTimestamp;

  bool get showInChannel => widget.showInChannelIndicator;

  bool get hasQuotedMessage => widget.message.quotedMessage != null;

  bool get isSendFailed => widget.message.status == MessageSendingStatus.failed;

  bool get isUpdateFailed =>
      widget.message.status == MessageSendingStatus.failed_update;

  bool get isDeleteFailed =>
      widget.message.status == MessageSendingStatus.failed_delete;

  bool get isFailedState => isSendFailed || isUpdateFailed || isDeleteFailed;

  bool get isGiphy =>
      widget.message.attachments.any((element) => element.type == 'giphy');

  bool get isOnlyEmoji => widget.message.text?.isOnlyEmoji == true;

  bool get hasNonUrlAttachments => widget.message.attachments
      .where((it) => it.ogScrapeUrl == null || it.type == 'giphy')
      .isNotEmpty;

  bool get hasUrlAttachments => widget.message.attachments
      .any((it) => it.ogScrapeUrl != null && it.type != 'giphy');

  @override
  bool get wantKeepAlive => widget.message.attachments.isNotEmpty;

  late StreamChatThemeData _streamChatTheme;
  late StreamChatState _streamChat;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final showReactions = _shouldShowReactions;

    return Material(
      type: MaterialType.transparency,
      child: Portal(
        child: GestureDetector(
          onTap: () {
            widget.onMessageTap!(widget.message);
          },
          onLongPress: widget.message.isDeleted && !isFailedState
              ? null
              : () => onLongPress(context),
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: FractionallySizedBox(
              alignment:
                  widget.reverse ? Alignment.centerRight : Alignment.centerLeft,
              widthFactor: 0.85,
              child: Column(
                crossAxisAlignment: widget.reverse
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.reverse &&
                      widget.showUserAvatar == DisplayWidget.show &&
                      widget.message.user != null &&
                      !widget.hideUsername)
                    _buildUsername(const Key('usernameKey')),
                  Column(
                    children: [
                      PortalTarget(
                        visible: showReactions,
                        portalFollower: showReactions
                            ? Container(
                                transform: Matrix4.translationValues(
                                  widget.reverse ? 12 : -12,
                                  0,
                                  0,
                                ),
                                constraints: const BoxConstraints(
                                  maxWidth: 22 * 6.0,
                                ),
                                child: _buildReactionIndicator(
                                  context,
                                ),
                              )
                            : null,
                        anchor: Aligned(
                          follower: Alignment(widget.reverse ? 1 : -1, -1),
                          target: Alignment(widget.reverse ? -1 : 1, -1),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: widget.showReactions &&
                                      widget.message.reactionCounts != null &&
                                      widget.message.reactionCounts!.isNotEmpty
                                  ? EdgeInsets.only(top: 10.h)
                                  : EdgeInsets.zero,
                              child: Card(
                                clipBehavior: Clip.hardEdge,
                                elevation: 0.5,
                                margin: const EdgeInsets.all(0),
                                shape: widget.shape ??
                                    RoundedRectangleBorder(
                                      side: widget.borderSide ??
                                          BorderSide(
                                            color: widget.messageTheme
                                                    .messageBorderColor ??
                                                Colors.grey,
                                          ),
                                      borderRadius:
                                          widget.borderRadiusGeometry ??
                                              BorderRadius.zero,
                                    ),
                                color: _getBackgroundColor(),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 5.h),
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    children: [
                                      if (widget.message.isDeleted &&
                                          !isFailedState)
                                        Padding(
                                          padding: widget.textPadding,
                                          child: StreamDeletedMessage(
                                            messageTheme: widget.messageTheme,
                                          ),
                                        )
                                      else
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            if (hasQuotedMessage)
                                              _buildQuotedMessage(),
                                            if (hasNonUrlAttachments)
                                              _parseAttachments(),
                                            if (!isGiphy) _buildTextBubble(),
                                          ],
                                        ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 2.h,
                                          right: widget.reverse ? 4.w : 8.w,
                                        ),
                                        child: _bottomRow,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (widget.showReactionPickerIndicator)
                              Positioned(
                                right: widget.reverse ? null : 4,
                                left: widget.reverse ? 4 : null,
                                top: -8,
                                child: CustomPaint(
                                  painter: ReactionBubblePainter(
                                    _streamChatTheme.colorTheme.barsBg,
                                    Colors.transparent,
                                    Colors.transparent,
                                    tailCirclesSpace: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (isFailedState) StreamSvgIcon.error(size: 20.r),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _streamChatTheme = StreamChatTheme.of(context);
    _streamChat = StreamChat.of(context);
    super.didChangeDependencies();
  }

  Widget _buildQuotedMessage() {
    final isMyMessage = widget.message.user?.id == _streamChat.currentUser?.id;
    final onTap = widget.message.quotedMessage?.isDeleted != true &&
            widget.onQuotedMessageTap != null
        ? () => widget.onQuotedMessageTap!(widget.message.quotedMessageId)
        : null;
    final chatThemeData = _streamChatTheme;
    return StreamQuotedMessageWidget(
      onTap: onTap,
      message: widget.message.quotedMessage!,
      messageTheme: isMyMessage
          ? chatThemeData.otherMessageTheme
          : chatThemeData.ownMessageTheme,
      reverse: widget.reverse,
      padding: EdgeInsets.only(
        right: 3.w,
        left: 3.w,
        top: 3.h,
        bottom: hasNonUrlAttachments ? 3.h : 0,
      ),
    );
  }

  Widget get _bottomRow {
    if (isDeleted) {
      return widget.deletedBottomRowBuilder?.call(context, widget.message) ??
          const Offstage();
    }

    final children = <Widget>[];

    const usernameKey = Key('username');

    children.addAll([
      Text(
        Jiffy(widget.message.createdAt.toLocal()).jm,
        style: widget.messageTheme.createdAtStyle,
      ),
      if (widget.reverse) _buildSendingIndicator(),
    ]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...children.map(
          (child) {
            if (child.key == usernameKey) {
              return Flexible(child: child);
            }
            return child;
          },
        ),
      ].insertBetween(const SizedBox(width: 2)),
    );
  }

  Widget _buildUsername(Key usernameKey) {
    final color = widget.message.user?.extraData['color'];
    if (widget.usernameBuilder != null) {
      return widget.usernameBuilder!(context, widget.message);
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h, left: 8.w),
      child: Text(
        widget.message.user?.name ?? '',
        maxLines: 1,
        key: usernameKey,
        style: widget.messageTheme.messageAuthorStyle!.copyWith(
          color: color == null ? usernameColor : Color(int.parse('0x$color')),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildUrlAttachment() {
    final urlAttachment = widget.message.attachments
        .firstWhere((element) => element.ogScrapeUrl != null);

    final host = Uri.parse(urlAttachment.ogScrapeUrl!).withScheme.host;
    final splitList = host.split('.');
    final hostName = splitList.length == 3 ? splitList[1] : splitList[0];
    final hostDisplayName = urlAttachment.authorName?.capitalize() ??
        getWebsiteName(hostName.toLowerCase()) ??
        hostName.capitalize();

    return StreamUrlAttachment(
      urlAttachment: urlAttachment,
      hostDisplayName: hostDisplayName,
      textPadding: widget.textPadding,
      messageTheme: widget.messageTheme,
      onLinkTap: widget.onLinkTap,
    );
  }

  Widget _buildReactionIndicator(
    BuildContext context,
  ) {
    final ownId = _streamChat.currentUser!.id;
    final reactionsMap = <String, Reaction>{};
    widget.message.latestReactions?.forEach((element) {
      if (!reactionsMap.containsKey(element.type) ||
          element.user!.id == ownId) {
        reactionsMap[element.type] = element;
      }
    });
    final reactionsList = reactionsMap.values.toList()
      ..sort((a, b) => a.user!.id == ownId ? 1 : -1);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _shouldShowReactions
          ? GestureDetector(
              onTap: () => _showMessageReactionsModalBottomSheet(context),
              child: StreamReactionBubble(
                key: ValueKey('${widget.message.id}.reactions'),
                reverse: widget.reverse,
                flipTail: widget.reverse,
                backgroundColor: widget.messageTheme.reactionsBackgroundColor ??
                    Colors.transparent,
                borderColor: widget.messageTheme.reactionsBorderColor ??
                    Colors.transparent,
                maskColor: widget.messageTheme.reactionsMaskColor ??
                    Colors.transparent,
                reactions: reactionsList,
              ),
            )
          : const SizedBox(),
    );
  }

  bool get _shouldShowReactions =>
      widget.showReactions &&
      (widget.message.reactionCounts?.isNotEmpty == true) &&
      !widget.message.isDeleted;

  void _showMessageActionModalBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: _streamChatTheme.colorTheme.overlay,
      builder: (context) => StreamChannel(
        channel: channel,
        child: StreamMessageActionsModal(
          messageWidget: widget.copyWith(
            key: const Key('MessageWidget'),
            message: widget.message.copyWith(
              text: (widget.message.text?.length ?? 0) > 200
                  ? '${widget.message.text!.substring(0, 200)}...'
                  : widget.message.text,
            ),
            showReactions: false,
            showUsername: false,
            showTimestamp: false,
            translateUserAvatar: false,
            showSendingIndicator: false,
            padding: const EdgeInsets.all(0),
            showReactionPickerIndicator: widget.showReactions &&
                (widget.message.status == MessageSendingStatus.sent) &&
                channel.ownCapabilities.contains(PermissionType.sendReaction),
            showPinHighlight: false,
            showUserAvatar:
                widget.message.user!.id == channel.client.state.currentUser!.id
                    ? DisplayWidget.gone
                    : DisplayWidget.show,
          ),
          onCopyTap: (message) =>
              Clipboard.setData(ClipboardData(text: message.text)),
          messageTheme: widget.messageTheme,
          reverse: widget.reverse,
          message: widget.message,
          editMessageInputBuilder: widget.editMessageInputBuilder,
          onReplyTap: widget.onReplyTap,
          showThreadReplyMessage: false,
          showResendMessage:
              widget.showResendMessage && (isSendFailed || isUpdateFailed),
          showCopyMessage: widget.showCopyMessage &&
              !isFailedState &&
              widget.message.text?.trim().isNotEmpty == true,
          showReplyMessage: widget.showReplyMessage &&
              !isFailedState &&
              widget.onReplyTap != null,
          showFlagButton: widget.showFlagButton,
          customActions: widget.customActions,
        ),
      ),
    );
  }

  void _showMessageReactionsModalBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: _streamChatTheme.colorTheme.overlay,
      builder: (context) => StreamChannel(
        channel: channel,
        child: StreamMessageReactionsModal(
          messageWidget: widget.copyWith(
            key: const Key('MessageWidget'),
            message: widget.message.copyWith(
              text: (widget.message.text?.length ?? 0) > 200
                  ? '${widget.message.text!.substring(0, 200)}...'
                  : widget.message.text,
            ),
            showReactions: false,
            showUsername: false,
            showTimestamp: false,
            translateUserAvatar: false,
            showSendingIndicator: false,
            padding: const EdgeInsets.all(0),
            showReactionPickerIndicator: widget.showReactions &&
                (widget.message.status == MessageSendingStatus.sent) &&
                channel.ownCapabilities.contains(PermissionType.sendReaction),
            showPinHighlight: false,
            showUserAvatar:
                widget.message.user!.id == channel.client.state.currentUser!.id
                    ? DisplayWidget.gone
                    : DisplayWidget.show,
          ),
          onUserAvatarTap: widget.onUserAvatarTap,
          messageTheme: widget.messageTheme,
          reverse: widget.reverse,
          message: widget.message,
          showReactions: widget.showReactions &&
              channel.ownCapabilities.contains(PermissionType.sendReaction),
        ),
      ),
    );
  }

  Widget _parseAttachments() {
    final attachmentGroups = <String, List<Attachment>>{};

    widget.message.attachments
        .where((element) =>
            (element.ogScrapeUrl == null && element.type != null) ||
            element.type == 'giphy')
        .forEach((e) {
      if (attachmentGroups[e.type] == null) {
        attachmentGroups[e.type!] = [];
      }

      attachmentGroups[e.type]?.add(e);
    });

    final attachmentList = <Widget>[];

    attachmentGroups.forEach((type, attachments) {
      final attachmentBuilder = widget.attachmentBuilders[type];

      if (attachmentBuilder == null) return;
      final attachmentWidget = attachmentBuilder(
        context,
        widget.message,
        attachments,
      );
      attachmentList.add(attachmentWidget);
    });

    return Padding(
      padding: widget.attachmentPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: attachmentList.insertBetween(SizedBox(
          height: widget.attachmentPadding.vertical / 2,
        )),
      ),
    );
  }

  void onLongPress(BuildContext context) {
    if (widget.message.isEphemeral ||
        widget.message.status == MessageSendingStatus.sending) {
      return;
    }

    if (widget.onMessageActions != null) {
      widget.onMessageActions!(context, widget.message);
    } else {
      _showMessageActionModalBottomSheet(context);
    }
    return;
  }

  Widget _buildSendingIndicator() {
    final style = widget.messageTheme.createdAtStyle;
    final message = widget.message;

    if (hasNonUrlAttachments &&
        (message.status == MessageSendingStatus.sending ||
            message.status == MessageSendingStatus.updating)) {
      final totalAttachments = message.attachments.length;
      final uploadRemaining =
          message.attachments.where((it) => !it.uploadState.isSuccess).length;
      if (uploadRemaining == 0) {
        return StreamSvgIcon.check(
          size: style!.fontSize! + 2.fzs,
          color: IconTheme.of(context).color!.withOpacity(0.5),
        );
      }
      return Text(
        context.translations.attachmentsUploadProgressText(
          remaining: uploadRemaining,
          total: totalAttachments,
        ),
        style: style,
      );
    }

    final channel = StreamChannel.of(context).channel;

    if (!channel.ownCapabilities.contains(PermissionType.readEvents)) {
      return StreamSendingIndicator(
        message: message,
        size: style!.fontSize,
      );
    }

    return BetterStreamBuilder<List<Read>>(
      stream: channel.state?.readStream,
      initialData: channel.state?.read,
      builder: (context, data) {
        final readList = data.where((it) =>
            it.user.id != _streamChat.currentUser?.id &&
            (it.lastRead.isAfter(message.createdAt) ||
                it.lastRead.isAtSameMomentAs(message.createdAt)));
        final isMessageRead = readList.length >= (channel.memberCount ?? 0) - 1;
        return StreamSendingIndicator(
          message: message,
          isMessageRead: isMessageRead,
          size: style!.fontSize! + 2.fzs,
        );
      },
    );
  }

  Widget _buildTextBubble() {
    if (widget.message.text?.trim().isEmpty ?? false) return const Offstage();

    if (widget.message.user!.id == 'wer6bot' && widget.botBuilder != null) {
      return widget.botBuilder!(context, widget.message);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: isOnlyEmoji ? EdgeInsets.zero : widget.textPadding,
          child: widget.textBuilder != null
              ? widget.textBuilder!(context, widget.message)
              : StreamMessageText(
                  onLinkTap: widget.onLinkTap,
                  message: widget.message,
                  onMentionTap: widget.onMentionTap,
                  messageTheme: isOnlyEmoji
                      ? widget.messageTheme.copyWith(
                          messageTextStyle:
                              widget.messageTheme.messageTextStyle!.copyWith(
                            fontSize: 42.fzs,
                          ),
                        )
                      : widget.messageTheme,
                ),
        ),
        if (hasUrlAttachments && !hasQuotedMessage) _buildUrlAttachment(),
      ],
    );
  }

  bool get isPinned => widget.message.pinned;

  Color? _getBackgroundColor() {
    if (hasQuotedMessage) {
      return widget.messageTheme.messageBackgroundColor;
    }

    if (hasUrlAttachments) {
      return widget.messageTheme.linkBackgroundColor;
    }

    if (isOnlyEmoji) {
      return Colors.transparent;
    }

    if (widget.message.user!.id == 'wer6bot') {
      return widget.messageTheme.botBackgroundColor;
    }

    return widget.messageTheme.messageBackgroundColor;
  }

  void retryMessage(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    if (widget.message.status == MessageSendingStatus.failed) {
      channel.sendMessage(widget.message);
      return;
    }
    if (widget.message.status == MessageSendingStatus.failed_update) {
      channel.updateMessage(widget.message);
      return;
    }

    if (widget.message.status == MessageSendingStatus.failed_delete) {
      channel.deleteMessage(widget.message);
      return;
    }
  }
}
