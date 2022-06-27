// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/better_stream_builder.dart';
import 'package:stream_chat_flutter_core/src/channels_bloc.dart';
import 'package:stream_chat_flutter_core/src/stream_chat_core.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

/// [ChannelListCore] is a simplified class that allows fetching a list of
/// channels while exposing UI builders.
/// A [ChannelListController] is used to reload and paginate data.
///
///
/// ```dart
/// class ChannelListPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: ChannelListCore(
///         filter: Filter.in_(
///            'members',
///            [StreamChat.of(context).user!.id],
///         ),
///         sort: [SortOption('last_message_at')],
///         pagination: PaginationParams(
///           limit: 20,
///         ),
///         errorBuilder: (context, err) {
///           return Center(
///             child: Text('An error has occured'),
///           );
///         },
///         emptyBuilder: (context) {
///           return Center(
///             child: Text('Nothing here...'),
///           );
///         },
///         loadingBuilder: (context) {
///           return Center(
///             child: CircularProgressIndicator(),
///           );
///         },
///         listBuilder: (context, list) {
///           return ChannelPage(list);
///         }
///       ),
///     );
///   }
/// }
/// ```
///
/// Make sure to have a [StreamChatCore] ancestor in order to provide the
/// information about the channels.
@Deprecated('''
ChannelListCore is deprecated and will be removed in the next 
major version. Use StreamChannelListController instead to create your custom list.
More details here https://getstream.io/chat/docs/sdk/flutter/stream_chat_flutter_core/stream_channel_list_controller
''')
class ChannelListCore extends StatefulWidget {
  /// Instantiate a new ChannelListView
  const ChannelListCore({
    super.key,
    required this.errorBuilder,
    required this.emptyBuilder,
    required this.loadingBuilder,
    required this.listBuilder,
    this.filter,
    this.state = true,
    this.watch = true,
    this.presence = false,
    this.memberLimit,
    this.messageLimit,
    this.sort,
    this.channelListController,
    this.limit = 25,
  });

  /// A [ChannelListController] allows reloading and pagination.
  /// Use [ChannelListController.loadData] and
  /// [ChannelListController.paginateData] respectively for reloading and
  /// pagination.
  final ChannelListController? channelListController;

  /// The builder that will be used in case of error
  final ErrorBuilder errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder loadingBuilder;

  /// The builder which is used when list of channels loads
  final Function(BuildContext, List<Channel>) listBuilder;

  /// The builder used when the channel list is empty.
  final WidgetBuilder emptyBuilder;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Filter? filter;

  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options can be
  /// provided.
  /// You can sort based on last_updated, last_message_at, updated_at, created
  /// _at or member_count. Direction can be ascending or descending.
  final List<SortOption<ChannelModel>>? sort;

  /// If true returns the Channel state
  final bool state;

  /// If true listen to changes to this Channel in real time.
  final bool watch;

  /// If true you’ll receive user presence updates via the websocket events
  final bool presence;

  /// Number of members to fetch in each channel
  final int? memberLimit;

  /// Number of messages to fetch in each channel
  final int? messageLimit;

  /// The amount of channels requested per API call.
  final int limit;

  @override
  ChannelListCoreState createState() => ChannelListCoreState();
}

/// The current state of the [ChannelListCore].
class ChannelListCoreState extends State<ChannelListCore> {
  late ChannelsBlocState _channelsBloc;
  StreamChatCoreState? _streamChatCoreState;

  @override
  Widget build(BuildContext context) => _buildListView(_channelsBloc);

  BetterStreamBuilder<List<Channel>> _buildListView(
    ChannelsBlocState channelsBlocState,
  ) =>
      BetterStreamBuilder<List<Channel>>(
        stream: channelsBlocState.channelsStream,
        errorBuilder: widget.errorBuilder,
        noDataBuilder: widget.loadingBuilder,
        builder: (context, channels) {
          if (channels.isEmpty) {
            return widget.emptyBuilder(context);
          }
          return widget.listBuilder(context, channels);
        },
      );

  /// Fetches initial channels and updates the widget
  Future<void> loadData() => _channelsBloc.queryChannels(
        filter: widget.filter,
        sortOptions: widget.sort,
        state: widget.state,
        watch: widget.watch,
        presence: widget.presence,
        memberLimit: widget.memberLimit,
        messageLimit: widget.messageLimit,
        paginationParams: PaginationParams(limit: widget.limit, offset: 0),
      );

  /// Fetches more channels with updated pagination and updates the widget
  Future<void> paginateData() => _channelsBloc.queryChannels(
        filter: widget.filter,
        sortOptions: widget.sort,
        state: widget.state,
        watch: widget.watch,
        presence: widget.presence,
        memberLimit: widget.memberLimit,
        messageLimit: widget.messageLimit,
        paginationParams: PaginationParams(
          limit: widget.limit,
          offset: _channelsBloc.channels?.length ?? 0,
        ),
      );

  StreamSubscription<Event>? _subscription;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  void didChangeDependencies() {
    _channelsBloc = ChannelsBloc.of(context);
    final newStreamChatCoreState = StreamChatCore.of(context);

    if (newStreamChatCoreState != _streamChatCoreState) {
      _streamChatCoreState = newStreamChatCoreState;
      loadData();
      final client = _streamChatCoreState!.client;
      _subscription?.cancel();
      _subscription = client
          .on(
            EventType.connectionRecovered,
            EventType.notificationAddedToChannel,
            EventType.notificationMessageNew,
            EventType.channelVisible,
          )
          .listen((event) => loadData());
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ChannelListCore oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (jsonEncode(widget.filter) != jsonEncode(oldWidget.filter) ||
        jsonEncode(widget.sort) != jsonEncode(oldWidget.sort) ||
        widget.state != oldWidget.state ||
        widget.watch != oldWidget.watch ||
        widget.presence != oldWidget.presence ||
        widget.messageLimit != oldWidget.messageLimit ||
        widget.memberLimit != oldWidget.memberLimit ||
        widget.limit != oldWidget.limit) {
      loadData();
    }

    if (widget.channelListController != oldWidget.channelListController) {
      _setupController();
    }
  }

  void _setupController() {
    if (widget.channelListController != null) {
      widget.channelListController!.loadData = loadData;
      widget.channelListController!.paginateData = paginateData;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Controller used for loading more data and controlling pagination in
/// [ChannelListCore].
class ChannelListController {
  /// This function calls Stream's servers to load a list of channels.
  /// If there is existing data, calling this function causes a reload.
  AsyncCallback? loadData;

  /// This function is used to load another page of data. Note, [loadData]
  /// should be used to populate the initial page of data. Calling
  /// [paginateData] performs a query to load subsequent pages.
  AsyncCallback? paginateData;
}
