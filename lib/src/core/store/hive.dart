part of 'iface.dart';

/// The store of Hive.
///
/// It implements [Store].
class HiveStore extends Store {
  /// The internal hive box for this [Store].
  late final Box<dynamic> box;

  /// The name of the box. Used for the hive box.
  final String boxName;

  /// Constructor.
  HiveStore(
    this.boxName, {
    super.lastUpdateTsKey,
    super.updateLastUpdateTsOnClear,
    super.updateLastUpdateTsOnRemove,
    super.updateLastUpdateTsOnSet,
  }) : super(name: boxName);

  /// Initialize the [HiveStore].
  Future<void> init() async {
    if (_HiveEnc._cipher == null) await _HiveEnc._initCipher();

    final path = switch (Pfs.type) {
      /// The default path of Hive is the HOME dir
      Pfs.linux || Pfs.windows => Paths.doc,
      _ => (await getApplicationDocumentsDirectory()).path,
    };

    final enc = await Hive.openBox(
      '${boxName}_enc',
      path: path,
      encryptionCipher: _HiveEnc._cipher,
    );

    final unencryptedFile = File('${path.joinPath(boxName)}.hive');
    if (await unencryptedFile.exists()) {
      // Do migration
      try {
        final unencrypted = await Hive.openBox(boxName, path: path);
        for (final key in unencrypted.keys) {
          enc.put(key, unencrypted.get(key));
        }
        await unencrypted.close();
        await unencryptedFile.delete();
        dprint('Migrated $boxName');
      } catch (e) {
        dprint('Failed to migrate $boxName: $e');
      }
    }

    box = enc;
  }

  @override
  T? get<T extends Object>(String key, {StoreFromObj<T>? fromObj}) {
    final val = box.get(key);
    if (val is! T?) {
      if (val == null) return null;

      if (fromObj != null) {
        try {
          final converted = fromObj(val);
          if (converted is T) return converted;
        } catch (_) {
          dprintWarn('get("$key")', 'fromObj failed for key "$key"');
        }
      }

      dprintWarn('get("$key")', 'is: ${val.runtimeType}');
      return null;
    }
    return val;
  }

  @override
  bool set<T extends Object>(
    String key,
    T val, {
    StoreToObj<T>? toObj,
    bool? updateLastUpdateTsOnSet,
  }) {
    updateLastUpdateTsOnSet ??= this.updateLastUpdateTsOnSet;
    if (toObj != null) {
      final str = toObj(val);
      if (str is String) {
        box.put(key, str);
        if (updateLastUpdateTsOnSet) updateLastUpdateTs(key: key);
        return true;
      }
    }
    box.put(key, val);
    if (updateLastUpdateTsOnSet) updateLastUpdateTs(key: key);
    return true;
  }

  @override
  bool setAll<T extends Object>(
    Map<String, T> map, {
    StoreToObj<T>? toObj,
    bool? updateLastUpdateTsOnSet,
  }) {
    updateLastUpdateTsOnSet ??= this.updateLastUpdateTsOnSet;
    for (final entry in map.entries) {
      final res = set(entry.key, entry.value, toObj: toObj, updateLastUpdateTsOnSet: updateLastUpdateTsOnSet);
      if (!res) {
        dprintWarn('setAll()', 'failed to set ${entry.key}');
        return false;
      }
    }
    return true;
  }

  @override
  Set<String> keys({bool includeInternalKeys = StoreDefaults.defaultIncludeInternalKeys}) {
    final set_ = <String>{};
    for (final key in box.keys) {
      if (key is String) {
        if (!includeInternalKeys && isInternalKey(key)) continue;
        set_.add(key);
      }
    }
    return set_;
  }

  @override
  bool remove(String key, {bool? updateLastUpdateTsOnRemove}) {
    box.delete(key);
    updateLastUpdateTsOnRemove ??= this.updateLastUpdateTsOnRemove;
    if (updateLastUpdateTsOnRemove) updateLastUpdateTs(key: key);
    return true;
  }

  @override
  bool clear({bool? updateLastUpdateTsOnClear}) {
    final lastUpdateTsMap = lastUpdateTs;
    box.clear();
    if (lastUpdateTsMap != null) {
      set(lastUpdateTsKey, lastUpdateTsMap, updateLastUpdateTsOnSet: false);
    }

    updateLastUpdateTsOnClear ??= this.updateLastUpdateTsOnClear;
    if (updateLastUpdateTsOnClear) updateLastUpdateTs(key: null);
    return true;
  }

  @override
  Map<String, Object?> getAllMap({
    bool includeInternalKeys = StoreDefaults.defaultIncludeInternalKeys,
  }) {
    final keys = this.keys(includeInternalKeys: includeInternalKeys);
    return Map.fromIterables(keys, keys.map((key) => get(key)));
  }

  @override
  Map<String, T> getAllMapTyped<T extends Object>({
    bool includeInternalKeys = StoreDefaults.defaultIncludeInternalKeys,
    StoreFromObj<T>? fromStr,
  }) {
    final keys = this.keys(includeInternalKeys: includeInternalKeys);
    final map = <String, T>{};
    for (final key in keys) {
      final val = get(key);
      if (val is T) {
        map[key] = val;
        continue;
      }
      if (val is String) {
        try {
          final converted = fromStr?.call(val);
          if (converted is T) {
            map[key] = converted;
            continue;
          }
        } catch (e) {
          dprintWarn('getAllMapTyped()', 'convert `$key`: $e');
        }
      }
    }
    return map;
  }

  /// A property of the [HiveStore].
  HiveProp<T> property<T extends Object>(
    String key, {
    T? defaultValue,
    bool updateLastModified = true,
    StoreFromObj<T>? fromObj,
    StoreToObj<T>? toObj,
  }) {
    return HiveProp<T>(
      this,
      key,
      updateLastUpdateTsOnSetProp: updateLastModified,
      fromObj: fromObj,
      toObj: toObj,
    );
  }

  HivePropDefault<T> propertyDefault<T extends Object>(
    String key,
    T defaultValue, {
    bool updateLastModified = StoreDefaults.defaultUpdateLastUpdateTs,
    StoreFromObj<T>? fromObj,
    StoreToObj<T>? toObj,
  }) {
    return HivePropDefault<T>(
      this,
      key,
      defaultValue,
      updateLastUpdateTsOnSetProp: updateLastModified,
      fromObj: fromObj,
      toObj: toObj,
    );
  }

  HivePropDefault<List<T>> listProperty<T extends Object>(
    String key, {
    List<T> defaultValue = const [],
    bool updateLastModified = StoreDefaults.defaultUpdateLastUpdateTs,
    StoreFromObj<List<T>>? fromObj,
    StoreToObj<List<T>>? toObj,
  }) {
    return HivePropDefault<List<T>>(
      this,
      key,
      defaultValue,
      updateLastUpdateTsOnSetProp: updateLastModified,
      fromObj: fromObj ?? (obj) => List<T>.from(obj as Iterable),
      toObj: toObj,
    );
  }
}

/// A property of the [HiveStore].
class HiveProp<T extends Object> extends StoreProp<T> {
  @override
  final HiveStore store;

  HiveProp(
    this.store,
    super.key, {
    super.updateLastUpdateTsOnSetProp,
    super.fromObj,
    super.toObj,
  });

  /// {@template hive_store_fn_backward_compatibility}
  /// It's preserved for backward compatibility.
  /// {@endtemplate}
  T? fetch() => get();

  /// {@macro hive_store_fn_backward_compatibility}
  void put(T value) => set(value);

  void delete() => remove();

  @override
  ValueListenable<T?> listenable() {
    return HivePropListenable<T>(this, key);
  }
}

final class HivePropDefault<T extends Object> extends StorePropDefault<T> implements HiveProp<T> {
  @override
  final HiveStore store;

  HivePropDefault(
    this.store,
    super.key,
    super.defaultValue, {
    super.updateLastUpdateTsOnSetProp,
    super.fromObj,
    super.toObj,
  });

  @override
  ValueListenable<T> listenable() {
    return HivePropDefaultListenable<T>(this, key, defaultValue);
  }

  @override
  T fetch() => get();

  @override
  void put(T value) => set(value);

  @override
  void delete() => remove();
}

class HivePropListenable<T extends Object> extends ValueListenable<T?> {
  HivePropListenable(this.prop, this.key);

  final HiveProp<T> prop;
  final String key;

  final List<VoidCallback> _listeners = [];
  StreamSubscription<BoxEvent>? _subscription;

  @override
  void addListener(VoidCallback listener) {
    _subscription ??= prop.store.box.watch().listen((event) {
      if (key == event.key) {
        for (var listener in _listeners) {
          listener();
        }
      }
    });

    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  @override
  T? get value => prop.get();
}

class HivePropDefaultListenable<T extends Object> extends ValueListenable<T> {
  HivePropDefaultListenable(this.prop, this.key, this.defaultValue);

  final HivePropDefault<T> prop;
  final String key;
  T defaultValue;

  final List<VoidCallback> _listeners = [];
  StreamSubscription<BoxEvent>? _subscription;

  @override
  void addListener(VoidCallback listener) {
    _subscription ??= prop.store.box.watch().listen((event) {
      if (key == event.key) {
        for (var listener in _listeners) {
          listener();
        }
      }
    });

    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  @override
  T get value => prop.get();
}

extension _HiveEnc on HiveStore {
  /// The cipher of the [HiveStore].
  static HiveAesCipher? _cipher;

  static const _hiveEncKey = 'hive_key';

  /// The encryption key of the [HiveStore].
  static Future<String?> get _encryptionKey async {
    final secureStoreHiveKey = await SecureStoreProps.hivePwd.read();
    if (secureStoreHiveKey != null) return secureStoreHiveKey;
    final hiveKey = PrefStore.shared.get<String>(_hiveEncKey) ?? PrefStore.shared.get<String>('flutter.$_hiveEncKey');
    if (hiveKey != null) {
      SecureStoreProps.hivePwd.write(hiveKey);
    }
    return hiveKey;
  }

  /// Initialize the [SecureStore].
  static Future<void> _initCipher() async {
    final encryptionKeyString = await _encryptionKey;
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      await SecureStoreProps.hivePwd.write(base64UrlEncode(key));
    }
    final key = await _encryptionKey;
    if (key == null) {
      throw Exception('Failed to init SecureStore');
    }
    final encryptionKeyUint8List = base64Url.decode(key);
    _cipher = HiveAesCipher(encryptionKeyUint8List);
  }
}
