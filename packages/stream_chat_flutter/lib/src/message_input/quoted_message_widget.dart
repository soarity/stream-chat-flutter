import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/message_input/clear_input_item_button.dart';
import 'package:stream_chat_flutter/src/message_widget/username.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

/// {@template streamQuotedMessage}
/// Widget for the quoted message.
/// {@endtemplate}
class StreamQuotedMessageWidget extends StatelessWidget {
  /// {@macro streamQuotedMessage}
  const StreamQuotedMessageWidget({
    super.key,
    required this.message,
    required this.messageTheme,
    this.reverse = false,
    this.isDm = false,
    this.showBorder = true,
    this.textLimit = 170,
    this.attachmentThumbnailBuilders,
    this.padding = const EdgeInsets.all(8),
    this.onQuotedMessageClear,
  });

  /// The message
  final Message message;

  /// The message theme
  final StreamMessageThemeData messageTheme;

  /// If true the widget will be mirrored
  final bool reverse;

  /// If true the widget will be mirrored
  final bool isDm;

  /// If true the message will show a grey border
  final bool showBorder;

  /// limit of the text message shown
  final int textLimit;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  /// Padding around the widget
  final EdgeInsetsGeometry padding;

  /// Callback for clearing quoted messages.
  final VoidCallback? onQuotedMessageClear;

  @override
  Widget build(BuildContext context) {
    final color = message.user?.extraData['color'];
    return Padding(
      padding: padding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: messageTheme.messageBackgroundColor?.withOpacity(0.5),
            border: Border(
              left: BorderSide(
                color: color == null
                    ? Theme.of(context).colorScheme.tertiary
                    : Color(int.parse('0x$color')),
                width: 4.w,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: showBorder
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.start,
              children: [
                if (!isDm)
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Username(
                      messageTheme: messageTheme,
                      message: message,
                    ),
                  ),
                _QuotedMessage(
                  message: message,
                  textLimit: textLimit,
                  onQuotedMessageClear: onQuotedMessageClear,
                  messageTheme: messageTheme,
                  showBorder: showBorder,
                  reverse: reverse,
                  attachmentThumbnailBuilders: attachmentThumbnailBuilders,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuotedMessage extends StatelessWidget {
  const _QuotedMessage({
    required this.message,
    required this.textLimit,
    required this.messageTheme,
    required this.showBorder,
    required this.reverse,
    this.onQuotedMessageClear,
    this.attachmentThumbnailBuilders,
  });

  final Message message;
  final int textLimit;
  final VoidCallback? onQuotedMessageClear;
  final StreamMessageThemeData messageTheme;
  final bool showBorder;
  final bool reverse;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  bool get _hasAttachments => message.attachments.isNotEmpty;

  bool get _containsText => message.text?.isNotEmpty == true;

  bool get _isGiphy =>
      message.attachments.any((element) => element.type == 'giphy');

  bool get _isVoiceNote =>
      message.attachments.any((element) => element.type == 'voicenote');

  bool get _isDeleted => message.isDeleted || message.deletedAt != null;

  @override
  Widget build(BuildContext context) {
    final isOnlyEmoji = message.text!.isOnlyEmoji;
    var msg = _hasAttachments && !_containsText
        ? message.copyWith(text: message.attachments.last.title ?? '')
        : message;
    if (msg.text!.length > textLimit) {
      msg = msg.copyWith(text: '${msg.text!.substring(0, textLimit - 3)}...');
    }

    List<Widget> children;
    if (_isDeleted) {
      // Show deleted message text
      children = [
        Text(
          context.translations.messageDeletedLabel,
          style: messageTheme.messageTextStyle?.copyWith(
            fontStyle: FontStyle.italic,
            fontSize: 14.fzs,
            color: messageTheme.createdAtStyle?.color,
          ),
        ),
      ];
    } else {
      // Show quoted message
      children = [
        if (msg.text!.isNotEmpty && !_isGiphy && !_isVoiceNote)
          Flexible(
            child: StreamMessageText(
              message: msg,
              messageTheme: isOnlyEmoji && _containsText
                  ? messageTheme.copyWith(
                      messageTextStyle: messageTheme.messageTextStyle?.copyWith(
                        fontSize: 32.fzs,
                      ),
                    )
                  : messageTheme.copyWith(
                      messageTextStyle: messageTheme.messageTextStyle?.copyWith(
                        fontSize: 14.fzs,
                      ),
                    ),
            ),
          ),
        if (_hasAttachments)
          _ParseAttachments(
            message: message,
            messageTheme: messageTheme,
            attachmentThumbnailBuilders: attachmentThumbnailBuilders,
          ),
        if (onQuotedMessageClear != null)
          PlatformWidgetBuilder(
            web: (context, child) => child,
            desktop: (context, child) => child,
            child: ClearInputItemButton(
              onTap: onQuotedMessageClear,
            ),
          ),
      ].insertBetween(SizedBox(width: 8.w));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _ParseAttachments extends StatelessWidget {
  const _ParseAttachments({
    required this.message,
    required this.messageTheme,
    this.attachmentThumbnailBuilders,
  });

  final Message message;
  final StreamMessageThemeData messageTheme;
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  bool get _containsLinkAttachment =>
      message.attachments.any((element) => element.titleLink != null);

  @override
  Widget build(BuildContext context) {
    Widget child;
    Attachment attachment;
    if (_containsLinkAttachment) {
      attachment = message.attachments.firstWhere(
        (element) => element.ogScrapeUrl != null || element.titleLink != null,
      );
      child = _UrlAttachment(attachment: attachment);
    } else {
      QuotedMessageAttachmentThumbnailBuilder? attachmentBuilder;
      attachment = message.attachments.last;
      if (attachmentThumbnailBuilders?.containsKey(attachment.type) == true) {
        attachmentBuilder = attachmentThumbnailBuilders![attachment.type];
      }
      attachmentBuilder = _defaultAttachmentBuilder[attachment.type];
      if (attachmentBuilder == null) {
        child = const Offstage();
      } else {
        child = attachmentBuilder(context, attachment);
      }
    }

    final isImageFile = attachment.title?.mimeType?.type == 'image';
    final isVideoFile = attachment.title?.mimeType?.type == 'video';

    return Material(
      clipBehavior: Clip.hardEdge,
      type: MaterialType.transparency,
      shape: attachment.type == 'file' && (!isImageFile && !isVideoFile)
          ? null
          : RoundedRectangleBorder(
              side: const BorderSide(width: 0, color: Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
      child: AbsorbPointer(child: child),
    );
  }

  Map<String, QuotedMessageAttachmentThumbnailBuilder>
      get _defaultAttachmentBuilder {
    final builders = <String, QuotedMessageAttachmentThumbnailBuilder>{
      'image': (_, attachment) {
        return StreamImageAttachment(
          attachment: attachment,
          message: message,
          messageTheme: messageTheme,
          constraints: BoxConstraints.loose(Size(32.r, 32.r)),
        );
      },
      'video': (_, attachment) {
        return StreamVideoThumbnailImage(
          key: ValueKey(attachment.assetUrl),
          video: attachment.file?.path ?? attachment.assetUrl,
          constraints: BoxConstraints.loose(Size(32.r, 32.r)),
          errorBuilder: (_, __) => AttachmentError(
            constraints: BoxConstraints.loose(Size(32.r, 32.r)),
          ),
        );
      },
      'giphy': (_, attachment) {
        final size = Size(32.r, 32.r);
        return CachedNetworkImage(
          height: size.height,
          width: size.width,
          placeholder: (_, __) {
            return SizedBox(
              width: size.width,
              height: size.height,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          },
          imageUrl: attachment.thumbUrl ??
              attachment.imageUrl ??
              attachment.assetUrl!,
          errorWidget: (context, url, error) =>
              AttachmentError(constraints: BoxConstraints.loose(size)),
          fit: BoxFit.cover,
        );
      },
      'voicenote': (_, attachment) {
        return Icon(Icons.mic, size: 20.r);
      },
      'file': (_, attachment) {
        return SizedBox(
          height: 32.r,
          width: 32.r,
          child: getFileTypeImage(
            attachment.extraData['mime_type'] as String?,
          ),
        );
      },
    };

    builders['file'] = (_, attachment) {
      return SizedBox(
        height: 32,
        width: 32,
        child: Builder(
          builder: (context) {
            final isImageFile = attachment.title?.mimeType?.type == 'image';
            if (isImageFile) {
              return builders['image']!(context, attachment);
            }

            final isVideoFile = attachment.title?.mimeType?.type == 'video';
            if (isVideoFile) {
              return builders['video']!(context, attachment);
            }

            return getFileTypeImage(
              attachment.extraData['mime_type'] as String?,
            );
          },
        ),
      );
    };

    return builders;
  }
}

class _UrlAttachment extends StatelessWidget {
  const _UrlAttachment({
    required this.attachment,
  });

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final size = Size(32.r, 32.r);
    if (attachment.thumbUrl != null) {
      return Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              attachment.thumbUrl!,
            ),
          ),
        ),
      );
    }
    return AttachmentError(constraints: BoxConstraints.loose(size));
  }
}

class _VideoAttachmentThumbnail extends StatefulWidget {
  const _VideoAttachmentThumbnail({
    required this.attachment,
  });

  final Attachment attachment;

  @override
  _VideoAttachmentThumbnailState createState() =>
      _VideoAttachmentThumbnailState();
}

class _VideoAttachmentThumbnailState extends State<_VideoAttachmentThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.attachment.assetUrl!),
    )..initialize().then((_) {
        // ignore: no-empty-block
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.r,
      width: 32.r,
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : const CircularProgressIndicator.adaptive(),
    );
  }
}
