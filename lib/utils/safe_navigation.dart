// lib/utils/safe_navigation.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension SafeNavigation on BuildContext {
  void safePush(String location, {Object? extra}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        push(location, extra: extra);
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    });
  }

  void safePushNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        pushNamed(
          name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra,
        );
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    });
  }

  void safeGo(String location, {Object? extra}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        go(location, extra: extra);
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    });
  }
}