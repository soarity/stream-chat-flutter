import 'package:flutter/material.dart';
<<<<<<< HEAD:packages/stream_chat_flutter/lib/src/deleted_message.dart
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';
=======
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0:packages/stream_chat_flutter/lib/src/message_widget/deleted_message.dart

/// {@template streamDeletedMessage}
/// Displays that a message was deleted at this position in the message list.
/// {@endtemplate}
class StreamDeletedMessage extends StatelessWidget {
<<<<<<< HEAD:packages/stream_chat_flutter/lib/src/deleted_message.dart
  /// Constructor to create [StreamDeletedMessage]
  const StreamDeletedMessage({super.key, required this.messageTheme});
=======
  /// {@macro streamDeletedMessage}
  const StreamDeletedMessage({
    super.key,
    required this.messageTheme,
    this.borderRadiusGeometry,
    this.shape,
    this.borderSide,
    this.reverse = false,
  });
>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0:packages/stream_chat_flutter/lib/src/message_widget/deleted_message.dart

  /// The theme of the message
  final StreamMessageThemeData messageTheme;

<<<<<<< HEAD:packages/stream_chat_flutter/lib/src/deleted_message.dart
=======
  /// The border radius of the message text
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// The shape of the message text
  final ShapeBorder? shape;

  /// The [BorderSide] of the message text
  final BorderSide? borderSide;

  /// If true the widget will be mirrored
  final bool reverse;

>>>>>>> 5669841a3268d0bd71a4011b95456492b4562bf0:packages/stream_chat_flutter/lib/src/message_widget/deleted_message.dart
  @override
  Widget build(BuildContext context) => Text(
        context.translations.messageDeletedLabel,
        style: messageTheme.messageTextStyle?.copyWith(
          fontStyle: FontStyle.italic,
          color: messageTheme.createdAtStyle?.color,
        ),
      );
}
