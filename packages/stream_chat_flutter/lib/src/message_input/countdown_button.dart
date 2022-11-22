import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Button for showing visual component of slow mode.
class StreamCountdownButton extends StatelessWidget {
  /// Constructor for creating [StreamCountdownButton].
  const StreamCountdownButton({
    super.key,
    required this.count,
  });

  /// The amount of time remaining until the user can send a message again.
  /// Measured in seconds.
  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: StreamChatTheme.of(context).colorTheme.disabled,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        height: 26.r,
        width: 26.r,
        child: Center(
          child: Text('$count'),
        ),
      ),
    );
  }
}
