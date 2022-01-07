import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pusher_websocket_flutter/pusher_websocket_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('pusher_websocket_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
