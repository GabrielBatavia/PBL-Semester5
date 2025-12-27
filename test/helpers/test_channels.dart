// test/helpers/test_channels.dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class TestChannels {
  static void mockPathProvider(String dirPath) {
    const channel = MethodChannel('plugins.flutter.io/path_provider');

    TestWidgetsFlutterBinding.ensureInitialized();
    final messenger = TestWidgetsFlutterBinding.instance.defaultBinaryMessenger;

    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getApplicationDocumentsDirectory':
          return dirPath;
        case 'getExternalStorageDirectory':
          return dirPath;
        default:
          return dirPath;
      }
    });
  }

  static void clearPathProviderMock() {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestWidgetsFlutterBinding.ensureInitialized();
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  }
}
