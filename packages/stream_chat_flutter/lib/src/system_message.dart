import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro system_message}
@Deprecated("Use 'StreamSystemMessage' instead")
typedef SystemMessage = StreamSystemMessage;

/// {@template system_message}
/// It shows a widget for the message with a system message type.
/// {@endtemplate}
class StreamSystemMessage extends StatelessWidget {
  /// Constructor for creating a [StreamSystemMessage]
  const StreamSystemMessage({
    super.key,
    required this.message,
    this.onMessageTap,
  });

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
          onTap: onMessageTap == null ? null : () => onMessageTap!(message),
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
