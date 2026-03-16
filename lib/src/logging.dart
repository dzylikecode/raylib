// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:logging/logging.dart';

final _logger = Logger('raylib');

Level _toLevel(int raylibLevel) => switch (raylibLevel) {
  1 => Level.FINEST,  // LOG_TRACE
  2 => Level.FINE,    // LOG_DEBUG
  3 => Level.INFO,    // LOG_INFO
  4 => Level.WARNING, // LOG_WARNING
  5 => Level.SEVERE,  // LOG_ERROR
  6 => Level.SHOUT,   // LOG_FATAL
  _ => Level.INFO,
};

/// Log a message through Dart's [Logger] named 'raylib'.
void TraceLog(int logLevel, String text) =>
    _logger.log(_toLevel(logLevel), text);

StreamSubscription<LogRecord>? _subscription;

/// Set a handler for all raylib log records.
///
/// Pass [null] to remove the current handler.
/// Users can also configure [Logger.root] directly for global log routing.
void SetTraceLogCallback(void Function(LogRecord)? handler) {
  _subscription?.cancel();
  _subscription = handler != null ? _logger.onRecord.listen(handler) : null;
}
