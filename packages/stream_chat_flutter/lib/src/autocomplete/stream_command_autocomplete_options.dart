import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template commands_overlay}
/// Overlay for displaying commands that can be used
/// to interact with the channel.
/// {@endtemplate}
class StreamCommandAutocompleteOptions extends StatelessWidget {
  /// Constructor for creating a [StreamCommandAutocompleteOptions]
  const StreamCommandAutocompleteOptions({
    required this.query,
    required this.channel,
    this.onCommandSelected,
    super.key,
  });

  /// Query for searching commands.
  final String query;

  /// The channel to search for users.
  final Channel channel;

  /// Callback called when a command is selected.
  final ValueSetter<Command>? onCommandSelected;

  @override
  Widget build(BuildContext context) {
    final commands = channel.config?.commands.where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedName = it.name.toUpperCase();
      return normalizedName.contains(normalizedQuery);
    });

    if (commands == null || commands.isEmpty) return const Empty();

    final streamChatTheme = StreamChatTheme.of(context);
    final colorTheme = streamChatTheme.colorTheme;
    final textTheme = streamChatTheme.textTheme;

    return StreamAutocompleteOptions<Command>(
      options: commands,
      headerBuilder: (context) {
        return ListTile(
          dense: true,
          horizontalTitleGap: 0,
          leading: StreamSvgIcon(
            icon: StreamSvgIcons.lightning,
            color: colorTheme.accentPrimary,
            size: 28,
          ),
          title: Text(
            context.translations.instantCommandsLabel,
            style: textTheme.body.copyWith(
              color: colorTheme.textLowEmphasis,
            ),
          ),
        );
      },
      optionBuilder: (context, command) {
        return ListTile(
          dense: true,
          horizontalTitleGap: 8,
          leading: _CommandIcon(command: command),
          title: Row(
            children: [
              Text(
                command.name.capitalize(),
                style: textTheme.bodyBold.copyWith(
                  color: colorTheme.textHighEmphasis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/${command.name} ${command.args}',
                style: textTheme.body.copyWith(
                  color: colorTheme.textLowEmphasis,
                ),
              ),
            ],
          ),
          onTap: onCommandSelected == null
              ? null
              : () => onCommandSelected!(command),
        );
      },
    );
  }
}

class _CommandIcon extends StatelessWidget {
  const _CommandIcon({required this.command});

  final Command command;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    switch (command.name) {
      case 'giphy':
        return const CircleAvatar(
          radius: 12,
          child: StreamSvgIcon(
            size: 24,
            icon: StreamSvgIcons.giphy,
          ),
        );
      case 'ban':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: const StreamSvgIcon(
            size: 16,
            color: Colors.white,
            icon: StreamSvgIcons.userRemove,
          ),
        );
      case 'flag':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: const StreamSvgIcon(
            size: 14,
            color: Colors.white,
            icon: StreamSvgIcons.flag,
          ),
        );
      case 'imgur':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: const ClipOval(
            child: StreamSvgIcon(
              size: 24,
              icon: StreamSvgIcons.imgur,
            ),
          ),
        );
      case 'mute':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: const StreamSvgIcon(
            size: 16,
            color: Colors.white,
            icon: StreamSvgIcons.mute,
          ),
        );
      case 'unban':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: const StreamSvgIcon(
            size: 16,
            color: Colors.white,
            icon: StreamSvgIcons.userAdd,
          ),
        );
      case 'unmute':
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: const StreamSvgIcon(
            size: 16,
            color: Colors.white,
            icon: StreamSvgIcons.volumeUp,
          ),
        );
      default:
        return CircleAvatar(
          backgroundColor: _streamChatTheme.colorTheme.accentPrimary,
          radius: 12,
          child: const StreamSvgIcon(
            size: 16,
            color: Colors.white,
            icon: StreamSvgIcons.lightning,
          ),
        );
    }
  }
}
