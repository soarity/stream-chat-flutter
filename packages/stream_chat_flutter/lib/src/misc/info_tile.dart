import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
<<<<<<< HEAD:packages/stream_chat_flutter/lib/src/info_tile.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
=======
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0:packages/stream_chat_flutter/lib/src/misc/info_tile.dart

/// {@template streamInfoTile}
/// Displays a message. Often used to display connection status.
/// {@endtemplate}
class StreamInfoTile extends StatelessWidget {
  /// {@macro streamInfoTile}
  const StreamInfoTile({
    super.key,
    required this.message,
    required this.child,
    required this.showMessage,
    this.tileAnchor,
    this.childAnchor,
    this.textStyle,
    this.backgroundColor,
  });

  /// String to display
  final String message;

  /// Widget to display over
  final Widget child;

  /// Flag to show message
  final bool showMessage;

  /// Anchor for tile - [portalAnchor] for [PortalEntry]
  final Alignment? tileAnchor;

  /// Alignment for child - [childAnchor] for [PortalEntry]
  final Alignment? childAnchor;

  /// [TextStyle] for message
  final TextStyle? textStyle;

  /// Background color for tile
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return PortalTarget(
      visible: showMessage,
      anchor: Aligned(
        follower: tileAnchor ?? Alignment.topCenter,
        target: childAnchor ?? Alignment.bottomCenter,
      ),
      portalFollower: Container(
        height: 25.h,
        color: backgroundColor ??
            chatThemeData.colorTheme.textLowEmphasis.withOpacity(0.9),
        child: Center(
          child: Text(
            message,
            style: textStyle ??
                chatThemeData.textTheme.body.copyWith(
                  color: Colors.white,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      child: child,
    );
  }
}
