import 'dart:async';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_button.dart';
import 'package:stream_chat_flutter/src/message_input/command_button.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox.dart';
import 'package:stream_chat_flutter/src/message_input/quoted_message_widget.dart';
import 'package:stream_chat_flutter/src/message_input/quoting_message_top_area.dart';
import 'package:stream_chat_flutter/src/message_input/simple_safe_area.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';
import 'package:stream_chat_flutter/src/message_input/tld.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

const _kCommandTrigger = '/';
const _kMentionTrigger = '@';

/// Signature for the function that determines if a [matchedUri] should be
/// previewed as an OG Attachment.
typedef OgPreviewFilter = bool Function(
  Uri matchedUri,
  String messageText,
);

/// Different types of hints that can be shown in [StreamMessageInput].
enum HintType {
  /// Hint for [StreamMessageInput] when the command is enabled and the command
  /// is 'giphy'.
  searchGif,

  /// Hint for [StreamMessageInput] when there are attachments.
  addACommentOrSend,

  /// Hint for [StreamMessageInput] when slow mode is enabled.
  slowModeOn,

  /// Hint for [StreamMessageInput] when other conditions are not met.
  writeAMessage,
}

/// Function that returns the hint text for [StreamMessageInput] based on
/// [type].
typedef HintGetter = String? Function(BuildContext context, HintType type);

/// The signature for the function that builds the list of actions.
typedef ActionsBuilder = List<Widget> Function(
  BuildContext context,
  List<Widget> defaultActions,
);

/// Inactive state:
///
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input_paint.png)
///
/// Focused state:
///
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input2.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_input2_paint.png)
///
/// Widget used to enter a message and add attachments:
///
/// ```dart
/// class ChannelPage extends StatelessWidget {
///   const ChannelPage({
///     Key? key,
///   }) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) => Scaffold(
///         appBar: const StreamChannelHeader(),
///         body: Column(
///           children: <Widget>[
///             Expanded(
///               child: StreamMessageListView(
///                 threadBuilder: (_, parentMessage) => ThreadPage(
///                   parent: parentMessage,
///                 ),
///               ),
///             ),
///             const StreamMessageInput(),
///           ],
///         ),
///       );
/// }
/// ```
///
/// You usually put this widget in the same page of a [StreamMessageListView]
/// as the bottom widget.
///
/// The widget renders the ui based on the first ancestor of
/// type [StreamChatTheme]. Modify it to change the widget appearance.
class StreamMessageInput extends StatefulWidget {
  /// Instantiate a new MessageInput
  const StreamMessageInput({
    super.key,
    this.onMessageSent,
    this.preMessageSending,
    this.maxHeight = 150,
    this.maxLines,
    this.minLines,
    this.textInputAction,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
    this.disableAttachments = false,
    this.messageInputController,
    this.actionsBuilder,
    this.spaceBetweenActions = 0,
    this.actionsLocation = ActionsLocation.left,
    this.attachmentListBuilder,
    this.fileAttachmentListBuilder,
    this.mediaAttachmentListBuilder,
    this.voiceRecordingAttachmentListBuilder,
    this.fileAttachmentBuilder,
    this.mediaAttachmentBuilder,
    this.voiceRecordingAttachmentBuilder,
    this.focusNode,
    this.sendButtonLocation = SendButtonLocation.outside,
    this.autofocus = false,
    this.hideSendAsDm = false,
    this.enableVoiceRecording = false,
    this.sendVoiceRecordingAutomatically = false,
    this.idleSendButton,
    this.emojiSendButton,
    this.activeSendButton,
    this.showCommandsButton = true,
    this.userMentionsTileBuilder,
    this.isDm = false,
    this.maxAttachmentSize = kDefaultMaxAttachmentSize,
    this.onError,
    this.attachmentLimit = 10,
    this.allowedAttachmentPickerTypes = AttachmentPickerType.values,
    this.onAttachmentLimitExceed,
    this.attachmentButtonBuilder,
    this.commandButtonBuilder,
    this.customAutocompleteTriggers = const [],
    this.mentionAllAppUsers = false,
    this.sendButtonBuilder,
    this.quotedMessageBuilder,
    this.quotedMessageAttachmentThumbnailBuilders,
    this.shouldKeepFocusAfterMessage,
    this.validator = _defaultValidator,
    this.restorationId,
    this.enableSafeArea,
    this.elevation,
    this.shadow,
    this.autoCorrect = true,
    this.enableMentionsOverlay = true,
    this.onQuotedMessageCleared,
    this.enableActionAnimation = true,
    this.sendMessageKeyPredicate = _defaultSendMessageKeyPredicate,
    this.clearQuotedMessageKeyPredicate =
        _defaultClearQuotedMessageKeyPredicate,
    this.ogPreviewFilter = _defaultOgPreviewFilter,
    this.hintGetter = _defaultHintGetter,
    this.contentInsertionConfiguration,
    bool useSystemAttachmentPicker = false,
    @Deprecated(
      'Use useSystemAttachmentPicker instead. '
      'This feature was deprecated after v9.4.0',
    )
    bool useNativeAttachmentPickerOnMobile = false,
    this.pollConfig,
  }) : useSystemAttachmentPicker = useSystemAttachmentPicker || //
            useNativeAttachmentPickerOnMobile;

  /// The predicate used to send a message on desktop/web
  final KeyEventPredicate sendMessageKeyPredicate;

  /// The predicate used to clear the quoted message on desktop/web
  final KeyEventPredicate clearQuotedMessageKeyPredicate;

  /// If true the message input will animate the actions while you type
  final bool enableActionAnimation;

  /// List of triggers for showing autocomplete.
  final Iterable<StreamAutocompleteTrigger> customAutocompleteTriggers;

  /// Max attachment size in bytes:
  /// - Defaults to 20 MB
  /// - Do not set it if you're using our default CDN
  final int maxAttachmentSize;

  ///
  final bool isDm;

  /// Function called after sending the message.
  final void Function(Message)? onMessageSent;

  /// Function called right before sending the message.
  ///
  /// Use this to transform the message.
  final FutureOr<Message> Function(Message)? preMessageSending;

  /// Maximum Height for the TextField to grow before it starts scrolling.
  final double maxHeight;

  /// The maximum lines of text the input can span.
  final int? maxLines;

  /// The minimum lines of text the input can span.
  final int? minLines;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// The keyboard type assigned to the TextField.
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// If true the attachments button will not be displayed.
  final bool disableAttachments;

  /// Use this property to hide/show the commands button.
  final bool showCommandsButton;

  /// Hide send as dm checkbox.
  final bool hideSendAsDm;

  /// If true the voice recording button will be displayed.
  ///
  /// Defaults to true.
  final bool enableVoiceRecording;

  /// If True, the voice recording will be sent automatically after the user
  /// releases the microphone button.
  ///
  /// Defaults to false.
  final bool sendVoiceRecordingAutomatically;

  /// The text controller of the TextField.
  final StreamMessageInputController? messageInputController;

  /// List of action widgets.
  final ActionsBuilder? actionsBuilder;

  /// Space between the actions.
  final double spaceBetweenActions;

  /// The location of the custom actions.
  final ActionsLocation actionsLocation;

  /// Builder used to build the attachment list present in the message input.
  ///
  /// In case you want to customize only sub-parts of the attachment list,
  /// consider using [fileAttachmentListBuilder], [mediaAttachmentListBuilder].
  final AttachmentListBuilder? attachmentListBuilder;

  /// Builder used to build the file type attachment list.
  ///
  /// In case you want to customize the attachment item, consider using
  /// [fileAttachmentBuilder].
  final AttachmentListBuilder? fileAttachmentListBuilder;

  /// Builder used to build the media type attachment list.
  ///
  /// In case you want to customize the attachment item, consider using
  /// [mediaAttachmentBuilder].
  final AttachmentListBuilder? mediaAttachmentListBuilder;

  /// Builder used to build the voice recording attachment list.
  ///
  /// In case you want to customize the attachment item, consider using
  /// [voiceRecordingAttachmentBuilder].
  final AttachmentListBuilder? voiceRecordingAttachmentListBuilder;

  /// Builder used to build the file attachment item.
  final AttachmentItemBuilder? fileAttachmentBuilder;

  /// Builder used to build the media attachment item.
  final AttachmentItemBuilder? mediaAttachmentBuilder;

  /// Builder used to build the voice recording attachment item.
  final AttachmentItemBuilder? voiceRecordingAttachmentBuilder;

  /// Map that defines a thumbnail builder for an attachment type.
  ///
  /// This is used to build the thumbnail for the attachment in the quoted
  /// message.
  final Map<String, QuotedMessageAttachmentThumbnailBuilder>?
      quotedMessageAttachmentThumbnailBuilders;

  /// The focus node associated to the TextField.
  final FocusNode? focusNode;

  /// The location of the send button
  final SendButtonLocation sendButtonLocation;

  /// Autofocus property passed to the TextField
  final bool autofocus;

  /// Send button widget in an idle state
  final Widget? idleSendButton;

  /// Send button widget in an active state
  final Widget? activeSendButton;

  /// Emoji Send button widget in an active state
  final Widget? emojiSendButton;

  /// Customize the tile for the mentions overlay.
  final UserMentionTileBuilder? userMentionsTileBuilder;

  /// A callback for error reporting
  final ErrorListener? onError;

  /// A limit for the no. of attachments that can be sent with a single message.
  final int attachmentLimit;

  /// The list of allowed attachment types which can be picked using the
  /// attachment button.
  ///
  /// By default, all the attachment types are allowed.
  final List<AttachmentPickerType> allowedAttachmentPickerTypes;

  /// A callback for when the [attachmentLimit] is exceeded.
  ///
  /// This will override the default error alert behaviour.
  final AttachmentLimitExceedListener? onAttachmentLimitExceed;

  /// Builder for customizing the attachment button.
  ///
  /// The builder contains the default [AttachmentButton] that can be customized
  /// by calling `.copyWith`.
  final AttachmentButtonBuilder? attachmentButtonBuilder;

  /// Builder for customizing the command button.
  ///
  /// The builder contains the default [CommandButton] that can be customized by
  /// calling `.copyWith`.
  final CommandButtonBuilder? commandButtonBuilder;

  /// When enabled mentions search users across the entire app.
  ///
  /// Defaults to false.
  final bool mentionAllAppUsers;

  /// Builder for creating send button
  final MessageRelatedBuilder? sendButtonBuilder;

  /// Builder for building quoted message
  final Widget Function(BuildContext, Message)? quotedMessageBuilder;

  /// Defines if the [StreamMessageInput] loses focuses after a message is sent.
  /// The default behaviour keeps focus until a command is enabled.
  final bool? shouldKeepFocusAfterMessage;

  /// A callback function that validates the message.
  final MessageValidator validator;

  /// Restoration ID to save and restore the state of the MessageInput.
  final String? restorationId;

  /// Wrap [StreamMessageInput] with a [SafeArea widget]
  final bool? enableSafeArea;

  /// Elevation of the [StreamMessageInput]
  final double? elevation;

  /// Shadow for the [StreamMessageInput] widget
  final BoxShadow? shadow;

  /// Disable autoCorrect by passing false
  /// autoCorrect is enabled by default
  final bool autoCorrect;

  /// Disable the mentions overlay by passing false
  /// Enabled by default
  final bool enableMentionsOverlay;

  /// Callback for when the quoted message is cleared
  final VoidCallback? onQuotedMessageCleared;

  /// The filter used to determine if a link should be shown as an OpenGraph
  /// preview.
  final OgPreviewFilter ogPreviewFilter;

  /// Returns the hint text for the message input.
  final HintGetter hintGetter;

  /// {@macro flutter.widgets.editableText.contentInsertionConfiguration}
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// If True, allows you to use the system’s default media picker instead of
  /// the custom media picker provided by the library. This can be beneficial
  /// for several reasons:
  ///
  /// 1. Consistency: Provides a consistent user experience by using the
  /// familiar system media picker.
  /// 2. Permissions: Reduces the need for additional permissions, as the system
  /// media picker handles permissions internally.
  /// 3. Simplicity: Simplifies the implementation by leveraging the built-in
  /// functionality of the system media picker.
  final bool useSystemAttachmentPicker;

  /// Forces use of native attachment picker on mobile instead of the custom
  /// Stream attachment picker.
  @Deprecated(
    'Use useSystemAttachmentPicker instead. '
    'This feature was deprecated after v9.4.0',
  )
  bool get useNativeAttachmentPickerOnMobile => useSystemAttachmentPicker;

  /// The configuration to use while creating a poll.
  ///
  /// If not provided, the default configuration is used.
  final PollConfig? pollConfig;

  static String? _defaultHintGetter(
    BuildContext context,
    HintType type,
  ) {
    switch (type) {
      case HintType.searchGif:
        return context.translations.searchGifLabel;
      case HintType.addACommentOrSend:
        return context.translations.addACommentOrSendLabel;
      case HintType.slowModeOn:
        return context.translations.slowModeOnLabel;
      case HintType.writeAMessage:
        return context.translations.writeAMessageLabel;
    }
  }

  static bool _defaultOgPreviewFilter(
    Uri matchedUri,
    String messageText,
  ) {
    // Show the preview for all links
    return true;
  }

  static bool _defaultValidator(Message message) =>
      message.text?.isNotEmpty == true || message.attachments.isNotEmpty;

  static bool _defaultSendMessageKeyPredicate(
    FocusNode node,
    KeyEvent event,
  ) {
    if (CurrentPlatform.isWeb ||
        CurrentPlatform.isMacOS ||
        CurrentPlatform.isWindows ||
        CurrentPlatform.isLinux) {
      // On desktop/web, send the message when the user presses the enter key.
      return event is KeyUpEvent &&
          event.logicalKey == LogicalKeyboardKey.enter;
    }

    return false;
  }

  static bool _defaultClearQuotedMessageKeyPredicate(
    FocusNode node,
    KeyEvent event,
  ) {
    if (CurrentPlatform.isWeb ||
        CurrentPlatform.isMacOS ||
        CurrentPlatform.isWindows ||
        CurrentPlatform.isLinux) {
      // On desktop/web, clear the quoted message when the user presses the escape key.
      return event is KeyUpEvent &&
          event.logicalKey == LogicalKeyboardKey.escape;
    }

    return false;
  }

  @override
  StreamMessageInputState createState() => StreamMessageInputState();
}

/// State of [StreamMessageInput]
class StreamMessageInputState extends State<StreamMessageInput>
    with RestorationMixin<StreamMessageInput>, WidgetsBindingObserver {
  bool get _commandEnabled => _effectiveController.message.command != null;

  bool _actionsShrunk = false;

  late StreamChatThemeData _streamChatTheme;
  late StreamMessageInputThemeData _messageInputTheme;

  bool get _hasQuotedMessage =>
      _effectiveController.message.quotedMessage != null;

  bool get _isEditing => !_effectiveController.message.state.isInitial;

  late final _audioRecorderController = StreamAudioRecorderController();

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());
  FocusNode? _focusNode;

  StreamMessageInputController get _effectiveController =>
      widget.messageInputController ?? _controller!.value;
  StreamRestorableMessageInputController? _controller;

  void _createLocalController([Message? message]) {
    assert(_controller == null, '');
    _controller = StreamRestorableMessageInputController(message: message);
  }

  void _registerController() {
    assert(_controller != null, '');

    registerForRestoration(_controller!, 'messageInputController');
    _initialiseEffectiveController();
  }

  void _initialiseEffectiveController() {
    _effectiveController
      ..removeListener(_onChangedDebounced)
      ..addListener(_onChangedDebounced);

    // Call the listener once to make sure the initial state is reflected
    // correctly in the UI.
    _onChangedDebounced.call();

    if (!_isEditing && _timeOut <= 0) _startSlowMode();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.messageInputController == null) {
      _createLocalController();
    } else {
      _initialiseEffectiveController();
    }
    _effectiveFocusNode.addListener(_focusNodeListener);
  }

  @override
  void didChangeDependencies() {
    _streamChatTheme = StreamChatTheme.of(context);
    _messageInputTheme = StreamMessageInputTheme.of(context);
    super.didChangeDependencies();
  }

  bool _askingForPermission = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed &&
        _permissionState != null &&
        !_askingForPermission) {
      _askingForPermission = true;

      try {
        final newPermissionState = await PhotoManager.requestPermissionExtend();
        if (newPermissionState != _permissionState && mounted) {
          setState(() {
            _permissionState = newPermissionState;
          });
        }
      } catch (_) {}

      _askingForPermission = false;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didUpdateWidget(covariant StreamMessageInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messageInputController == null &&
        oldWidget.messageInputController != null) {
      _createLocalController(oldWidget.messageInputController!.message);
    } else if (widget.messageInputController != null &&
        oldWidget.messageInputController == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
      _initialiseEffectiveController();
    }

    // Update _focusNode
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_focusNodeListener);
      (widget.focusNode ?? _focusNode)?.addListener(_focusNodeListener);
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  @override
  String? get restorationId => widget.restorationId;

  // ignore: no-empty-block
  void _focusNodeListener() {}

  int _timeOut = 0;
  Timer? _slowModeTimer;

  PermissionState? _permissionState;

  void _startSlowMode() {
    if (!mounted) {
      return;
    }
    final channel = StreamChannel.of(context).channel;
    final cooldownStartedAt = channel.cooldownStartedAt;
    if (cooldownStartedAt != null) {
      final diff = DateTime.now().difference(cooldownStartedAt).inSeconds;
      if (diff < channel.cooldown) {
        _timeOut = channel.cooldown - diff;
        if (_timeOut > 0) {
          _slowModeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (_timeOut == 0) {
              timer.cancel();
            } else {
              if (mounted) {
                setState(() => _timeOut -= 1);
              }
            }
          });
        }
      }
    }
  }

  void _stopSlowMode() => _slowModeTimer?.cancel();

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    if (channel.state != null &&
        !channel.ownCapabilities.contains(PermissionType.sendMessage)) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 15,
          ),
          child: Text(
            context.translations.sendMessagePermissionError,
            style: _messageInputTheme.inputTextStyle,
          ),
        ),
      );
    }

    return StreamMessageValueListenableBuilder(
      valueListenable: _effectiveController,
      builder: (context, value, _) {
        Widget child = DecoratedBox(
          decoration: BoxDecoration(
            color: _messageInputTheme.inputBackgroundColor,
            boxShadow: widget.shadow == null
                ? (_streamChatTheme.messageInputTheme.shadow == null
                    ? []
                    : [_streamChatTheme.messageInputTheme.shadow!])
                : [widget.shadow!],
          ),
          child: SimpleSafeArea(
            enabled: widget.enableSafeArea ??
                _streamChatTheme.messageInputTheme.enableSafeArea ??
                true,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (details.delta.dy > 0) {
                  _effectiveFocusNode.unfocus();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_hasQuotedMessage && !_isEditing)
                    // Ensure this doesn't show on web & desktop
                    PlatformWidgetBuilder(
                      mobile: (context, child) => child,
                      child: QuotingMessageTopArea(
                        hasQuotedMessage: _hasQuotedMessage,
                        onQuotedMessageCleared: widget.onQuotedMessageCleared,
                      ),
                    )
                  else if (_effectiveController.ogAttachment != null)
                    OGAttachmentPreview(
                      attachment: _effectiveController.ogAttachment!,
                      onDismissPreviewPressed: () {
                        _effectiveController.clearOGAttachment();
                        _effectiveFocusNode.unfocus();
                      },
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildTextField(context),
                  ),
                  if (_effectiveController.message.parentId != null &&
                      !widget.hideSendAsDm)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 12,
                        left: 12,
                        bottom: 10,
                      ),
                      child: DmCheckbox(
                        foregroundDecoration: BoxDecoration(
                          border: _effectiveController.showInChannel
                              ? null
                              : Border.all(
                                  color: _streamChatTheme
                                      .colorTheme.textHighEmphasis
                                      // ignore: deprecated_member_use
                                      .withOpacity(0.5),
                                  width: 2,
                                ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        color: _effectiveController.showInChannel
                            ? _streamChatTheme.colorTheme.accentPrimary
                            : _streamChatTheme.colorTheme.barsBg,
                        onTap: () {
                          _effectiveController.showInChannel =
                              !_effectiveController.showInChannel;
                        },
                        crossFadeState: _effectiveController.showInChannel
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
        if (!_isEditing) {
          child = Material(
            elevation: widget.elevation ??
                _streamChatTheme.messageInputTheme.elevation ??
                8,
            color: _messageInputTheme.inputBackgroundColor,
            child: child,
          );
        }

        return StreamAutocomplete(
          focusNode: _effectiveFocusNode,
          messageEditingController: _effectiveController,
          fieldViewBuilder: (_, __, ___) => child,
          autocompleteTriggers: [
            ...widget.customAutocompleteTriggers,
            StreamAutocompleteTrigger(
              trigger: _kCommandTrigger,
              triggerOnlyAtStart: true,
              optionsViewBuilder: (
                context,
                autocompleteQuery,
                messageEditingController,
              ) {
                final query = autocompleteQuery.query;
                return StreamCommandAutocompleteOptions(
                  query: query,
                  channel: StreamChannel.of(context).channel,
                  onCommandSelected: (command) {
                    _effectiveController.command = command.name;
                    // removing the overlay after the command is selected
                    StreamAutocomplete.of(context).closeSuggestions();
                  },
                );
              },
            ),
            if (widget.enableMentionsOverlay)
              StreamAutocompleteTrigger(
                trigger: _kMentionTrigger,
                optionsViewBuilder: (
                  context,
                  autocompleteQuery,
                  messageEditingController,
                ) {
                  final query = autocompleteQuery.query;
                  return StreamMentionAutocompleteOptions(
                    query: query,
                    channel: StreamChannel.of(context).channel,
                    mentionAllAppUsers: widget.mentionAllAppUsers,
                    mentionsTileBuilder: widget.userMentionsTileBuilder,
                    onMentionUserTap: (user) {
                      // adding the mentioned user to the controller.
                      _effectiveController.addMentionedUser(user);

                      // accepting the autocomplete option.
                      StreamAutocomplete.of(context)
                          .acceptAutocompleteOption(user.name);
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    return ValueListenableBuilder(
      valueListenable: _audioRecorderController,
      builder: (context, state, _) {
        final isAudioRecordingFlowActive = state is! RecordStateIdle;

        return Row(
          children: [
            if (!isAudioRecordingFlowActive) ...[
              if (!widget.disableAttachments &&
                  channel.ownCapabilities.contains(PermissionType.uploadFile))
                _buildAttachmentButton(context),
              Expanded(child: _buildTextInput(context)),
              if (_isEditing || _effectiveController.attachments.isNotEmpty)
                _buildSendButton(context)
              else
                _buildExpandActionsButton(context),
            ],
            if (widget.enableVoiceRecording &&
                !(widget.enableActionAnimation && _actionsShrunk))
              Expanded(
                // This is to make sure the audio recorder button will be given
                // the full width when it's visible.
                flex: isAudioRecordingFlowActive ? 1 : 0,
                child: StreamAudioRecorderButton(
                  recordState: state,
                  onRecordStart: _audioRecorderController.startRecord,
                  onRecordCancel: _audioRecorderController.cancelRecord,
                  onRecordStop: _audioRecorderController.stopRecord,
                  onRecordLock: _audioRecorderController.lockRecord,
                  onRecordDragUpdate: _audioRecorderController.dragRecord,
                  onRecordStartCancel: () {
                    // Show a message to the user to hold to record.
                    _audioRecorderController.showInfo(
                      context.translations.holdToRecordLabel,
                    );
                  },
                  onRecordFinish: () async {
                    //isVoiceRecordingConfirmationRequiredEnabled
                    // Finish the recording session and add the audio to the
                    // message input controller.
                    final audio = await _audioRecorderController.finishRecord();
                    if (audio != null) {
                      _effectiveController.addAttachment(audio);
                    }

                    // Once the recording is finished, cancel the recorder.
                    _audioRecorderController.cancelRecord(discardTrack: false);

                    // Send the message if the user has enabled the option to
                    // send the voice recording automatically.
                    if (widget.sendVoiceRecordingAutomatically) {
                      return sendMessage();
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSendButton(BuildContext context) {
    if (widget.sendButtonBuilder != null) {
      return widget.sendButtonBuilder!(context, _effectiveController);
    }

    return StreamMessageSendButton(
      onSendMessage: sendMessage,
      timeOut: _timeOut,
      isIdle: !widget.validator(_effectiveController.message),
      idleSendButton: widget.idleSendButton,
      activeSendButton: widget.activeSendButton,
    );
  }

  Widget _buildExpandActionsButton(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.center,
      crossFadeState: switch (widget.enableActionAnimation && _actionsShrunk) {
        true => CrossFadeState.showFirst,
        false => CrossFadeState.showSecond,
      },
      firstChild: _buildSendButton(context),
      secondChild: const Offstage(),
    );
  }

  Widget _buildAttachmentButton(BuildContext context) {
    final defaultButton = AttachmentButton(
      color: _messageInputTheme.actionButtonIdleColor,
      onPressed: _onAttachmentButtonPressed,
    );

    return widget.attachmentButtonBuilder?.call(context, defaultButton) ??
        defaultButton;
  }

  Future<void> _sendPoll(Poll poll) {
    final streamChannel = StreamChannel.of(context);
    final channel = streamChannel.channel;

    return channel.sendPoll(poll);
  }

  Future<void> _updatePoll(Poll poll) {
    final streamChannel = StreamChannel.of(context);
    final channel = streamChannel.channel;

    return channel.updatePoll(poll);
  }

  Future<void> _deletePoll(Poll poll) {
    final streamChannel = StreamChannel.of(context);
    final channel = streamChannel.channel;

    return channel.deletePoll(poll);
  }

  Future<void> _createOrUpdatePoll(Poll? old, Poll? current) async {
    // If both are null or the same, return
    if ((old == null && current == null) || old == current) return;

    // If old is null, i.e., there was no poll before, create the poll.
    if (old == null) return _sendPoll(current!);

    // If current is null, i.e., the poll is removed, delete the poll.
    if (current == null) return _deletePoll(old);

    // Otherwise, update the poll.
    return _updatePoll(current);
  }

  /// Handle the platform-specific logic for selecting files.
  ///
  /// On mobile, this will open the file selection bottom sheet. On desktop,
  /// this will open the native file system and allow the user to select one
  /// or more files.
  Future<void> _onAttachmentButtonPressed() async {
    final initialPoll = _effectiveController.poll;
    final initialAttachments = _effectiveController.attachments;

    // Remove AttachmentPickerType.poll if the user doesn't have the permission
    // to send a poll or if this is a thread message.
    final allowedTypes = [...widget.allowedAttachmentPickerTypes]
      ..removeWhere((it) {
        if (it != AttachmentPickerType.poll) return false;
        if (_effectiveController.message.parentId != null) return true;
        final channel = StreamChannel.of(context).channel;
        if (channel.ownCapabilities.contains(PermissionType.sendPoll)) {
          return false;
        }

        return true;
      });

    final messageInputTheme = StreamMessageInputTheme.of(context);
    final useSystemPicker = widget.useSystemAttachmentPicker ||
        (messageInputTheme.useSystemAttachmentPicker ?? false);

    final value = await showStreamAttachmentPickerModalBottomSheet(
      context: context,
      onError: widget.onError,
      allowedTypes: allowedTypes,
      pollConfig: widget.pollConfig,
      initialPoll: initialPoll,
      initialAttachments: initialAttachments,
      useSystemAttachmentPicker: useSystemPicker,
    );

    if (value == null || value is! AttachmentPickerValue) return;

    // Add the attachments to the controller.
    _effectiveController.attachments = value.attachments;

    // Create or update the poll.
    await _createOrUpdatePoll(initialPoll, value.poll);
  }

  Widget _buildTextInput(BuildContext context) {
    return DropTarget(
      onDragDone: (details) async {
        final files = details.files;
        final attachments = <Attachment>[];
        for (final file in files) {
          final attachment = await file.toAttachment(type: AttachmentType.file);
          attachments.add(attachment);
        }

        if (attachments.isNotEmpty) _addAttachments(attachments);
      },
      onDragEntered: (details) {
        setState(() {});
      },
      onDragExited: (details) {},
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: _messageInputTheme.borderRadius,
          border: _effectiveFocusNode.hasFocus
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                )
              : Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1.5,
                ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReplyToMessage(),
            _buildAttachments(),
            LimitedBox(
              maxHeight: widget.maxHeight,
              child: PlatformWidgetBuilder(
                web: (context, child) => Focus(
                  skipTraversal: true,
                  onKeyEvent: _handleKeyPressed,
                  child: child!,
                ),
                desktop: (context, child) => Focus(
                  skipTraversal: true,
                  onKeyEvent: _handleKeyPressed,
                  child: child!,
                ),
                mobile: (context, child) => Focus(
                  skipTraversal: true,
                  onKeyEvent: _handleKeyPressed,
                  child: child!,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: StreamMessageTextField(
                        key: const Key('messageInputText'),
                        maxLines: widget.maxLines,
                        minLines: widget.minLines,
                        textInputAction: widget.textInputAction,
                        onSubmitted: (_) => sendMessage(),
                        keyboardType: widget.keyboardType,
                        controller: _effectiveController,
                        focusNode: _effectiveFocusNode,
                        style: _messageInputTheme.inputTextStyle,
                        autofocus: widget.autofocus,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: _getInputDecoration(context),
                        textCapitalization: widget.textCapitalization,
                        autocorrect: widget.autoCorrect,
                        contentInsertionConfiguration:
                            widget.contentInsertionConfiguration,
                      ),
                    ),
                    widget.emojiSendButton ?? const Offstage(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  KeyEventResult _handleKeyPressed(FocusNode node, KeyEvent event) {
    // Check for send message key.
    if (widget.sendMessageKeyPredicate(node, event)) {
      sendMessage();
      return KeyEventResult.handled;
    }

    // Check for clear quoted message key.
    if (widget.clearQuotedMessageKeyPredicate(node, event)) {
      if (_hasQuotedMessage && _effectiveController.text.isEmpty) {
        widget.onQuotedMessageCleared?.call();
      }
      return KeyEventResult.handled;
    }

    // Return ignored to allow other key events to be handled.
    return KeyEventResult.ignored;
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    final passedDecoration = _messageInputTheme.inputDecoration;
    return InputDecoration(
      isDense: true,
      hintText: _getHint(context),
      hintStyle: _messageInputTheme.inputTextStyle!.copyWith(
        color: _streamChatTheme.colorTheme.textLowEmphasis,
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      prefixIcon: _commandEnabled
          ? Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: _streamChatTheme.colorTheme.accentPrimary,
                borderRadius: _messageInputTheme.borderRadius?.add(
                  BorderRadius.circular(6),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StreamSvgIcon(
                    size: 16,
                    color: Colors.white,
                    icon: StreamSvgIcons.lightning,
                  ),
                  Text(
                    _effectiveController.message.command!.toUpperCase(),
                    style: _streamChatTheme.textTheme.footnoteBold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : null,
      suffixIconConstraints: const BoxConstraints.tightFor(height: 40),
      prefixIconConstraints: const BoxConstraints.tightFor(height: 40),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_commandEnabled)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: StreamMessageInputIconButton(
                iconSize: 24,
                color: _messageInputTheme.actionButtonIdleColor,
                icon: const StreamSvgIcon(icon: StreamSvgIcons.closeSmall),
                onPressed: _effectiveController.clear,
              ),
            ),
          if (widget.sendButtonLocation == SendButtonLocation.inside)
            _buildSendButton(context),
        ].nonNulls.toList(),
      ),
    ).merge(passedDecoration);
  }

  late final _onChangedDebounced = debounce(
    () {
      var value = _effectiveController.text;
      if (!mounted) return;
      value = value.trim();

      final channel = StreamChannel.of(context).channel;
      if (value.isNotEmpty &&
          channel.ownCapabilities.contains(PermissionType.sendTypingEvents)) {
        // Notify the server that the user started typing.
        channel.keyStroke(_effectiveController.message.parentId).onError(
          (error, stackTrace) {
            widget.onError?.call(error!, stackTrace);
          },
        );
      }

      int actionsLength;
      if (widget.actionsBuilder != null) {
        actionsLength = widget.actionsBuilder!(context, []).length;
      } else {
        actionsLength = 0;
      }
      if (widget.showCommandsButton) actionsLength += 1;
      if (!widget.disableAttachments) actionsLength += 1;

      setState(() => _actionsShrunk = value.isNotEmpty && actionsLength > 1);

      _checkContainsUrl(value, context);
    },
    const Duration(milliseconds: 350),
    leading: true,
  );

  String? _getHint(BuildContext context) {
    HintType hintType;

    if (_commandEnabled && _effectiveController.message.command == 'giphy') {
      hintType = HintType.searchGif;
    } else if (_effectiveController.attachments.isNotEmpty) {
      hintType = HintType.addACommentOrSend;
    } else if (_timeOut != 0) {
      hintType = HintType.slowModeOn;
    } else {
      hintType = HintType.writeAMessage;
    }

    return widget.hintGetter.call(context, hintType);
  }

  String? _lastSearchedContainsUrlText;
  CancelableOperation? _enrichUrlOperation;
  final _urlRegex = RegExp(
    r'https?://(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_+.~#?&//=]*)',
    caseSensitive: false,
  );

  void _checkContainsUrl(String value, BuildContext context) async {
    // Cancel the previous operation if it's still running
    _enrichUrlOperation?.cancel();

    // If the text is same as the last time, don't do anything
    if (_lastSearchedContainsUrlText == value) return;
    _lastSearchedContainsUrlText = value;

    final matchedUrls = _urlRegex.allMatches(value).where((it) {
      final _parsedMatch = Uri.tryParse(it.group(0) ?? '')?.withScheme;
      if (_parsedMatch == null) return false;

      return _parsedMatch.host.split('.').last.isValidTLD() &&
          widget.ogPreviewFilter.call(_parsedMatch, value);
    }).toList();

    // Reset the og attachment if the text doesn't contain any url
    if (matchedUrls.isEmpty ||
        !StreamChannel.of(context)
            .channel
            .ownCapabilities
            .contains(PermissionType.sendLinks)) {
      _effectiveController.clearOGAttachment();
      return;
    }

    final firstMatchedUrl = matchedUrls.first.group(0)!;

    // If the parsed url matches the ogAttachment url, don't do anything
    if (_effectiveController.ogAttachment?.titleLink == firstMatchedUrl) {
      return;
    }

    final client = StreamChat.of(context).client;

    _enrichUrlOperation = CancelableOperation.fromFuture(
      _enrichUrl(firstMatchedUrl, client),
    ).then(
      (ogAttachment) {
        final attachment = Attachment.fromOGAttachment(ogAttachment);
        _effectiveController.setOGAttachment(attachment);
      },
      onError: (error, stackTrace) {
        // Reset the ogAttachment if there was an error
        _effectiveController.clearOGAttachment();
        widget.onError?.call(error, stackTrace);
      },
    );
  }

  final _ogAttachmentCache = <String, OGAttachmentResponse>{};

  Future<OGAttachmentResponse> _enrichUrl(
    String url,
    StreamChatClient client,
  ) async {
    var response = _ogAttachmentCache[url];
    if (response == null) {
      final client = StreamChat.of(context).client;
      try {
        response = await client.enrichUrl(url);
        _ogAttachmentCache[url] = response;
      } catch (e, stk) {
        return Future.error(e, stk);
      }
    }
    return response;
  }

  Widget _buildReplyToMessage() {
    if (!_hasQuotedMessage) return const Offstage();
    final quotedMessage = _effectiveController.message.quotedMessage!;

    final quotedMessageBuilder = widget.quotedMessageBuilder;
    if (quotedMessageBuilder != null) {
      return quotedMessageBuilder(
        context,
        _effectiveController.message.quotedMessage!,
      );
    }

    final containsUrl = quotedMessage.attachments.any((it) {
      return it.type == AttachmentType.urlPreview;
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: StreamQuotedMessageWidget(
        reverse: true,
        isDm: widget.isDm,
        showBorder: !containsUrl,
        message: quotedMessage,
        messageTheme: _streamChatTheme.otherMessageTheme,
        onQuotedMessageClear: widget.onQuotedMessageCleared,
        attachmentThumbnailBuilders:
            widget.quotedMessageAttachmentThumbnailBuilders,
      ),
    );
  }

  Widget _buildAttachments() {
    final attachments = _effectiveController.attachments;
    final nonOGAttachments = attachments.where((it) {
      return it.titleLink == null;
    }).toList(growable: false);

    // If there are no attachments, return an empty widget
    if (nonOGAttachments.isEmpty) return const Offstage();

    // If the user has provided a custom attachment list builder, use that.
    final attachmentListBuilder = widget.attachmentListBuilder;
    if (attachmentListBuilder != null) {
      return attachmentListBuilder(
        context,
        nonOGAttachments,
        _onAttachmentRemovePressed,
      );
    }

    // Otherwise, use the default attachment list builder.
    return LimitedBox(
      maxHeight: 240,
      child: StreamMessageInputAttachmentList(
        attachments: nonOGAttachments,
        onRemovePressed: _onAttachmentRemovePressed,
        fileAttachmentListBuilder: widget.fileAttachmentListBuilder,
        mediaAttachmentListBuilder: widget.mediaAttachmentListBuilder,
        voiceRecordingAttachmentBuilder: widget.voiceRecordingAttachmentBuilder,
        fileAttachmentBuilder: widget.fileAttachmentBuilder,
        mediaAttachmentBuilder: widget.mediaAttachmentBuilder,
        voiceRecordingAttachmentListBuilder:
            widget.voiceRecordingAttachmentListBuilder,
      ),
    );
  }

  // Default callback for removing an attachment.
  Future<void> _onAttachmentRemovePressed(Attachment attachment) async {
    final file = attachment.file;
    final uploadState = attachment.uploadState;

    if (file != null && !uploadState.isSuccess && !isWeb) {
      await StreamAttachmentHandler.instance.deleteAttachmentFile(
        attachmentFile: file,
      );
    }

    _effectiveController.removeAttachmentById(attachment.id);
  }

  /// Adds an attachment to the [messageInputController.attachments] map
  void _addAttachments(Iterable<Attachment> attachments) {
    final limit = widget.attachmentLimit;
    final length = _effectiveController.attachments.length + attachments.length;
    if (length > limit) {
      final onAttachmentLimitExceed = widget.onAttachmentLimitExceed;
      if (onAttachmentLimitExceed != null) {
        return onAttachmentLimitExceed(
          widget.attachmentLimit,
          context.translations.attachmentLimitExceedError(limit),
        );
      }
      return _showErrorAlert(
        context.translations.attachmentLimitExceedError(limit),
      );
    }
    for (final attachment in attachments) {
      _effectiveController.addAttachment(attachment);
    }
  }

  /// Sends the current message
  Future<void> sendMessage() async {
    if (_timeOut > 0 ||
        (_effectiveController.text.trim().isEmpty &&
            _effectiveController.attachments.isEmpty)) {
      return;
    }

    final streamChannel = StreamChannel.of(context);
    final channel = streamChannel.channel;
    var message = _effectiveController.value;

    if (!channel.ownCapabilities.contains(PermissionType.sendLinks) &&
        _urlRegex.allMatches(message.text ?? '').any((element) =>
            element.group(0)?.split('.').last.isValidTLD() == true)) {
      showInfoBottomSheet(
        context,
        icon: StreamSvgIcon(
          icon: StreamSvgIcons.error,
          color: StreamChatTheme.of(context).colorTheme.accentError,
          size: 24,
        ),
        title: 'Links are disabled',
        details: 'Sending links is not allowed in this conversation.',
        okText: context.translations.okLabel,
      );
      return;
    }

    final containsCommand = message.command != null;
    // If the message contains command we should append it to the text
    // before sending it.
    if (containsCommand) {
      message = message.copyWith(text: '/${message.command} ${message.text}');
    }

    var shouldKeepFocus = widget.shouldKeepFocusAfterMessage;
    shouldKeepFocus ??= !_commandEnabled;

    widget.onQuotedMessageCleared?.call();

    _effectiveController.reset();

    if (widget.preMessageSending != null) {
      message = await widget.preMessageSending!(message);
    }

    message = message.replaceMentionsWithId();

    // If the channel is not up to date, we should reload it before sending
    // the message.
    if (!channel.state!.isUpToDate) {
      await streamChannel.reloadChannel();

      // We need to wait for the frame to be rendered with the updated channel
      // state before sending the message.
      await WidgetsBinding.instance.endOfFrame;
    }

    await _sendOrUpdateMessage(message: message);

    if (mounted) {
      if (shouldKeepFocus) {
        FocusScope.of(context).requestFocus(_effectiveFocusNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  Future<void> _sendOrUpdateMessage({
    required Message message,
  }) async {
    final channel = StreamChannel.of(context).channel;

    try {
      final resp = await switch (_isEditing) {
        true => channel.updateMessage(message),
        false => channel.sendMessage(message),
      };

      if (resp.message.isError) {
        _effectiveController.message = message;
      }

      _startSlowMode();
      widget.onMessageSent?.call(resp.message);
    } catch (e, stk) {
      if (widget.onError != null) {
        return widget.onError?.call(e, stk);
      }

      rethrow;
    }
  }

  void _showErrorAlert(String description) {
    showModalBottomSheet(
      backgroundColor: _streamChatTheme.colorTheme.barsBg,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => ErrorAlertSheet(
        errorDescription: context.translations.somethingWentWrongError,
      ),
    );
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onChangedDebounced);
    _controller?.dispose();
    _effectiveFocusNode.removeListener(_focusNodeListener);
    _focusNode?.dispose();
    _stopSlowMode();
    _onChangedDebounced.cancel();
    _audioRecorderController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

/// Preview of an Open Graph attachment.
class OGAttachmentPreview extends StatelessWidget {
  /// Returns a new instance of [OGAttachmentPreview]
  const OGAttachmentPreview({
    super.key,
    required this.attachment,
    this.onDismissPreviewPressed,
  });

  /// The attachment to be rendered.
  final Attachment attachment;

  /// Called when the dismiss button is pressed.
  final VoidCallback? onDismissPreviewPressed;

  @override
  Widget build(BuildContext context) {
    final chatTheme = StreamChatTheme.of(context);
    final textTheme = chatTheme.textTheme;
    final colorTheme = chatTheme.colorTheme;

    final attachmentTitle = attachment.title;
    final attachmentText = attachment.text;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: StreamSvgIcon(
            icon: StreamSvgIcons.link,
            color: colorTheme.accentPrimary,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: colorTheme.accentPrimary,
                  width: 2,
                ),
              ),
            ),
            padding: const EdgeInsets.only(left: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (attachmentTitle != null)
                  Text(
                    attachmentTitle.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                if (attachmentText != null)
                  Text(
                    attachmentText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.body.copyWith(fontWeight: FontWeight.w400),
                  ),
              ],
            ),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const StreamSvgIcon(icon: StreamSvgIcons.closeSmall),
          onPressed: onDismissPreviewPressed,
        ),
      ],
    );
  }
}
