import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template pinnedMessage}
/// A pinned message in a chat.
///
/// Used in [MessageWidgetContent]. Should not be used elsewhere.
/// {@endtemplate}
class PinnedMessage extends StatelessWidget {
  /// {@macro pinnedMessage}
  const PinnedMessage({
    super.key,
    required this.pinnedBy,
    required this.currentUser,
  });

  /// The [User] who pinned this message.
  final User pinnedBy;

  /// The current [User].
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 4.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamSvgIcon.pin(size: 18.r),
          SizedBox(width: 4.w),
          Text(
            context.translations.pinnedByUserText(
              pinnedBy: pinnedBy,
              currentUser: currentUser,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
                ),
          ),
        ],
      ),
    );
  }
}
