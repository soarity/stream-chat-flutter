import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template copyMessageButton}
/// Allows a user to copy the text of a message.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
/// {@endtemplate}
class CopyMessageButton extends StatelessWidget {
  /// {@macro copyMessageButton}
  const CopyMessageButton({
    super.key,
    required this.onTap,
  });

  /// The callback to perform when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final streamChatThemeData = StreamChatTheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
        child: Row(
          children: [
            StreamSvgIcon.copy(
              size: 24.r,
              color: streamChatThemeData.primaryIconTheme.color,
            ),
             SizedBox(width: 16.w),
            Text(
              context.translations.copyMessageLabel,
              style: streamChatThemeData.textTheme.body,
            ),
          ],
        ),
      ),
    );
  }
}
