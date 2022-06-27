// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/channel_list_core.dart';
import 'package:stream_chat_flutter_core/src/stream_chat_core.dart';
import 'package:stream_chat_flutter_core/src/stream_controller_extension.dart';

/// Widget dedicated to the management of a channel list with pagination
/// [ChannelsBloc] is used together with [ChannelListCore] to manage a list of
/// [Channel]s with pagination, re-ordering, querying and other operations
/// associated with [Channel]s.
///
/// [ChannelsBloc] can be access at anytime by using the static [of] method
/// using Flutter's [BuildContext].
///
/// API docs: https://getstream.io/chat/docs/flutter-dart/query_channels/
@Deprecated("Use 'StreamChannelListController' instead")
class ChannelsBloc extends StatefulWidget {
  /// Creates a new [ChannelsBloc]. The parameter [child] must be supplied and
  /// not null.
  const ChannelsBloc({
    super.key,
    required this.child,
    this.lockChannelsOrder = false,
    this.channelsComparator,
    this.shouldAddChannel,
  });

  /// The widget child
  final Widget child;

  /// Set this to true to prevent channels to be brought to the top of the list
  /// when a new message arrives
  final bool lockChannelsOrder;

  /// Comparator used to sort the channels when a message.new event is received
  final Comparator<Channel>? channelsComparator;

  /// Function used to evaluate if a channel should be added to the list when a
  /// message.new event is received
  final bool Function(Event)? shouldAddChannel;

  @override
  ChannelsBlocState createState() => ChannelsBlocState();

  /// Use this method to get the current [ChannelsBlocState] instance
  static ChannelsBlocState of(BuildContext context) {
    ChannelsBlocState? streamChatState;

    streamChatState = context.findAncestorStateOfType<ChannelsBlocState>();

    assert(
      streamChatState != null,
      'You must have a ChannelsBloc widget as ancestor',
    );

    return streamChatState!;
  }
}

/// The current state of the [ChannelsBloc].
class ChannelsBlocState extends State<ChannelsBloc>
    with AutomaticKeepAliveClientMixin {
  StreamChatCoreState? _streamChatCoreState;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  /// The current channel list
  List<Channel>? get channels => _channelsController.valueOrNull;

  /// The current channel list as a stream
  Stream<List<Channel>> get channelsStream => _channelsController.stream;

  final _queryChannelsLoadingController = BehaviorSubject.seeded(false);

  final BehaviorSubject<List<Channel>> _channelsController =
      BehaviorSubject<List<Channel>>();

  /// The stream notifying the state of queryChannel call
  Stream<bool> get queryChannelsLoading =>
      _queryChannelsLoadingController.stream;

  final List<Channel> _hiddenChannels = [];

  bool _paginationEnded = false;

  final List<StreamSubscription> _subscriptions = [];

  /// Calls [client.queryChannels] updating [queryChannelsLoading] stream
  Future<void> queryChannels({
    Filter? filter,
    List<SortOption<ChannelModel>>? sortOptions,
    bool state = true,
    bool watch = true,
    bool presence = false,
    int? memberLimit,
    int? messageLimit,
    bool waitForConnect = true,
    PaginationParams paginationParams = const PaginationParams(limit: 30),
  }) async {
    final client = _streamChatCoreState!.client;

    final offset = paginationParams.offset;
    final clear = offset == null || offset == 0;
    if (clear && _paginationEnded) {
      _paginationEnded = false;
    }

    if ((!clear && _paginationEnded) || _queryChannelsLoadingController.value) {
      return;
    }

    if (_channelsController.hasValue) {
      _queryChannelsLoadingController.safeAdd(true);
    }

    try {
      final oldChannels = List<Channel>.from(channels ?? []);
      var newChannels = <Channel>[];
      await for (final channels in client.queryChannels(
        filter: filter,
        sort: sortOptions,
        state: state,
        watch: watch,
        presence: presence,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        waitForConnect: waitForConnect,
        paginationParams: paginationParams,
      )) {
        newChannels = channels;
        if (clear) {
          _channelsController.safeAdd(channels);
        } else {
          final temp = oldChannels + channels;
          _channelsController.safeAdd(temp);
        }
        if (_channelsController.hasValue &&
            _queryChannelsLoadingController.value) {
          _queryChannelsLoadingController.safeAdd(false);
        }
      }
      if (newChannels.isEmpty || newChannels.length < paginationParams.limit) {
        _paginationEnded = true;
      }
    } catch (e, stk) {
      // reset loading controller
      _queryChannelsLoadingController.safeAdd(false);
      if (_channelsController.hasValue) {
        _queryChannelsLoadingController.safeAddError(e, stk);
      } else {
        _channelsController.safeAddError(e, stk);
      }
    }
  }

  @override
  void didChangeDependencies() {
    final newStreamChatCoreState = StreamChatCore.of(context);

    if (newStreamChatCoreState != _streamChatCoreState) {
      _streamChatCoreState = newStreamChatCoreState;
      final client = _streamChatCoreState!.client;

      _cancelSubscriptions();
      if (!widget.lockChannelsOrder) {
        _subscriptions.add(client
            .on(
          EventType.messageNew,
        )
            .listen((e) {
          if (e.message?.parentId != null && e.message?.showInChannel != true) {
            return;
          }
          final newChannels = List<Channel>.from(channels ?? []);
          final index = newChannels.indexWhere((c) => c.cid == e.cid);
          if (index != -1) {
            if (index > 0) {
              final channel = newChannels.removeAt(index);
              newChannels.insert(0, channel);
            }
          } else if (widget.shouldAddChannel?.call(e) == true) {
            final hiddenIndex =
                _hiddenChannels.indexWhere((c) => c.cid == e.cid);
            if (hiddenIndex != -1) {
              newChannels.insert(0, _hiddenChannels[hiddenIndex]);
              _hiddenChannels.removeAt(hiddenIndex);
            } else {
              if (client.state.channels[e.cid] != null) {
                newChannels.insert(0, client.state.channels[e.cid]!);
              }
            }
          }

          if (widget.channelsComparator != null) {
            newChannels.sort(widget.channelsComparator);
          }
          _channelsController.safeAdd(newChannels);
        }));
      }

      _subscriptions
        ..add(client.on(EventType.channelHidden).listen((event) async {
          final newChannels = List<Channel>.from(channels ?? []);
          final channelIndex =
              newChannels.indexWhere((c) => c.cid == event.cid);
          if (channelIndex > -1) {
            final channel = newChannels.removeAt(channelIndex);
            _hiddenChannels.add(channel);
            _channelsController.safeAdd(newChannels);
          }
        }))
        ..add(client
            .on(
          EventType.channelDeleted,
          EventType.notificationRemovedFromChannel,
        )
            .listen((e) {
          final channel = e.channel;
          _channelsController.safeAdd(List.from(
            (channels ?? [])..removeWhere((c) => c.cid == channel?.cid),
          ));
        }));
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _channelsController.close();
    _queryChannelsLoadingController.close();
    _cancelSubscriptions();
    super.dispose();
  }

  void _cancelSubscriptions() {
    _subscriptions
      ..forEach((s) => s.cancel())
      ..clear();
  }

  @override
  bool get wantKeepAlive => true;
}
