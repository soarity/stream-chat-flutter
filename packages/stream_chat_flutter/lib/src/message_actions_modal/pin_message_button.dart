import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template pinMessageButton}
/// Allows a user to pin or unpin a message.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
/// {@endtemplate}
class PinMessageButton extends StatelessWidget {
  /// {@macro pinMessageButton}
  const PinMessageButton({
    super.key,
    required this.onTap,
    required this.pinned,
  });

  /// The callback to perform when the button is tapped.
  final VoidCallback onTap;

  /// Whether the selected message is currently pinned or not.
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final streamChatThemeData = StreamChatTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
        child: Row(
          children: [
            StreamSvgIcon.pin(
              color: streamChatThemeData.primaryIconTheme.color,
              size: 24.r,
            ),
             SizedBox(width: 16.w),
            Text(
              context.translations.togglePinUnpinText(
                pinned: pinned,
              ),
              style: streamChatThemeData.textTheme.body,
            ),
          ],
        ),
      ),
    );
  }
}
