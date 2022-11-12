import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/src/attachment/attachment_widget.dart';
<<<<<<< HEAD
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/upload_progress_indicator.dart';
import 'package:stream_chat_flutter/src/utils.dart';
import 'package:stream_chat_flutter/src/video_thumbnail_image.dart';
=======
import 'package:stream_chat_flutter/src/attachment/handler/stream_attachment_handler.dart';
import 'package:stream_chat_flutter/src/indicators/upload_progress_indicator.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter/src/video/video_thumbnail_image.dart';
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamFileAttachment}
/// Displays file attachments that have been sent in a chat.
///
/// Used in [MessageWidget].
/// {@endtemplate}
class StreamFileAttachment extends StreamAttachmentWidget {
  /// {@macro streamFileAttachment}
  const StreamFileAttachment({
    super.key,
    required super.message,
    required super.attachment,
    super.constraints,
    this.title,
    this.trailing,
    this.onAttachmentTap,
  });

  /// Title for the attachment
  final Widget? title;

  /// Widget for displaying at the end of the attachment
  /// (such as a download button)
  final Widget? trailing;

  /// {@macro onAttachmentTap}
  final OnAttachmentTap? onAttachmentTap;

  /// Checks if the attachment is a video
  bool get isVideoAttachment => attachment.title?.mimeType?.type == 'video';

  /// Checks if the attachment is an image
  bool get isImageAttachment => attachment.title?.mimeType?.type == 'image';

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return Material(
      child: GestureDetector(
        onTap: onAttachmentTap,
        child: Container(
<<<<<<< HEAD
          width: size?.width ?? 100.w,
          height: 56.h,
=======
          constraints: constraints ?? const BoxConstraints.tightFor(width: 100),
          height: 56,
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
          decoration: BoxDecoration(
            color: colorTheme.barsBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: colorTheme.borders,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
<<<<<<< HEAD
                height: 40.h,
                width: 30.w,
                margin: EdgeInsets.all(8.r),
                child: _getFileTypeImage(context),
=======
                height: 40,
                width: 33.33,
                margin: const EdgeInsets.all(8),
                child: _FileTypeImage(
                  isImageAttachment: isImageAttachment,
                  isVideoAttachment: isVideoAttachment,
                  source: source,
                  attachment: attachment,
                ),
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attachment.title ?? context.translations.fileText,
                      style: StreamChatTheme.of(context)
                          .textTheme
                          .bodyBold
                          .copyWith(
                            fontSize: 15.fzs,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
<<<<<<< HEAD
                    SizedBox(height: 3.h),
                    _buildSubtitle(context),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              _buildTrailing(context),
=======
                    const SizedBox(height: 3),
                    _FileAttachmentSubtitle(attachment: attachment),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                type: MaterialType.transparency,
                child: trailing ??
                    _Trailing(
                      attachment: attachment,
                      message: message,
                    ),
              ),
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
            ],
          ),
        ),
      ),
    );
  }
}

class _FileTypeImage extends StatelessWidget {
  const _FileTypeImage({
    required this.isImageAttachment,
    required this.isVideoAttachment,
    required this.source,
    required this.attachment,
  });

  final bool isImageAttachment;
  final bool isVideoAttachment;
  final AttachmentSource source;
  final Attachment attachment;

  ShapeBorder _getDefaultShape(BuildContext context) {
    return RoundedRectangleBorder(
      side: const BorderSide(width: 0, color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    );
  }

  // TODO: Improve image memory.
  // This is using the full image instead of a smaller version (thumbnail)
  @override
  Widget build(BuildContext context) {
    if (isImageAttachment) {
      return Material(
        clipBehavior: Clip.hardEdge,
        type: MaterialType.transparency,
        shape: _getDefaultShape(context),
        child: source.when(
          local: () {
            if (attachment.file?.bytes == null) {
              return getFileTypeImage(
                attachment.extraData['mime_type'] as String?,
              );
            }
            return Image.memory(
              attachment.file!.bytes!,
              fit: BoxFit.cover,
              errorBuilder: (_, obj, trace) => getFileTypeImage(
                attachment.extraData['mime_type'] as String?,
              ),
            );
          },
          network: () {
            if ((attachment.imageUrl ??
                    attachment.assetUrl ??
                    attachment.thumbUrl) ==
                null) {
              return getFileTypeImage(
                attachment.extraData['mime_type'] as String?,
              );
            }
            return CachedNetworkImage(
              imageUrl: attachment.imageUrl ??
                  attachment.assetUrl ??
                  attachment.thumbUrl!,
              fit: BoxFit.cover,
              errorWidget: (_, obj, trace) => getFileTypeImage(
                attachment.extraData['mime_type'] as String?,
              ),
              placeholder: (_, __) {
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
            );
          },
        ),
      );
    }

    if (isVideoAttachment) {
      return Material(
        clipBehavior: Clip.hardEdge,
        type: MaterialType.transparency,
        shape: _getDefaultShape(context),
        child: source.when(
          local: () => StreamVideoThumbnailImage(
            video: attachment.file!.path!,
            placeholderBuilder: (_) => const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          network: () => StreamVideoThumbnailImage(
            video: attachment.assetUrl!,
            placeholderBuilder: (_) => const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      );
    }
    return getFileTypeImage(attachment.extraData['mime_type'] as String?);
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    required this.attachment,
    required this.message,
  });

  final Attachment attachment;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final channel = StreamChannel.of(context).channel;
    final attachmentId = attachment.id;

    if (message.status == MessageSendingStatus.sent) {
      return IconButton(
        icon: StreamSvgIcon.cloudDownload(
          color: theme.colorTheme.textHighEmphasis,
        ),
        visualDensity: VisualDensity.compact,
        splashRadius: 16,
        onPressed: () async {
          final assetUrl = attachment.assetUrl;
          if (assetUrl != null) {
            if (isMobileDeviceOrWeb) {
              launchURL(context, assetUrl);
            } else {
              StreamAttachmentHandler.instance.downloadAttachment(attachment);
            }
          }
        },
      );
    }

    return attachment.uploadState.when(
      preparing: () => Padding(
<<<<<<< HEAD
        padding: EdgeInsets.all(8.r),
        child: _buildButton(
          iconSize: 24.r,
          icon: StreamSvgIcon.close(color: theme.colorTheme.barsBg, size: 24.r),
=======
        padding: const EdgeInsets.all(8),
        child: _TrailingButton(
          icon: StreamSvgIcon.close(color: theme.colorTheme.barsBg),
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.cancelAttachmentUpload(attachmentId),
        ),
      ),
      inProgress: (_, __) => Padding(
<<<<<<< HEAD
        padding: EdgeInsets.all(8.r),
        child: _buildButton(
          iconSize: 24.r,
          icon: StreamSvgIcon.close(color: theme.colorTheme.barsBg, size: 24.r),
=======
        padding: const EdgeInsets.all(8),
        child: _TrailingButton(
          icon: StreamSvgIcon.close(color: theme.colorTheme.barsBg),
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.cancelAttachmentUpload(attachmentId),
        ),
      ),
      success: () => Padding(
        padding: EdgeInsets.all(8.r),
        child: CircleAvatar(
          backgroundColor: theme.colorTheme.accentPrimary,
          maxRadius: 12.r,
          child: StreamSvgIcon.check(
            color: theme.colorTheme.barsBg,
            size: 24.r,
          ),
        ),
      ),
      failed: (_) => Padding(
<<<<<<< HEAD
        padding: EdgeInsets.all(8.r),
        child: _buildButton(
          iconSize: 24.r,
          icon: StreamSvgIcon.retry(
            color: theme.colorTheme.barsBg,
            size: 24.r,
          ),
=======
        padding: const EdgeInsets.all(8),
        child: _TrailingButton(
          icon: StreamSvgIcon.retry(color: theme.colorTheme.barsBg),
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0
          fillColor: theme.colorTheme.overlayDark,
          onPressed: () => channel.retryAttachmentUpload(
            message.id,
            attachmentId,
          ),
        ),
      ),
    );
  }
}

<<<<<<< HEAD
    if (message.status == MessageSendingStatus.sent) {
      trailingWidget = IconButton(
        icon: StreamSvgIcon.cloudDownload(
          color: theme.colorTheme.textHighEmphasis,
          size: 24.r,
        ),
        visualDensity: VisualDensity.compact,
        splashRadius: 16.r,
        onPressed: () {
          final assetUrl = attachment.assetUrl;
          if (assetUrl != null) launchURL(context, assetUrl);
        },
      );
    }
=======
class _TrailingButton extends StatelessWidget {
  const _TrailingButton({
    this.onPressed,
    this.fillColor,
    this.icon,
  });
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0

  final VoidCallback? onPressed;
  final Color? fillColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: RawMaterialButton(
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        onPressed: onPressed,
        fillColor: fillColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: icon,
      ),
    );
  }
}

class _FileAttachmentSubtitle extends StatelessWidget {
  const _FileAttachmentSubtitle({
    required this.attachment,
  });

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final size = attachment.file?.size ?? attachment.extraData['file_size'];
    final textStyle = theme.textTheme.footnote.copyWith(
      color: theme.colorTheme.textLowEmphasis,
      fontSize: 12.fzs,
    );
    return attachment.uploadState.when(
      preparing: () => Text(fileSize(size), style: textStyle),
      inProgress: (sent, total) => StreamUploadProgressIndicator(
        uploaded: sent,
        total: total,
        showBackground: false,
        padding: EdgeInsets.zero,
        textStyle: textStyle,
        progressIndicatorColor: theme.colorTheme.accentPrimary,
      ),
      success: () => Text(fileSize(size), style: textStyle),
      failed: (_) => Text(
        context.translations.uploadErrorLabel,
        style: textStyle,
      ),
    );
  }
}
