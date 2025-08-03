import 'package:flutter/material.dart';

class PerformanceMonitor {
  static void logOperation(String operation, Function() callback) {
    final stopwatch = Stopwatch()..start();
    
    try {
      callback();
    } finally {
      stopwatch.stop();
      if (stopwatch.elapsedMilliseconds > 100) {
        debugPrint('Performance warning: $operation took ${stopwatch.elapsedMilliseconds}ms');
      }
    }
  }

  static Future<T> logAsyncOperation<T>(String operation, Future<T> Function() callback) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await callback();
      return result;
    } finally {
      stopwatch.stop();
      if (stopwatch.elapsedMilliseconds > 1000) {
        debugPrint('Performance warning: $operation took ${stopwatch.elapsedMilliseconds}ms');
      }
    }
  }

  static void monitorWidgetBuild(String widgetName, Widget Function() builder) {
    final stopwatch = Stopwatch()..start();
    
    try {
      builder();
    } finally {
      stopwatch.stop();
      if (stopwatch.elapsedMilliseconds > 16) { // 60fps = 16ms per frame
        debugPrint('Performance warning: $widgetName build took ${stopwatch.elapsedMilliseconds}ms');
      }
    }
  }
} 