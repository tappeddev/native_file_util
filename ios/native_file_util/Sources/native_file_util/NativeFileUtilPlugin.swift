import Flutter
import Foundation

public class NativeFileUtilPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "native_file_util",
      binaryMessenger: registrar.messenger()
    )
    let instance = NativeFileUtilPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    do {
      switch call.method {
      case "excludeFromBackup":
        let url = try Self.extractUrl(from: call.arguments)
        try Self.excludeItem(at: url)
        result(nil)

      case "isExcludedFromBackup":
        let url = try Self.extractUrl(from: call.arguments)
        let excluded = try Self.isExcludedFromBackup(at: url)
        result(excluded)

      default:
        result(FlutterMethodNotImplemented)
      }
    } catch let error as NativeFileUtilFlutterError {
      result(error.flutterError)
    } catch {
      result(
        FlutterError(
          code: "native_file_util_error",
          message: error.localizedDescription,
          details: nil
        )
      )
    }
  }
}

private extension NativeFileUtilPlugin {
  struct NativeFileUtilFlutterError: Error {
    let code: String
    let message: String
    let details: Any?

    var flutterError: FlutterError {
      FlutterError(code: code, message: message, details: details)
    }
  }

  static func extractUrl(from arguments: Any?) throws -> URL {
    guard
      let args = arguments as? [String: Any],
      let urlString = args["url"] as? String
    else {
      throw NativeFileUtilFlutterError(
        code: "invalid_arguments",
        message: "Expected arguments: {\"url\": <String>}",
        details: arguments
      )
    }

    // Accept either a full URL string (e.g. file://...) or a raw file path.
    let url: URL
    if let parsed = URL(string: urlString), parsed.scheme != nil {
      url = parsed
    } else {
      url = URL(fileURLWithPath: urlString)
    }

    guard url.isFileURL else {
      throw NativeFileUtilFlutterError(
        code: "not_a_file_url",
        message: "Only file:// URLs (or file paths) are supported on iOS.",
        details: urlString
      )
    }

    return url
  }

  static func excludeItem(at url: URL) throws {
    // Create the resource values for the specified URL.
    var values = URLResourceValues()
    values.isExcludedFromBackup = true

    // Apply those values to the URL.
    var url = url
    try url.setResourceValues(values)
  }

  static func isExcludedFromBackup(at url: URL) throws -> Bool {
    let values = try url.resourceValues(forKeys: [.isExcludedFromBackupKey])
    return values.isExcludedFromBackup ?? false
  }
}


