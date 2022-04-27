import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// It shows a date divider depending on the date difference
class SystemMessage extends StatelessWidget {
  /// Constructor for creating a [SystemMessage]
  const SystemMessage({
    Key? key,
    required this.message,
    this.onMessageTap,
  }) : super(key: key);

  /// This message
  final Message message;

  /// The function called when tapping on the message
  /// when the message is not failed
  final void Function(Message)? onMessageTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: SizedBox(
        width: 240.w,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (onMessageTap != null) {
              onMessageTap!(message);
            }
          },
          child: Center(
            child: Material(
              shape: const StadiumBorder(),
              elevation: 1,
              color: theme.colorTheme.overlay,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                child: Text(
                  message.text!,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: theme.textTheme.footnote.copyWith(
                    color: theme.colorTheme.barsBg,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
