import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template editMessageButton}
/// Allows a user to edit a message.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
/// {@endtemplate}
class EditMessageButton extends StatelessWidget {
  /// {@macro editMessageButton}
  const EditMessageButton({
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
            StreamSvgIcon.edit(
               size: 24.r,
              color: streamChatThemeData.primaryIconTheme.color,
            ),
             SizedBox(width: 16.w),
            Text(
              context.translations.editMessageLabel,
              style: streamChatThemeData.textTheme.body,
            ),
          ],
        ),
      ),
    );
  }
}
