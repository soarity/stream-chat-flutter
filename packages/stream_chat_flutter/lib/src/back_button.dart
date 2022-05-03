import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Back button implementation
// ignore: prefer-match-file-name
class StreamBackButton extends StatelessWidget {
  /// Constructor for creating back button
  const StreamBackButton({
    Key? key,
    this.onPressed,
    this.showUnreads = false,
    this.cid,
  }) : super(key: key);

  /// Callback for when button is pressed
  final VoidCallback? onPressed;

  /// Show unread count
  final bool showUnreads;

  /// Channel cid used to retrieve unread count
  final String? cid;

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            elevation: 0,
            highlightElevation: 0,
            focusElevation: 0,
            hoverElevation: 0,
            onPressed: () {
              if (onPressed != null) {
                onPressed!();
              } else {
                Navigator.maybePop(context);
              }
            },
            padding: EdgeInsets.all(14.r),
            child: StreamSvgIcon.left(
              size: 24.r,
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
            ),
          ),
          if (showUnreads)
            Positioned(
              top: 7,
              right: 7,
              child: StreamUnreadIndicator(
                cid: cid,
              ),
            ),
        ],
      );
}
