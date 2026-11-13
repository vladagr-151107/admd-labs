import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/todo.dart';

// The log is shown on screen
final ValueNotifier<List<String>> retryLog = ValueNotifier([]);

void _log(String s) {
  debugPrint(s);
  retryLog.value = [...retryLog.value, s];
}

final _dio = Dio(BaseOptions(
  baseUrl: 'https://jsonplaceholder.typicode.com',
));

Future<T> withRetry<T>(Future<T> Function() op, {int maxAttempts = 5}) async {
  for (var i = 0; ; i++) {
    try {
      return await op();
    } catch (e) {
      if (i == maxAttempts - 1) {
        _log('Attempt ${i + 1} failed: $e. Giving up.');
        rethrow;
      }
      final b = 400 * (1 << i); // 400, 800, 1600, 3200 ms
      final delay = b + Random().nextInt(b); // jitter
      _log('Attempt ${i + 1} failed. Retry in $delay ms');
      await Future.delayed(Duration(milliseconds: delay));
    }
  }
}

Future<List<Todo>> fetchTodos({String path = '/todos'}) {
  return withRetry(() async {
    final res = await _dio.get(path);
    final raw = res.data as List<dynamic>;
    return raw.map((j) => Todo.fromJson(j as Map<String, dynamic>)).toList();
  });
}