import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template deleteMessageButton}
/// A button that allows a user to delete the selected message.
///
/// Used by [MessageActionsModal]. Should not be used by itself.
/// {@endtemplate}
class DeleteMessageButton extends StatelessWidget {
  /// {@macro deleteMessageButton}
  const DeleteMessageButton({
    super.key,
    required this.isDeleteFailed,
    required this.onTap,
  });

  /// Indicates whether the deletion has failed or not.
  final bool isDeleteFailed;

  /// The action (deleting the message) to be performed on tap.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
        child: Row(
          children: [
            StreamSvgIcon.delete(
               size: 24.r,
              color: Colors.red,
            ),
             SizedBox(width: 16.w),
            Text(
              context.translations.toggleDeleteRetryDeleteMessageText(
                isDeleteFailed: isDeleteFailed,
              ),
              style: StreamChatTheme.of(context)
                  .textTheme
                  .body
                  .copyWith(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
