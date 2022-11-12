import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:stream_chat_flutter/src/attachment/attachment_title.dart';
=======
import 'package:shimmer/shimmer.dart';
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamImageAttachment}
/// Shows an image attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamImageAttachment extends StreamAttachmentWidget {
  /// {@macro streamImageAttachment}
  const StreamImageAttachment({
    super.key,
    required super.message,
    required super.attachment,
    required this.messageTheme,
    super.constraints,
    this.showTitle = false,
    this.onShowMessage,
<<<<<<< HEAD
    this.onReturnAction,
    this.showReply = true,
    this.showDelete = true,
=======
    this.onReplyMessage,
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
    this.onAttachmentTap,
    this.imageThumbnailSize = const Size(400, 400),
    this.imageThumbnailResizeType = 'clip',
    this.imageThumbnailCropType = 'center',
  });

  /// The [StreamMessageThemeData] to use for the image title
  final StreamMessageThemeData messageTheme;

  /// Flag for whether the title should be shown or not
  final bool showTitle;

  /// {@macro showMessageCallback}
  final ShowMessageCallback? onShowMessage;

  /// {@macro replyMessageCallback}
  final ReplyMessageCallback? onReplyMessage;

  /// {@macro onAttachmentTap}
  final OnAttachmentTap? onAttachmentTap;

  /// Show reply option
  final bool showReply;

  /// Show delete option
  final bool showDelete;

  /// Size of the attachment image thumbnail.
  final Size imageThumbnailSize;

  /// Resize type of the image attachment thumbnail.
  ///
  /// Defaults to [crop]
  final String /*clip|crop|scale|fill*/ imageThumbnailResizeType;

  /// Crop type of the image attachment thumbnail.
  ///
  /// Defaults to [center]
  final String /*center|top|bottom|left|right*/ imageThumbnailCropType;

  @override
  Widget build(BuildContext context) {
    return source.when(
      local: () {
        if (attachment.localUri == null || attachment.file?.bytes == null) {
          return AttachmentError(constraints: constraints);
        }
        return _buildImageAttachment(
          context,
          Image.memory(
            attachment.file!.bytes!,
            height: constraints?.maxHeight,
            width: constraints?.maxWidth,
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) => Image.asset(
              'images/placeholder.png',
              package: 'stream_chat_flutter',
            ),
          ),
        );
      },
      network: () {
        var imageUrl =
            attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl;

        if (imageUrl == null) {
          return AttachmentError(constraints: constraints);
        }

        imageUrl = imageUrl.getResizedImageUrl(
          width: imageThumbnailSize.width,
          height: imageThumbnailSize.height,
          resize: imageThumbnailResizeType,
          crop: imageThumbnailCropType,
        );

        return _buildImageAttachment(
          context,
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: constraints?.maxHeight,
            width: constraints?.maxWidth,
            fit: BoxFit.cover,
            placeholder: (context, __) {
              final image = Image.asset(
                'images/placeholder.png',
                fit: BoxFit.cover,
                package: 'stream_chat_flutter',
<<<<<<< HEAD
              ),
            ),
          );
        },
        network: () {
          final imageUrl =
              attachment.thumbUrl ?? attachment.imageUrl ?? attachment.assetUrl;

          if (imageUrl == null) return AttachmentError(size: size);

          // imageUrl = imageUrl.getResizedImageUrl(
          //   width: imageThumbnailSize.width,
          //   height: imageThumbnailSize.height,
          //   resize: imageThumbnailResizeType,
          //   crop: imageThumbnailCropType,
          // );

          return _buildImageAttachment(
            context,
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: size?.height,
              width: size?.width,
              fit: BoxFit.cover,
              placeholder: (context, __) {
                final image = Image.asset(
                  'images/placeholder.png',
                  fit: BoxFit.cover,
                  package: 'stream_chat_flutter',
                );
                final colorTheme = StreamChatTheme.of(context).colorTheme;
                return Shimmer.fromColors(
                  baseColor: colorTheme.disabled,
                  highlightColor: colorTheme.inputBg,
                  child: image,
                );
              },
              errorWidget: (context, url, error) => AttachmentError(size: size),
            ),
          );
        },
      );

  Widget _buildImageAttachment(BuildContext context, Widget imageWidget) =>
      ConstrainedBox(
        constraints: BoxConstraints.loose(size!),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
=======
              );
              final colorTheme = StreamChatTheme.of(context).colorTheme;
              return Shimmer.fromColors(
                baseColor: colorTheme.disabled,
                highlightColor: colorTheme.inputBg,
                child: image,
              );
            },
            errorWidget: (context, url, error) =>
                AttachmentError(constraints: constraints),
          ),
        );
      },
    );
  }

  Widget _buildImageAttachment(BuildContext context, Widget imageWidget) {
    return Container(
      constraints: constraints,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
                    onTap: onAttachmentTap ??
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                final channel =
                                    StreamChannel.of(context).channel;
                                return StreamChannel(
                                  channel: channel,
<<<<<<< HEAD
                                  child: StreamFullScreenMedia(
                                    showDelete: showDelete,
                                    showReply: showReply,
=======
                                  child: StreamFullScreenMediaBuilder(
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
                                    mediaAttachmentPackages:
                                        message.getAttachmentPackageList(),
                                    startIndex:
                                        message.attachments.indexOf(attachment),
                                    userName: message.user!.name,
                                    onShowMessage: onShowMessage,
                                    onReplyMessage: onReplyMessage,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                    child: imageWidget,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: StreamAttachmentUploadStateBuilder(
                    message: message,
                    attachment: attachment,
                  ),
                ),
              ],
            ),
          ),
          if (showTitle && attachment.title != null)
            Material(
              color: messageTheme.messageBackgroundColor,
              child: StreamAttachmentTitle(
                messageTheme: messageTheme,
                attachment: attachment,
              ),
            ),
        ],
      ),
    );
  }
}
