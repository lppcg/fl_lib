part of 'iface.dart';

/// The store of Hive.
///
/// It implements [Store].
class HiveStore extends Store {
  /// The internal hive box for this [Store].
  late final Box box;

  /// The name of the box. Used for the hive box.
  final String boxName;

  /// Constructor.
  HiveStore(this.boxName);

  /// Initialize the [HiveStore].
  Future<void> init() async {
    if (SecureStore.cipher == null) await SecureStore.init();

    final path = switch (Pfs.type) {
      /// The default path of Hive is the HOME dir
      Pfs.linux || Pfs.windows => Paths.doc,
      _ => (await getApplicationDocumentsDirectory()).path,
    };

    final enc = await Hive.openBox(
      '${boxName}_enc',
      path: path,
      encryptionCipher: SecureStore.cipher,
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

  /// A property of the [HiveStore].
  HiveProp<T> property<T extends Object>(
    String key, {
    T? defaultValue,
    bool updateLastModified = true,
  }) {
    return HiveProp<T>(
      this,
      key,
      updateLastUpdateTsOnSetProp: updateLastModified,
    );
  }

  HivePropDefault<T> propertyDefault<T extends Object>(
    String key,
    T defaultValue, {
    bool updateLastModified = StoreDefaults.defaultUpdateLastUpdateTsOnSet,
  }) {
    return HivePropDefault<T>(
      this,
      key,
      defaultValue,
      updateLastUpdateTsOnSetProp: updateLastModified,
    );
  }

  @override
  FutureOr<bool> clear() {
    box.clear();
    return Future.value(true);
  }

  @override
  T? get<T>(String key, {StoreFromStr<T>? fromString}) {
    final val = box.get(key);
    if (val is! T) {
      if (val is String && fromString != null) {
        return fromString(val);
      }
      dprint('HiveStore.get("$key") is: ${val.runtimeType}');
      return null;
    }
    return val;
  }

  @override
  FutureOr<Set<String>> keys() {
    final set_ = <String>{};
    for (final key in box.keys) {
      if (key is String) {
        set_.add(key);
      }
    }
    return Future.value(set_);
  }

  @override
  FutureOr<bool> remove(String key) {
    box.delete(key);
    return Future.value(true);
  }

  @override
  FutureOr<bool> set<T>(String key, T val, {StoreToStr<T>? toString}) {
    final value = toString != null ? toString(val) : val;
    box.put(key, value);
    return Future.value(true);
  }

  @override
  Map<String, Object?> getAllMap({
    bool includeInternalKeys = false,
  }) {
    final map = <String, Object?>{};
    for (final key in box.keys) {
      if (key is String) {
        final val = box.get(key);
        map[key] = val;
      }
    }
    return map;
  }

  /// Generic version of [getAllMap].
  Map<String, T?> getAllMapT<T extends Object>({
    bool includeInternalKeys = false,
  }) {
    final map = <String, T?>{};
    for (final key in box.keys) {
      if (key is String) {
        if (!includeInternalKeys && (key.startsWith(StoreDefaults.prefixKey) || key.startsWith(StoreDefaults.prefixKeyOld))) {
          continue;
        }
        final val = box.get(key);
        if (val is T?) {
          map[key] = val;
        }
      }
    }
    return map;
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
    super.fromStr,
    super.toStr,
  });

  @override
  ValueListenable<T> listenable() {
    return HivePropListenable<T>(store.box, key, null);
  }

  @override
  T? get() {
    final stored = store.box.get(key);
    if (stored is! T) {
      dprint('StoreProperty("$key") is: ${stored.runtimeType}');
      return null;
    }
    return stored;
  }

  /// {@template hive_store_fn_backward_compatibility}
  /// In the previous version, it was named `fetch()`.
  /// {@endtemplate}
  @Deprecated('Use `get()` instead.')
  T? fetch() => get();

  /// {@macro hive_store_fn_backward_compatibility}
  @Deprecated('Use `set()` instead.')
  void put(T value) => set(value);

  
  void delete() => super.remove();
}

final class HivePropDefault<T extends Object> extends StorePropDefault<T> implements HiveProp<T> {
  @override
  final HiveStore store;

  HivePropDefault(
    this.store,
    super.key,
    super.defaultValue, {
    super.updateLastUpdateTsOnSetProp,
    super.fromStr,
    super.toStr,
  });

  @override
  ValueListenable<T> listenable() {
    return HivePropListenable<T>(store.box, key, defaultValue);
  }

  @override
  T get() {
    final stored = store.box.get(key, defaultValue: defaultValue);
    if (stored is! T) {
      dprint('StoreProperty("$key") is: ${stored.runtimeType}');
      return defaultValue;
    }
    return stored;
  }

  @Deprecated('Use `get()` instead.')
  @override
  T fetch() => get();

  @override
  void set(T value) {
    store.box.put(key, value);
  }

  @Deprecated('Use `set()` instead.')
  @override
  void put(T value) => set(value);

  @Deprecated('Use `remove()` instead.')
  @override
  void delete() => super.remove();
}

class HivePropListenable<T> extends ValueListenable<T> {
  HivePropListenable(this.box, this.key, this.defaultValue);

  final Box box;
  final String key;
  T? defaultValue;

  final List<VoidCallback> _listeners = [];
  StreamSubscription? _subscription;

  @override
  void addListener(VoidCallback listener) {
    _subscription ??= box.watch().listen((event) {
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
  T get value {
    final val = box.get(key, defaultValue: defaultValue);
    if (val == null || val is! T) {
      return defaultValue!;
    }
    return val;
  }
}
