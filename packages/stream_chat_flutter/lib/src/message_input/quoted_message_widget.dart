import 'package:flutter/material.dart';
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
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  /// Callback for clearing quoted messages.
  final VoidCallback? onQuotedMessageClear;

  /// {@macro textBuilder}
  final Widget Function(BuildContext, Message)? textBuilder;

  @override
  Widget build(BuildContext context) {
    final color = message.user?.extraData['color'];
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
        bottom: Radius.circular(6),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: showBorder
              ? Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.5)
              : null,
          border: Border(
            left: BorderSide(
              color: color == null
                  ? Theme.of(context).colorScheme.tertiary
                  : Color(int.parse('0x$color')),
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: showBorder
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.start,
            children: [
              if (!isDm)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Username(
                    messageTheme: messageTheme,
                    message: message,
                  ),
                ),
              _QuotedMessage(
                message: message,
                textLimit: textLimit,
                messageTheme: messageTheme,
                showBorder: showBorder,
                reverse: reverse,
                textBuilder: textBuilder,
                onQuotedMessageClear: onQuotedMessageClear,
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

  /// Map that defines a thumbnail builder for an attachment type
  final _Builders? attachmentThumbnailBuilders;

  bool get _hasAttachments => message.attachments.isNotEmpty;

  bool get _containsText => message.text?.isNotEmpty == true;

  bool get _isGiphy =>
      message.attachments.any((element) => element.type == 'giphy');

  bool get _isVoiceNote =>
      message.attachments.any((element) => element.type == 'voicenote');

  bool get _isDeleted => message.isDeleted || message.deletedAt != null;

  bool get _isPoll => message.poll != null;

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
            color: messageTheme.createdAtStyle?.color,
          ),
        ),
      ];
    } else if (_isPoll) {
      // Show poll message
      children = [
        Flexible(
          child: Text(
            '📊 ${message.poll?.name}',
            style: messageTheme.messageTextStyle?.copyWith(
              fontSize: 12,
            ),
          ),
        ),
      ];
    } else {
      // Show quoted message
      children = [
        if (_hasAttachments)
          _ParseAttachments(
            message: message,
            messageTheme: messageTheme,
            attachmentThumbnailBuilders: attachmentThumbnailBuilders,
          ),
        if (msg.text!.isNotEmpty && !_isGiphy && !_isVoiceNote)
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
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
    if (attachment.type != AttachmentType.file &&
        attachment.type != AttachmentType.voiceRecording) {
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
          ),
          child: thumbnail,
        );
      }

      return thumbnail;
    }

    Widget _createVoiceNoteThumbnail(
        BuildContext context, Attachment attachment) {
      final durationInInt = attachment.extraData['duration'] as int?;
      var text = '';
      if (durationInInt != null) {
        final duration = Duration(seconds: durationInInt);
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
            size: 20,
            color: Theme.of(context).colorScheme.outline,
          ),
          if (text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                text,
                style: messageTheme.messageTextStyle?.copyWith(
                  fontSize: 14,
                ),
              ),
            ),
        ],
      );
    }

    return {
      AttachmentType.image: _createMediaThumbnail,
      AttachmentType.giphy: _createMediaThumbnail,
      AttachmentType.video: _createMediaThumbnail,
      AttachmentType.urlPreview: _createUrlThumbnail,
      AttachmentType.file: _createFileThumbnail,
      AttachmentType.voiceRecording: _createFileThumbnail,
      'voicenote': _createVoiceNoteThumbnail,
      // 'voiceRecording': _createVoiceNoteThumbnail,
    };
  }
}
