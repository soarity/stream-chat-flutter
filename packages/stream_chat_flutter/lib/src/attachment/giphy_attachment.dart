import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/giphy_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/src/misc/giphy_chip.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamGiphyAttachment}
/// Shows a GIF attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamGiphyAttachment extends StatelessWidget {
  /// {@macro streamGiphyAttachment}
  const StreamGiphyAttachment({
    super.key,
    required this.message,
    required this.giphy,
    this.type = GiphyInfoType.original,
    this.shape,
    this.constraints = const BoxConstraints(),
  });

  /// The [Message] that the giphy is attached to.
  final Message message;

  /// The [Attachment] object containing the giphy information.
  final Attachment giphy;

  /// The type of giphy to display.
  ///
  /// Defaults to [GiphyInfoType.fixedHeight].
  final GiphyInfoType type;

  /// The shape of the attachment.
  ///
  /// Defaults to [RoundedRectangleBorder] with a radius of 14.
  final ShapeBorder? shape;

  /// The constraints to use when displaying the giphy.
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    BoxFit? fit;
    final giphyInfo = giphy.giphyInfo(type);

    Size? giphySize;
    if (giphyInfo != null) {
      giphySize = Size(giphyInfo.width, giphyInfo.height);
    }

    // If attachment size is available, we will tighten the constraints max
    // size to the attachment size.
    var constraints = this.constraints;
    if (giphySize != null) {
      constraints = constraints.tightenMaxSize(giphySize);
    } else {
      // For backward compatibility, we will fill the available space if the
      // attachment size is not available.
      fit = BoxFit.cover;
    }

<<<<<<< HEAD
  Widget _buildSendingAttachment(BuildContext context, String imageUrl) {
    final streamChannel = StreamChannel.of(context);
    return ConstrainedBox(
      constraints: constraints?.copyWith(
            maxHeight: double.infinity,
          ) ??
          const BoxConstraints.expand(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            color: StreamChatTheme.of(context).colorTheme.barsBg,
            elevation: 2,
            clipBehavior: Clip.hardEdge,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      StreamSvgIcon.giphyIcon(),
                      const SizedBox(width: 8),
                      Text(
                        context.translations.giphyLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 8),
                      if (attachment.title != null)
                        Flexible(
                          child: Text(
                            attachment.title!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .textHighEmphasis
                                      .withOpacity(0.5),
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: GestureDetector(
                    onTap: () {
                      if (onAttachmentTap != null) {
                        onAttachmentTap?.call();
                      } else {
                        _onImageTap(context);
                      }
                    },
                    child: CachedNetworkImage(
                      height: constraints?.maxHeight,
                      width: constraints?.maxWidth,
                      placeholder: (_, __) => SizedBox(
                        width: constraints?.maxHeight,
                        height: constraints?.maxWidth,
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      imageUrl: imageUrl,
                      errorWidget: (context, url, error) => AttachmentError(
                        constraints: constraints,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: StreamChatTheme.of(context)
                      .colorTheme
                      .textHighEmphasis
                      .withOpacity(0.2),
                  width: double.infinity,
                  height: 0.5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            streamChannel.channel.sendAction(
                              message,
                              {
                                'image_action': 'cancel',
                              },
                            );
                          },
                          child: Text(
                            context.translations.cancelLabel
                                .toLowerCase()
                                .capitalize(),
                            style: StreamChatTheme.of(context)
                                .textTheme
                                .bodyBold
                                .copyWith(
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .textHighEmphasis
                                      .withOpacity(0.5),
                                ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.5,
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .textHighEmphasis
                          .withOpacity(0.2),
                      height: 50,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            streamChannel.channel.sendAction(
                              message,
                              {
                                'image_action': 'shuffle',
                              },
                            );
                          },
                          child: Text(
                            context.translations.shuffleLabel,
                            style: StreamChatTheme.of(context)
                                .textTheme
                                .bodyBold
                                .copyWith(
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .textHighEmphasis
                                      .withOpacity(0.5),
                                ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 0.5,
                      color: StreamChatTheme.of(context)
                          .colorTheme
                          .textHighEmphasis
                          .withOpacity(0.2),
                      height: 50,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            streamChannel.channel.sendAction(
                              message,
                              {
                                'image_action': 'send',
                              },
                            );
                          },
                          child: Text(
                            context.translations.sendLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: StreamChatTheme.of(context)
                                      .colorTheme
                                      .accentPrimary,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
=======
    final chatTheme = StreamChatTheme.of(context);
    final colorTheme = chatTheme.colorTheme;
    final shape = this.shape ??
        RoundedRectangleBorder(
          side: BorderSide(
            color: colorTheme.borders,
            strokeAlign: BorderSide.strokeAlignOutside,
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
          ),
          borderRadius: BorderRadius.circular(14),
        );

    return Container(
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      decoration: ShapeDecoration(shape: shape),
      child: AspectRatio(
        aspectRatio: giphySize?.aspectRatio ?? 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            StreamGiphyAttachmentThumbnail(
              type: type,
              giphy: giphy,
              fit: fit,
              width: double.infinity,
              height: double.infinity,
            ),
<<<<<<< HEAD
          );
        },
      ),
    );
  }

  Widget _buildSentAttachment(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () {
        if (onAttachmentTap != null) {
          onAttachmentTap?.call();
        } else {
          _onImageTap(context);
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            height: constraints?.maxHeight,
            width: constraints?.maxWidth,
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
            imageUrl: imageUrl,
            errorWidget: (context, url, error) => AttachmentError(
              constraints: constraints,
            ),
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Material(
              color: StreamChatTheme.of(context)
                  .colorTheme
                  .textHighEmphasis
                  .withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    StreamSvgIcon.lightning(
                      color: StreamChatTheme.of(context).colorTheme.barsBg,
                      size: 16,
                    ),
                    Text(
                      context.translations.giphyLabel.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                StreamChatTheme.of(context).colorTheme.barsBg,
                          ),
                    ),
                  ],
=======
            if (giphy.uploadState.isSuccess)
              const Positioned(
                bottom: 8,
                left: 8,
                child: GiphyChip(),
              )
            else
              Padding(
                padding: const EdgeInsets.all(8),
                child: StreamAttachmentUploadStateBuilder(
                  message: message,
                  attachment: giphy,
>>>>>>> 43b8113cbde7b3b202a54ed81158c36bc817a158
                ),
              ),
          ],
        ),
      ),
    );
  }
}
