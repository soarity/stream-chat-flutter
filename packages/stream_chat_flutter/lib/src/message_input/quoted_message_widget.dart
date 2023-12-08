import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
=======
import 'package:stream_chat_flutter/src/attachment/thumbnail/file_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/image_attachment_thumbnail.dart';
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
import 'package:stream_chat_flutter/src/message_input/clear_input_item_button.dart';
import 'package:stream_chat_flutter/src/message_widget/username.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

typedef _Builders = Map<String, QuotedMessageAttachmentThumbnailBuilder>;

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
    this.textBuilder,
    this.attachmentThumbnailBuilders,
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
  final _Builders? attachmentThumbnailBuilders;

  /// Callback for clearing quoted messages.
  final VoidCallback? onQuotedMessageClear;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final color = message.user?.extraData['color'];
    return ClipRRect(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(12.r),
        bottom: Radius.circular(6.r),
=======
    final children = [
      Flexible(
        child: _QuotedMessage(
          message: message,
          textLimit: textLimit,
          messageTheme: messageTheme,
          showBorder: showBorder,
          reverse: reverse,
          textBuilder: textBuilder,
          onQuotedMessageClear: onQuotedMessageClear,
          attachmentThumbnailBuilders: attachmentThumbnailBuilders,
        ),
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: showBorder
              ? Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5)
              : null,
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
          padding: EdgeInsets.fromLTRB(8.w, 8.h, 0, 8.h),
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
    this.textBuilder,
    this.onQuotedMessageClear,
    this.attachmentThumbnailBuilders,
  });

  final Message message;
  final int textLimit;
  final VoidCallback? onQuotedMessageClear;
  final StreamMessageThemeData messageTheme;
  final bool showBorder;
  final bool reverse;
  final Widget Function(BuildContext, Message)? textBuilder;

  final _Builders? attachmentThumbnailBuilders;

  bool get _hasAttachments => message.attachments.isNotEmpty;

  bool get _containsText => message.text?.isNotEmpty == true;

<<<<<<< HEAD
  bool get _isGiphy =>
      message.attachments.any((element) => element.type == 'giphy');
=======
  bool get _containsLinkAttachment =>
      message.attachments.any((it) => it.type == AttachmentType.urlPreview);

  bool get _isGiphy => message.attachments
      .any((element) => element.type == AttachmentType.giphy);
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158

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
<<<<<<< HEAD
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
=======
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
        if (_hasAttachments)
          _ParseAttachments(
            message: message,
            messageTheme: messageTheme,
            attachmentThumbnailBuilders: attachmentThumbnailBuilders,
          ),
<<<<<<< HEAD
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
=======
        if (msg.text!.isNotEmpty && !_isGiphy)
          Flexible(
            child: textBuilder?.call(context, msg) ??
                StreamMessageText(
                  message: msg,
                  messageTheme: isOnlyEmoji && _containsText
                      ? messageTheme.copyWith(
                          messageTextStyle:
                              messageTheme.messageTextStyle?.copyWith(
                            fontSize: 32,
                          ),
                        )
                      : messageTheme.copyWith(
                          messageTextStyle:
                              messageTheme.messageTextStyle?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                ),
          ),
      ];
    }

    // Add clear button if needed.
    if (isDesktopDeviceOrWeb && onQuotedMessageClear != null) {
      children.insert(
        0,
        ClearInputItemButton(onTap: onQuotedMessageClear),
      );
    }

    // Add some spacing between the children.
    children = children.insertBetween(const SizedBox(width: 8));

    return Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(context),
        border: showBorder
            ? Border.all(
                color: StreamChatTheme.of(context).colorTheme.disabled,
              )
            : null,
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(12),
          topLeft: const Radius.circular(12),
          bottomRight: reverse ? const Radius.circular(12) : Radius.zero,
          bottomLeft: reverse ? Radius.zero : const Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            reverse ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: reverse ? children.reversed.toList() : children,
      ),
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
    );
  }
}

class _ParseAttachments extends StatefulWidget {
  const _ParseAttachments({
    required this.message,
    required this.messageTheme,
    this.attachmentThumbnailBuilders,
  });

  final Message message;
  final StreamMessageThemeData messageTheme;
<<<<<<< HEAD
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  @override
  State<_ParseAttachments> createState() => _ParseAttachmentsState();
}

class _ParseAttachmentsState extends State<_ParseAttachments> {
  bool get _containsLinkAttachment =>
      widget.message.attachments.any((element) => element.titleLink != null);

  @override
  Widget build(BuildContext context) {
    Widget child;
    Attachment attachment;
    if (_containsLinkAttachment) {
      attachment = widget.message.attachments.firstWhere(
        (element) => element.ogScrapeUrl != null || element.titleLink != null,
      );
      child = _UrlAttachment(attachment: attachment);
    } else {
      QuotedMessageAttachmentThumbnailBuilder? attachmentBuilder;
      attachment = widget.message.attachments.last;
      if (widget.attachmentThumbnailBuilders?.containsKey(attachment.type) ==
          true) {
        attachmentBuilder =
            widget.attachmentThumbnailBuilders![attachment.type];
      }
      attachmentBuilder = _defaultAttachmentBuilder[attachment.type];
      if (attachmentBuilder == null) {
        child = const Offstage();
      } else {
        child = attachmentBuilder(context, attachment);
      }
=======
  final _Builders? attachmentThumbnailBuilders;

  @override
  Widget build(BuildContext context) {
    final attachment = message.attachments.first;

    var attachmentBuilders = attachmentThumbnailBuilders;
    attachmentBuilders ??= _createDefaultAttachmentBuilders();

    // Build the attachment widget using the builder for the attachment type.
    final attachmentWidget = attachmentBuilders[attachment.type]?.call(
      context,
      attachment,
    );

    // Return empty container if no attachment widget is returned.
    if (attachmentWidget == null) return const SizedBox.shrink();

    final colorTheme = StreamChatTheme.of(context).colorTheme;

    var clipBehavior = Clip.none;
    ShapeDecoration? decoration;
    if (attachment.type != AttachmentType.file) {
      clipBehavior = Clip.hardEdge;
      decoration = ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      );
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
    }

    return Container(
      key: Key(attachment.id),
      clipBehavior: clipBehavior,
      decoration: decoration,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      child: AbsorbPointer(child: attachmentWidget),
    );
  }

  _Builders _createDefaultAttachmentBuilders() {
    Widget _createMediaThumbnail(BuildContext context, Attachment media) {
      return StreamImageAttachmentThumbnail(
        image: media,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    Widget _createUrlThumbnail(BuildContext context, Attachment media) {
      return StreamImageAttachmentThumbnail(
        image: media,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    Widget _createFileThumbnail(BuildContext context, Attachment file) {
      Widget thumbnail = StreamFileAttachmentThumbnail(
        file: file,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );

      final mediaType = file.title?.mediaType;
      final isImage = mediaType?.type == AttachmentType.image;
      final isVideo = mediaType?.type == AttachmentType.video;
      if (isImage || isVideo) {
        final colorTheme = StreamChatTheme.of(context).colorTheme;
        thumbnail = Container(
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: colorTheme.borders,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
<<<<<<< HEAD
      child: AbsorbPointer(child: child),
    );
  }

  Map<String, QuotedMessageAttachmentThumbnailBuilder>
      get _defaultAttachmentBuilder {
    final builders = <String, QuotedMessageAttachmentThumbnailBuilder>{
      'image': (_, attachment) {
        return StreamImageAttachment(
          attachment: attachment,
          message: widget.message,
          messageTheme: widget.messageTheme,
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
=======
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
          ),
          child: thumbnail,
        );
<<<<<<< HEAD
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
        final durationInInt = attachment.extraData['duration'] as int?;
        var text = '';
        if (durationInInt != null) {
          final duration = Duration(milliseconds: durationInInt);
          final minuteLeft = duration.inMinutes.remainder(60);
          final minutes =
              minuteLeft.toString().padLeft(minuteLeft >= 10 ? 2 : 1, '0');
          final seconds =
              duration.inSeconds.remainder(60).toString().padLeft(2, '0');
          text = '$minutes:$seconds';
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageIcon(
              const AssetImage('assets/icons/microphone.png'),
              size: 20.r,
              color: Theme.of(context).colorScheme.outline,
            ),
            if (text.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Text(
                  text,
                  style: widget.messageTheme.messageTextStyle?.copyWith(
                    fontSize: 14.fzs,
                  ),
                ),
              ),
          ],
        );
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
=======
      }

      return thumbnail;
    }

    return {
      AttachmentType.image: _createMediaThumbnail,
      AttachmentType.giphy: _createMediaThumbnail,
      AttachmentType.video: _createMediaThumbnail,
      AttachmentType.urlPreview: _createUrlThumbnail,
      AttachmentType.file: _createFileThumbnail,
    };
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
  }
}
