import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template editMessageSheet}
/// Allows a user to edit the selected message.
/// {@endtemplate}
class EditMessageSheet extends StatefulWidget {
  /// {@macro editMessageSheet}
  const EditMessageSheet({
    super.key,
    required this.message,
    required this.channel,
    this.editMessageInputBuilder,
  });

  /// {@macro editMessageInputBuilder}
  final EditMessageInputBuilder? editMessageInputBuilder;

  /// The message to edit.
  final Message message;

  /// The [StreamChannel] above this widget.
  final Channel channel;

  @override
  State<EditMessageSheet> createState() => _EditMessageSheetState();
}

class _EditMessageSheetState extends State<EditMessageSheet> {
  late final controller = StreamMessageInputController(
    message: widget.message,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamChatThemeData = StreamChatTheme.of(context);
    return KeyboardShortcutRunner(
      onEscapeKeypress: () => Navigator.of(context).pop(),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StreamChannel(
          channel: widget.channel,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: StreamSvgIcon.edit(
                        color: streamChatThemeData.colorTheme.disabled,
                      ),
                    ),
                    Text(
                      context.translations.editMessageLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: StreamSvgIcon.closeSmall(),
                      onPressed: Navigator.of(context).pop,
                    ),
                  ],
                ),
              ),
              if (widget.editMessageInputBuilder != null)
                widget.editMessageInputBuilder!(context, widget.message)
              else
                StreamMessageInput(
                  activeSendButton: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    padding: EdgeInsets.all(8.r),
                    decoration: ShapeDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: const CircleBorder(),
                    ),
                    child: ImageIcon(
                      const AssetImage('assets/icons/send.png'),
                      size: 24.r,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  idleSendButton: const Offstage(),
                  attachmentButtonBuilder: (context, button) {
                    return InkWell(
                      customBorder: const CircleBorder(),
                      onTap: button.onPressed,
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        child: ImageIcon(
                          const AssetImage('assets/icons/attachment.png'),
                          size: 24.r,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    );
                  },
                  messageInputController: controller,
                  preMessageSending: (m) {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                    return m;
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
