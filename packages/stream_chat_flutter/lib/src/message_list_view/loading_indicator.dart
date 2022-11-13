import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/src/progress_indicator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template loadingIndicatorMLV}
/// A loading indicator for [MessageListView]. Not intended for use outside of
/// [MessageListView].
/// {@endtemplate}
class LoadingIndicator extends StatelessWidget {
  /// {@macro loadingIndicatorMLV}
  const LoadingIndicator({
    super.key,
    required this.streamTheme,
    required this.direction,
    required this.streamChannelState,
    this.indicatorBuilder,
  });

  // ignore: public_member_api_docs
  final StreamChatThemeData streamTheme;

  // ignore: public_member_api_docs
  final QueryDirection direction;

  // ignore: public_member_api_docs
  final StreamChannelState streamChannelState;

  // ignore: public_member_api_docs
  final WidgetBuilder? indicatorBuilder;

  @override
  Widget build(BuildContext context) {
    final stream = direction == QueryDirection.top
        ? streamChannelState.queryTopMessages
        : streamChannelState.queryBottomMessages;
    return BetterStreamBuilder<bool>(
      key: Key('LOADING-INDICATOR $direction'),
      stream: stream,
      initialData: false,
      errorBuilder: (context, error) => ColoredBox(
        color: streamTheme.colorTheme.accentError.withOpacity(0.2),
        child: Center(
          child: Text(context.translations.loadingMessagesError),
        ),
      ),
      builder: (context, data) {
        if (!data) return const Offstage();
        return indicatorBuilder?.call(context) ??
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: CustomProgressIndicator(size: 20.r),
              ),
            );
      },
    );
  }
}
