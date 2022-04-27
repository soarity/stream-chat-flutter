import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';

/// Widget to display deleted message
class DeletedMessage extends StatelessWidget {
  /// Constructor to create [DeletedMessage]
  const DeletedMessage({Key? key, required this.messageTheme})
      : super(key: key);

  /// The theme of the message
  final MessageThemeData messageTheme;

  @override
  Widget build(BuildContext context) => Text(
        context.translations.messageDeletedLabel,
        style: messageTheme.messageTextStyle?.copyWith(
          fontStyle: FontStyle.italic,
          color: messageTheme.createdAtStyle?.color,
        ),
      );
}
