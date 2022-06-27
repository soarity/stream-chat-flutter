import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';

/// {@macro deleted_message}
@Deprecated("Use 'StreamDeletedMessage' instead")
typedef DeletedMessage = StreamDeletedMessage;

/// {@template deleted_message}
/// Widget to display deleted message.
/// {@endtemplate}
class StreamDeletedMessage extends StatelessWidget {
  /// Constructor to create [StreamDeletedMessage]
  const StreamDeletedMessage({super.key, required this.messageTheme});

  /// The theme of the message
  final StreamMessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) => Text(
        context.translations.messageDeletedLabel,
        style: messageTheme.messageTextStyle?.copyWith(
          fontStyle: FontStyle.italic,
          color: messageTheme.createdAtStyle?.color,
        ),
      );
}
