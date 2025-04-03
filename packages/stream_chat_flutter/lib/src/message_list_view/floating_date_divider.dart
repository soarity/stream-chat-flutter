import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/mlv_utils.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template floatingDateDivider}
/// Not intended for use outside of [MessageListView].
/// {@endtemplate}
class FloatingDateDivider extends StatelessWidget {
  /// {@macro floatingDateDivider}
  const FloatingDateDivider({
    super.key,
    required this.itemPositionListener,
    required this.reverse,
    required this.messages,
    required this.itemCount,
    this.dateDividerBuilder,
  });

  // ignore: public_member_api_docs
  final ValueListenable<Iterable<ItemPosition>> itemPositionListener;

  // ignore: public_member_api_docs
  final bool reverse;

  // ignore: public_member_api_docs
  final List<Message> messages;

  // ignore: public_member_api_docs
  final int itemCount;

  // ignore: public_member_api_docs
  final Widget Function(DateTime)? dateDividerBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: itemPositionListener,
      builder: (context, positions, child) {
        if (positions.isEmpty || messages.isEmpty) {
          return const Empty();
        }

        var index = switch (reverse) {
          true => getBottomElementIndex(positions),
          false => getTopElementIndex(positions),
        };

<<<<<<< HEAD
        if (index == null) {
          return const Offstage();
=======
        if ((index == null) ||
            (!isThreadConversation && index == itemCount - 2) ||
            (isThreadConversation && index == itemCount - 1)) {
          return const Empty();
>>>>>>> 78604c60fb775e9251282984293587b8888c7a46
        }

        if (index <= 2 || index >= itemCount - 3) {
          if (reverse) {
            index = itemCount - 4;
          } else {
            index = 2;
          }
        }

        final message = messages[index - 2];
        return dateDividerBuilder?.call(message.createdAt.toLocal()) ??
            StreamDateDivider(dateTime: message.createdAt.toLocal());
      },
    );
  }
}
