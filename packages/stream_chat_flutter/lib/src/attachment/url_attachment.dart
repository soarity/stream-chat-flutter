import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamUrlAttachment}
/// Displays a URL attachment in a [StreamMessageWidget].
/// {@endtemplate}
class StreamUrlAttachment extends StatelessWidget {
  /// {@macro streamUrlAttachment}
  const StreamUrlAttachment({
    super.key,
    required this.urlAttachment,
    required this.hostDisplayName,
    required this.messageTheme,
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    this.onLinkTap,
  });

  /// Attachment to be displayed
  final Attachment urlAttachment;

  /// Host name
  final String hostDisplayName;

  /// Padding for text
  final EdgeInsets textPadding;

  /// The [StreamMessageThemeData] to use for the image title
  final StreamMessageThemeData messageTheme;

  /// The function called when tapping on a link
  final void Function(String)? onLinkTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
        minWidth: 400,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            final ogScrapeUrl = urlAttachment.ogScrapeUrl;
            if (ogScrapeUrl != null) {
              onLinkTap != null
                  ? onLinkTap!(ogScrapeUrl)
                  : launchURL(context, ogScrapeUrl);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (urlAttachment.imageUrl != null)
                Container(
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      AspectRatio(
                        // Default aspect ratio for Open Graph images.
                        // https://www.kapwing.com/resources/what-is-an-og-image-make-and-format-og-images-for-your-blog-or-webpage
                        aspectRatio: 1.91 / 1,
                        child: CachedNetworkImage(
                          imageUrl: urlAttachment.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, __) {
                            final image = Image.asset(
                              'images/placeholder.png',
                              fit: BoxFit.cover,
                              package: 'stream_chat_flutter',
                            );
                            final colorTheme =
                                StreamChatTheme.of(context).colorTheme;
                            return Shimmer.fromColors(
                              baseColor: colorTheme.disabled,
                              highlightColor: colorTheme.inputBg,
                              child: image,
                            );
                          },
                          errorWidget: (_, __, ___) => const AttachmentError(),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(16),
                            ),
                            color: messageTheme.urlAttachmentBackgroundColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              right: 12,
                              bottom: 4,
                            ),
                            child: Text(
                              hostDisplayName,
                              style: messageTheme.urlAttachmentHostStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: textPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (urlAttachment.title != null)
                      Builder(builder: (context) {
                        final maxLines = messageTheme.urlAttachmentTitleMaxLine;

                        TextOverflow? overflow;
                        if (maxLines != null && maxLines > 0) {
                          overflow = TextOverflow.ellipsis;
                        }

                        return Text(
                          urlAttachment.title!.trim(),
                          maxLines: maxLines,
                          overflow: overflow,
                          style: messageTheme.urlAttachmentTitleStyle,
                        );
                      }),
                    if (urlAttachment.text != null)
                      Builder(builder: (context) {
                        final maxLines = messageTheme.urlAttachmentTextMaxLine;

                        TextOverflow? overflow;
                        if (maxLines != null && maxLines > 0) {
                          overflow = TextOverflow.ellipsis;
                        }

                        return Text(
                          urlAttachment.text!,
                          maxLines: maxLines,
                          overflow: overflow,
                          style: messageTheme.urlAttachmentTextStyle,
                        );
                      }),
                  ].insertBetween(const SizedBox(height: 4)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
