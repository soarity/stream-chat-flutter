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

  /// Count of time remaining to show to the user.
  final int count;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(8.r),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: StreamChatTheme.of(context).colorTheme.disabled,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            height: 24.r,
            width: 24.r,
            child: Center(
              child: Text('$count'),
            ),
          ),
        ),
      );
}
