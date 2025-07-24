import 'dart:convert';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The secure store.
///
/// It uses system built-in vault to store the data.
abstract final class SecureStore {
  /// The name of default user account. Such as 'debug.user1' or 'release.user1'.
  ///
  /// - Only available on iOS and macOS.
  /// - Not [IOSOptions.groupId].
  static const defaultAccountName = 'fllib_secure_store';

  /// The secure storage instance.
  ///
  /// With [defaultAccountName], [KeychainAccessibility.first_unlock_this_device],
  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      accountName: defaultAccountName,
      synchronizable: false,
      groupId: null,
    ),
    mOptions: MacOsOptions(
      accountName: defaultAccountName,
      synchronizable: false,
      accessibility: KeychainAccessibility.first_unlock_this_device,
      groupId: null,
    ),
  );

  static Future<T?> readJson<T>(String key, JsonFromJson<T> fromJson) {
    return storage.readJson<T>(key, fromJson);
  }

  static Future<bool> writeJson<T>(String key, T value, JsonToJson<T> toJson) {
    return storage.writeJson<T>(key, value, toJson);
  }
}

/// Includes [readJson] and [writeJson].
extension SecureStoreExt on FlutterSecureStorage {
  /// Read a JSON object from secure storage.
  Future<T?> readJson<T>(String key, JsonFromJson<T> fromJson) async {
    try {
      final jsonStr = await read(key: key);
      if (jsonStr == null) return null;
      final obj = fromJson(json.decode(jsonStr));
      return obj;
    } catch (e) {
      dprint('Error reading JSON from secure storage: $e');
      return null;
    }
  }

  /// Write a JSON object to secure storage.
  Future<bool> writeJson<T>(String key, T value, JsonToJson<T> toJson) async {
    try {
      final jsonStr = json.encode(toJson(value));
      await write(key: key, value: jsonStr);
      return true;
    } catch (e) {
      dprint('Error writing JSON to secure storage: $e');
    }
    return false;
  }

  Future<int?> readInt(String key) async {
    final value = await read(key: key);
    if (value == null) return null;
    return int.tryParse(value);
  }

  Future<void> writeInt(String key, int? value) {
    if (value == null) {
      return write(key: key, value: null);
    }
    return write(key: key, value: value.toString());
  }

  Future<bool?> readBool(String key) async {
    final value = await read(key: key);
    if (value == null) return null;
    return value == '1';
  }

  Future<void> writeBool(String key, bool? value) {
    if (value == null) {
      return write(key: key, value: null);
    }
    return write(key: key, value: value ? '1' : '0');
  }
}

/// A property that stored in [FlutterSecureStorage].
final class SecureProp {
  /// The secure storage instance.
  ///
  /// Default is [SecureStore.storage].
  final FlutterSecureStorage storage;

  /// The key of the property.
  final String key;

  /// Creates a [SecureProp] with the given [key] and optional [storage].
  SecureProp(this.key, {this.storage = SecureStore.storage});

  /// Reads the value of the property.
  Future<String?> read() async {
    return storage.read(key: key);
  }

  /// Writes the value of the property.
  Future<void> write(String? value) {
    return storage.write(key: key, value: value);
  }
}
