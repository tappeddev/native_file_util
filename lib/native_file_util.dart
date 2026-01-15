import 'package:flutter/services.dart';

/// Utilities for managing native files.
///
/// Currently supported platform(s): iOS.
class NativeFileUtil {
  /// Creates a [NativeFileUtil] instance.
  ///
  /// The optional [channel] is mainly useful for testing.
  const NativeFileUtil({
    MethodChannel channel = const MethodChannel('native_file_util'),
  }) : _channel = channel;

  final MethodChannel _channel;

  /// Excludes the item at [url] from iCloud/iTunes backups.
  ///
  /// On iOS this sets `URLResourceValues.isExcludedFromBackup = true`.
  Future<void> excludeFromBackup(Uri url) async {
    await _channel.invokeMethod<void>(
      'excludeFromBackup',
      <String, Object?>{'url': url.toString()},
    );
  }

  /// Returns whether the item at [url] is excluded from backups.
  ///
  /// On iOS this reads `URLResourceValues.isExcludedFromBackup`.
  Future<bool> isExcludedFromBackup(Uri url) async {
    final value = await _channel.invokeMethod<bool>(
      'isExcludedFromBackup',
      <String, Object?>{'url': url.toString()},
    );
    return value ?? false;
  }
}
