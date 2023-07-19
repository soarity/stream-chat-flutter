import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template username}
/// Displays the username of a particular message's sender.
/// {@endtemplate}
class Username extends StatelessWidget {
  /// {@macro username}
  const Username({
    super.key,
    required this.message,
    required this.messageTheme,
  });

  /// {@macro message}
  final Message message;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) {
    final color = message.user?.extraData['color'];
    return Text(
      message.user?.name ?? '',
      maxLines: 1,
      key: key,
      style: TextStyle(
        fontSize: 14.fzs,
        fontWeight: FontWeight.w500,
        height: 1,
        color: color == null
            ? Theme.of(context).colorScheme.secondary
            : Color(int.parse('0x$color')),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
