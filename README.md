# native_file_util

Flutter plugin for managing native files on **iOS**.

## Features

- Exclude a file or directory URL from backup (`NSURLIsExcludedFromBackupKey` / `URLResourceValues.isExcludedFromBackup`).
- Check whether a file or directory URL is excluded from backup.

## Usage

```dart
import 'dart:io';
import 'package:native_file_util/native_file_util.dart';

final file = File('/path/to/file');
final util = NativeFileUtil();
await util.excludeFromBackup(file.uri);

final excluded = await util.isExcludedFromBackup(file.uri);
```

## iOS

This plugin currently supports iOS only.

## Swift Package Manager (SPM)

This plugin is **Swift Package Manager only** for iOS. (No CocoaPods / `.podspec` integration.)

See:

- `https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-plugin-authors`
