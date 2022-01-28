import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:video_player/video_player.dart';

/// Widget builder for quoted message attachment thumnail
typedef QuotedMessageAttachmentThumbnailBuilder = Widget Function(
  BuildContext,
  Attachment,
);

class _VideoAttachmentThumbnail extends StatefulWidget {
  const _VideoAttachmentThumbnail({
    Key? key,
    required this.attachment,
    this.size = const Size(32, 32),
  }) : super(key: key);

  final Size size;
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
    _controller = VideoPlayerController.network(widget.attachment.assetUrl!)
      ..initialize().then((_) {
        // ignore: no-empty-block
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.size.height,
        width: widget.size.width,
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : const CircularProgressIndicator(),
      );
}

///
class QuotedMessageWidget extends StatelessWidget {
  ///
  const QuotedMessageWidget({
    Key? key,
    required this.message,
    required this.messageTheme,
    this.reverse = false,
    this.showBorder = false,
    this.textLimit = 170,
    this.attachmentThumbnailBuilders,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
  }) : super(key: key);

  /// The message
  final Message message;

  /// The message theme
  final MessageThemeData messageTheme;

  /// If true the widget will be mirrored
  final bool reverse;

  /// If true the message will show a grey border
  final bool showBorder;

  /// limit of the text message shown
  final int textLimit;

  /// Map that defines a thumbnail builder for an attachment type
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      attachmentThumbnailBuilders;

  /// Padding around the widget
  final EdgeInsetsGeometry padding;

  /// Callback for tap on widget
  final GestureTapCallback? onTap;

  bool get _hasAttachments => message.attachments.isNotEmpty;

  bool get _containsLinkAttachment =>
      message.attachments.any((element) => element.titleLink != null);

  bool get _containsText => message.text?.isNotEmpty == true;

  @override
  Widget build(BuildContext context) {
    final children = [
      if (message.user != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            message.user!.id == StreamChat.of(context).currentUser!.id
                ? 'You'
                : message.user?.name ?? '',
            maxLines: 1,
            key: const Key('usernameKey'),
            style: messageTheme.messageAuthorStyle!.copyWith(
              color: const Color(0xFFF28B82),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      _buildMessage(context),
      const SizedBox(width: 8),
    ];
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
            bottom: Radius.circular(6),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: const Border(
                left: BorderSide(color: Color(0xFFF28B82), width: 4),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    final isOnlyEmoji = message.text!.isOnlyEmoji;
    var msg = _hasAttachments && !_containsText
        ? message.copyWith(text: message.attachments.last.title ?? '')
        : message;
    if (msg.text!.length > textLimit) {
      msg = msg.copyWith(text: '${msg.text!.substring(0, textLimit - 3)}...');
    }

    final children = [
      if (_hasAttachments) _parseAttachments(context),
      if (msg.text!.isNotEmpty)
        Flexible(
          child: MessageText(
            message: msg,
            messageTheme: isOnlyEmoji && _containsText
                ? messageTheme.copyWith(
                    messageTextStyle: messageTheme.messageTextStyle?.copyWith(
                      fontSize: 32,
                    ),
                  )
                : messageTheme.copyWith(
                    messageTextStyle: messageTheme.messageTextStyle?.copyWith(
                      fontSize: 12,
                    ),
                  ),
          ),
        ),
    ].insertBetween(const SizedBox(width: 8));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          reverse ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildUrlAttachment(Attachment attachment) {
    const size = Size(32, 32);
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
    return const AttachmentError(size: size);
  }

  Widget _parseAttachments(BuildContext context) {
    Widget child;
    Attachment attachment;
    if (_containsLinkAttachment) {
      attachment = message.attachments.firstWhere(
        (element) => element.titleLink != null,
      );
      child = _buildUrlAttachment(attachment);
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
    child = AbsorbPointer(child: child);
    return Material(
      clipBehavior: Clip.hardEdge,
      type: MaterialType.transparency,
      shape: attachment.type == 'file' ? null : _getDefaultShape(context),
      child: child,
    );
  }

  ShapeBorder _getDefaultShape(BuildContext context) => RoundedRectangleBorder(
        side: const BorderSide(width: 0, color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      );

  Map<String, QuotedMessageAttachmentThumbnailBuilder>
      get _defaultAttachmentBuilder => {
            'image': (_, attachment) => ImageAttachment(
                  attachment: attachment,
                  message: message,
                  messageTheme: messageTheme,
                  size: const Size(32, 32),
                ),
            'video': (_, attachment) => _VideoAttachmentThumbnail(
                  key: ValueKey(attachment.assetUrl),
                  attachment: attachment,
                ),
            'giphy': (_, attachment) {
              const size = Size(32, 32);
              return CachedNetworkImage(
                height: size.height,
                width: size.width,
                placeholder: (_, __) => SizedBox(
                  width: size.width,
                  height: size.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                imageUrl: attachment.thumbUrl ??
                    attachment.imageUrl ??
                    attachment.assetUrl!,
                errorWidget: (context, url, error) =>
                    const AttachmentError(size: size),
                fit: BoxFit.cover,
              );
            },
            'file': (_, attachment) => SizedBox(
                  height: 32,
                  width: 32,
                  child: getFileTypeImage(
                    attachment.extraData['mime_type'] as String?,
                  ),
                ),
          };
}
