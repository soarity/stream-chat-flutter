import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  group('EditMessageSheet tests', () {
    const methodChannel =
        MethodChannel('dev.fluttercommunity.plus/connectivity_status');
    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel,
              (MethodCall methodCall) async {
        if (methodCall.method == 'listen') {
          try {
            await TestDefaultBinaryMessengerBinding
                .instance.defaultBinaryMessenger
                .handlePlatformMessage(
              methodChannel.name,
              methodChannel.codec.encodeSuccessEnvelope(['wifi']),
              (_) {},
            );
          } catch (e) {
            print(e);
          }
        }
        return null;
      });
    });

    testWidgets('appears on tap', (tester) async {
      final channel = MockChannel();
      when(channel.getRemainingCooldown).thenReturn(0);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: MockClient(),
            child: child,
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    child: const Text('Show Modal'),
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => EditMessageSheet(
                        channel: channel,
                        message: Message(id: 'msg123', text: 'Hello World!'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(EditMessageSheet), findsOneWidget);
      expect(find.text('Edit Message'), findsOneWidget);
      expect(find.byType(StreamMessageInput), findsOneWidget);
    });

    goldenTest(
      'golden test for EditMessageSheet',
      fileName: 'edit_message_sheet_0',
      constraints: const BoxConstraints.tightFor(width: 300, height: 300),
      builder: () {
        final channel = MockChannel();
        when(channel.getRemainingCooldown).thenReturn(0);

        return MaterialAppWrapper(
          builder: (context, child) => StreamChat(
            client: MockClient(),
            child: child,
          ),
          home: Scaffold(
            bottomSheet: EditMessageSheet(
              channel: channel,
              message: Message(id: 'msg123', text: 'Hello World!'),
            ),
          ),
        );
      },
    );

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(methodChannel, null);
    });
  });
}
