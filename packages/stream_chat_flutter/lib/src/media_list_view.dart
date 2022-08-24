import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/src/media_list_view_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro media_list_view}
@Deprecated("Use 'StreamMediaListView' instead")
typedef MediaListView = StreamMediaListView;

/// {@template media_list_view}
/// Constructs a list of media
/// {@endtemplate}
class StreamMediaListView extends StatefulWidget {
  /// Constructor for creating a [StreamMediaListView] widget
  const StreamMediaListView({
    super.key,
    this.selectedIds = const [],
    this.onSelect,
    this.controller,
    this.thumbnailSize = const ThumbnailSize(400, 400),
    this.thumbnailFormat = ThumbnailFormat.jpeg,
    this.thumbnailQuality = 100,
    this.thumbnailScale = 1,
  });

  /// Stores the media selected
  final List<String> selectedIds;

  /// Callback for on media selected
  final void Function(AssetEntity media)? onSelect;

  /// Controller that handles MediaListView
  final MediaListViewController? controller;

  /// The thumbnail size.
  final ThumbnailSize thumbnailSize;

  /// {@macro photo_manager.ThumbnailFormat}
  final ThumbnailFormat thumbnailFormat;

  /// The quality value for the thumbnail.
  ///
  /// Valid from 1 to 100.
  /// Defaults to 100.
  final int thumbnailQuality;

  /// Scale of the image.
  final double thumbnailScale;

  @override
  _StreamMediaListViewState createState() => _StreamMediaListViewState();
}

class _StreamMediaListViewState extends State<StreamMediaListView> {
  var _media = <AssetEntity>[];
  var _currentPage = 0;
  final _scrollController = ScrollController();

  /// Controller necessary to verify limited access to photo gallery in iOS and
  /// update the media list when listerners are emitted
  late final controller = widget.controller ?? MediaListViewController();

  @override
  Widget build(BuildContext context) => LazyLoadScrollView(
        onEndOfPage: () async => _getMedia(),
        child: GridView.builder(
          itemCount: _media.length,
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (
            context,
            position,
          ) {
            final media = _media.elementAt(position);
            final chatThemeData = StreamChatTheme.of(context);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: InkWell(
                onTap: widget.onSelect == null
                    ? null
                    : () => widget.onSelect!(media),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: FadeInImage(
                        image: MediaThumbnailProvider(
                          media: media,
                          size: widget.thumbnailSize,
                          format: widget.thumbnailFormat,
                          quality: widget.thumbnailQuality,
                          scale: widget.thumbnailScale,
                        ),
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholder: const AssetImage(
                          'images/placeholder.png',
                          package: 'stream_chat_flutter',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity:
                              widget.selectedIds.any((id) => id == media.id)
                                  ? 1.0
                                  : 0.0,
                          child: Container(
                            color: chatThemeData.colorTheme.textHighEmphasis
                                .withOpacity(0.5),
                            alignment: Alignment.topRight,
                            padding: const EdgeInsets.only(
                              top: 8,
                              right: 8,
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: chatThemeData.colorTheme.barsBg,
                              child: StreamSvgIcon.check(
                                size: 24,
                                color:
                                    chatThemeData.colorTheme.textHighEmphasis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (media.type == AssetType.video) ...[
                      Positioned(
                        left: 8,
                        bottom: 10,
                        child: SvgPicture.asset(
                          'svgs/video_call_icon.svg',
                          package: 'stream_chat_flutter',
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 10,
                        child: Text(
                          media.videoDuration.format(),
                          style: TextStyle(
                            color: chatThemeData.colorTheme.barsBg,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );

  @override
  void initState() {
    super.initState();
    controller.addListener(_updateMediaList);
    _getMedia();
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_updateMediaList);
    if (widget.controller == null) {
      controller.dispose();
    }
  }

  void _updateMediaList() {
    if (controller.shouldUpdateMedia) {
      _currentPage = 0;
      _getMedia(shouldRefreshMediaList: true);
    }
  }

  Future<void> _getMedia({bool shouldRefreshMediaList = false}) async {
    final assetList = (await PhotoManager.getAssetPathList(
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(
            // ignore: avoid_redundant_argument_values
            type: OrderOptionType.createDate,
          ),
        ],
      ),
      onlyAll: true,
    ))
        .firstOrNull;

    final media = await assetList?.getAssetListPaged(
      page: _currentPage,
      size: 50,
    );
    if (media?.isNotEmpty == true) {
      if (shouldRefreshMediaList) {
        setState(() {
          _media = media!;
        });
        _currentPage = 1;
      } else {
        setState(() {
          _media.addAll(media!);
        });
        ++_currentPage;
      }
    }
  }
}

/// ImageProvider implementation for [AssetEntity].
class MediaThumbnailProvider extends ImageProvider<MediaThumbnailProvider> {
  /// Constructor for creating a [MediaThumbnailProvider]
  const MediaThumbnailProvider({
    required this.media,
    // TODO: Are these sizes optimal? Consider web/desktop
    this.size = const ThumbnailSize(400, 400),
    this.format = ThumbnailFormat.jpeg,
    this.quality = 100,
    this.scale = 2,
  });

  /// Media to get the thumbnail from.
  final AssetEntity media;

  /// The thumbnail size.
  final ThumbnailSize size;

  /// {@macro photo_manager.ThumbnailFormat}
  final ThumbnailFormat format;

  /// The quality value for the thumbnail.
  ///
  /// Valid from 1 to 100.
  /// Defaults to 100.
  final int quality;

  /// Scale of the image.
  final double scale;

  @override
  Future<MediaThumbnailProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<MediaThumbnailProvider>(this);
  }

  @override
  ImageStreamCompleter load(
    MediaThumbnailProvider key,
    DecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      informationCollector: () sync* {
        yield DiagnosticsProperty<ImageProvider>(
          'Thumbnail provider: $this \n Thumbnail key: $key',
          this,
          style: DiagnosticsTreeStyle.errorProperty,
        );
      },
    );
  }

  Future<ui.Codec> _loadAsync(
    MediaThumbnailProvider key,
    DecoderCallback decode,
  ) async {
    assert(key == this, '$key is not $this');
    final bytes = await media.thumbnailDataWithSize(
      size,
      format: format,
      quality: quality,
    );
    return decode(bytes!);
  }

  @override
  bool operator ==(dynamic other) {
    if (other is MediaThumbnailProvider) {
      return media == other.media &&
          size == other.size &&
          format == other.format &&
          quality == other.quality &&
          scale == other.scale;
    }
    return false;
  }

  @override
  int get hashCode => hashValues(media, size, format, quality, scale);

  @override
  String toString() => '$runtimeType('
      'media: $media, '
      'size: $size, '
      'format: $format, '
      'quality: $quality, '
      'scale: $scale'
      ')';
}

extension on Duration {
  String format() {
    final s = '$this'.split('.')[0].padLeft(8, '0');
    if (s.startsWith('00:')) {
      return s.replaceFirst('00:', '');
    }
    return s;
  }
}
