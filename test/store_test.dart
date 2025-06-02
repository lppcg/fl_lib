import 'package:fl_lib/fl_lib.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MockStore', () {
    late MockStore store;

    setUp(() {
      store = MockStore(
        updateLastUpdateTsOnSet: true,
        updateLastUpdateTsOnRemove: true,
        updateLastUpdateTsOnClear: true,
      );
      // Ensure lastUpdateTsKey is initialized as a map for tests that rely on it.
      // The MockStore constructor or Store superclass might do this if flags are true,
      // but explicit initialization here makes tests more robust against MockStore's internal implementation details.
      store.set(store.lastUpdateTsKey, <String, int>{});
    });

    test('set and get basic types', () {
      expect(store.set<String>('stringKey', 'stringValue'), isTrue);
      expect(store.get<String>('stringKey'), 'stringValue');

      expect(store.set<int>('intKey', 123), isTrue);
      expect(store.get<int>('intKey'), 123);

      expect(store.set<double>('doubleKey', 123.456), isTrue);
      expect(store.get<double>('doubleKey'), 123.456);

      expect(store.set<bool>('boolKey', true), isTrue);
      expect(store.get<bool>('boolKey'), true);
    });

    test('get returns null for non-existent key', () {
      expect(store.get<String>('nonExistentKey'), isNull);
    });

    test('get with fromStr', () {
      store.set<String>('parsableKey', '123');
      expect(store.get<int>('parsableKey', fromObj: (s) => int.tryParse(s as String)), 123);

      store.set<String>('nonParsableKey', 'abc');
      expect(store.get<int>('nonParsableKey', fromObj: (s) => int.tryParse(s as String)), isNull);
    });

    test('get with type mismatch and no fromStr', () {
      store.set<int>('intKeyForStringGet', 123);
      expect(store.get<String>('intKeyForStringGet'), '123');

      store.set<String>('stringKeyForIntGet', 'stringValue');
      expect(store.get<int>('stringKeyForIntGet'), isNull);
    });

    test('set with toStr', () {
      final complexObject = {'a': 1, 'b': 'test'};
      expect(
          store.set<Map<String, dynamic>>(
            'complexKey',
            complexObject,
            toObj: (val) => val.toString(),
          ),
          isTrue);
      expect(store.get<String>('complexKey'), complexObject.toString());
      expect(store.get<Map<String, dynamic>>('complexKey'), isNull);
    });

    test('set with toStr returning null', () {
      expect(store.set<String>('key', 'value', toObj: (val) => null), isFalse);
      expect(store.get<String>('key'), isNull);
    });

    test('keys', () {
      store.set<String>('key1', 'value1');
      store.set<String>('key2', 'value2');
      // lastUpdateTsKey is an internal key, set directly for testing its exclusion/inclusion
      store.set<Map<String, int>>(store.lastUpdateTsKey, {'internal_ts_key': 123});

      expect(store.keys(), equals({'key1', 'key2'}));
      expect(store.keys(includeInternalKeys: true), equals({'key1', 'key2', store.lastUpdateTsKey}));
    });

    test('remove', () {
      store.set<String>('keyToRemove', 'value');
      expect(store.remove('keyToRemove'), isTrue);
      expect(store.get<String>('keyToRemove'), isNull);
      expect(store.remove('nonExistentKey'), isTrue);
    });

    test('clear', () async {
      store.set<String>('key1', 'value1');
      store.set<String>('key2', 'value2');
      store.updateLastUpdateTs(key: 'key1');
      final tsKey1Before = store.lastUpdateTs!['key1'];
      store.updateLastUpdateTs(key: 'key2');
      final tsKey2Before = store.lastUpdateTs!['key2'];

      final initialTs = store.lastUpdateTs;
      expect(initialTs, isNotNull);
      expect(initialTs!.containsKey('key1'), isTrue);
      expect(initialTs.containsKey('key2'), isTrue);

      await Future.delayed(const Duration(milliseconds: 10)); // Ensure lastUpdateTs is updated after clear
      expect(store.clear(), isTrue);
      expect(store.keys().isEmpty, isTrue);
      // lastUpdateTsKey should remain after clear if MockStore preserves it
      expect(store.keys(includeInternalKeys: true), equals({store.lastUpdateTsKey}));

      final tsAfterClear = store.lastUpdateTs;
      expect(tsAfterClear, isNotNull);
      expect(tsAfterClear!.containsKey('key1'), isTrue);
      expect(tsAfterClear.containsKey('key2'), isTrue);

      expect(tsAfterClear['key1'], greaterThan(tsKey1Before!));
      expect(tsAfterClear['key2'], greaterThan(tsKey2Before!));
    });

    test('updateLastUpdateTs and lastUpdateTs', () {
      // store.set(store.lastUpdateTsKey, <String, int>{}); // Already in global setUp
      const key1 = 'tsKey1';
      const key2 = 'tsKey2';

      var ts = store.lastUpdateTs;
      expect(ts, isNotNull);
      // expect(ts, isEmpty); // Might not be empty if setUp initialized something

      final ts1 = DateTimeX.timestamp;
      store.updateLastUpdateTs(key: key1, ts: ts1);
      ts = store.lastUpdateTs;
      expect(ts![key1], ts1);

      final ts2 = DateTimeX.timestamp + 10;
      store.updateLastUpdateTs(key: key2, ts: ts2);
      ts = store.lastUpdateTs;
      expect(ts![key1], ts1);
      expect(ts[key2], ts2);

      final tsClear = DateTimeX.timestamp + 20;
      store.updateLastUpdateTs(key: null, ts: tsClear);
      ts = store.lastUpdateTs;
      expect(ts![key1], tsClear);
      expect(ts[key2], tsClear);
    });

    test('set updates lastUpdateTs if configured', () async {
      // store.set(store.lastUpdateTsKey, <String, int>{}); // Already in global setUp
      const key = 'setTsKey';
      const val = 'value';

      store.set<String>(key, val, updateLastUpdateTsOnSet: true);
      await Future.delayed(const Duration(milliseconds: 1));
      final tsAfterSet = store.lastUpdateTs![key];
      expect(tsAfterSet, isNotNull);

      await Future.delayed(const Duration(milliseconds: 1));
      store.set<String>(key, 'newValue', updateLastUpdateTsOnSet: true);
      final tsAfterSecondSet = store.lastUpdateTs![key];
      expect(tsAfterSecondSet, greaterThan(tsAfterSet!));

      store.set<String>('anotherKey', 'anotherValue', updateLastUpdateTsOnSet: false);
      expect(store.lastUpdateTs!['anotherKey'], isNull);
    });

    test('remove updates lastUpdateTs if configured and key existed', () async {
      // store.set(store.lastUpdateTsKey, <String, int>{}); // Already in global setUp
      const key = 'removeTsKey';
      store.set<String>(key, 'value');
      final tsAfterSet = store.lastUpdateTs![key];
      expect(tsAfterSet, isNotNull);

      await Future.delayed(const Duration(milliseconds: 1));
      store.remove(key, updateLastUpdateTsOnRemove: true);
      final tsAfterRemove = store.lastUpdateTs![key];
      expect(tsAfterRemove, isNotNull);
      expect(tsAfterRemove, greaterThan(tsAfterSet!));

      const nonExistentKey = 'nonExistentForTs';
      final tsBeforeNonExistentRemove = store.lastUpdateTs![nonExistentKey];
      store.remove(nonExistentKey, updateLastUpdateTsOnRemove: true);
      final tsAfterNonExistentRemove = store.lastUpdateTs![nonExistentKey];
      expect(tsAfterNonExistentRemove, tsBeforeNonExistentRemove);

      const keyNoUpdate = 'keyNoUpdateOnRemove';
      store.set<String>(keyNoUpdate, 'value');
      final tsAfterSetNoUpdate = store.lastUpdateTs![keyNoUpdate];
      await Future.delayed(const Duration(milliseconds: 1));
      store.remove(keyNoUpdate, updateLastUpdateTsOnRemove: false);
      final tsAfterRemoveNoUpdate = store.lastUpdateTs![keyNoUpdate];
      expect(tsAfterRemoveNoUpdate, tsAfterSetNoUpdate);
    });

    test('getAll, getAllMap, getAllMapTyped, setAll work as expected', () async {
      final data = <String, String>{
        'a': 'apple',
        'b': 'banana',
        'c': 'cherry',
      };
      store.setAll(data);

      expect(store.get<String>('a'), 'apple');
      expect(store.get<String>('b'), 'banana');
      expect(store.get<String>('c'), 'cherry');

      // Test getAllMapTyped
      final allMapTypedResult = store.getAllMapTyped<String>();
      allMapTypedResult.removeWhere((key, value) => store.isInternalKey(key));
      expect(allMapTypedResult, equals(data));

      // Test getAllMap
      final allMapResult = store.getAllMap();
      allMapResult.removeWhere((key, value) => store.isInternalKey(key));
      final stringMap = allMapResult.map((k, v) => MapEntry(k, v.toString()));
      expect(stringMap, equals(data));

      // Test getAll (returns a Stream of (String, Object?) records)
      final streamData = <String, String>{};
      await for (final entry in store.getAll()) {
        if (!store.isInternalKey(entry.$1)) {
          streamData[entry.$1] = entry.$2 as String;
        }
      }
      expect(streamData, equals(data));
    });
  });

  group('MockStoreProp', () {
    late MockStore store;
    late MockStoreProp<String> prop;
    const testKey = 'testPropKey';

    setUp(() {
      store = MockStore(updateLastUpdateTsOnSet: true);
      store.set(store.lastUpdateTsKey, <String, int>{}); // Ensure TS map is init
      prop = MockStoreProp<String>(store, testKey);
    });

    test('get uses store.get', () {
      store.set<String>(testKey, 'propValue');
      expect(prop.get(), 'propValue');
    });

    test('set uses store.set', () {
      prop.set('newPropValue');
      expect(store.get<String>(testKey), 'newPropValue');
      expect(prop.get(), 'newPropValue');
    });

    test('set updates lastUpdateTs if configured on prop', () async {
      final propUpdateTs = MockStoreProp<String>(store, 'propUpdateTsKey', updateLastUpdateTsOnSetProp: true);
      propUpdateTs.set('initial');
      final ts1 = store.lastUpdateTs!['propUpdateTsKey'];
      expect(ts1, isNotNull);

      await Future.delayed(const Duration(milliseconds: 1));
      propUpdateTs.set('updated');
      final ts2 = store.lastUpdateTs!['propUpdateTsKey'];
      expect(ts2, greaterThan(ts1!));
    });

    test('set does not update lastUpdateTs if configured false on prop', () async {
      final propNoUpdateTs = MockStoreProp<String>(store, 'propNoUpdateTsKey', updateLastUpdateTsOnSetProp: false);
      propNoUpdateTs.set('initial');
      final ts1 = store.lastUpdateTs!['propNoUpdateTsKey'];
      expect(ts1, isNull);

      await Future.delayed(const Duration(milliseconds: 1));
      propNoUpdateTs.set('updated');
      final ts2 = store.lastUpdateTs!['propNoUpdateTsKey'];
      expect(ts2, isNull);
    });

    test('remove uses store.remove', () {
      store.set<String>(testKey, 'valueToRemove');
      prop.remove();
      expect(store.get<String>(testKey), isNull);
    });

    test('listenable returns a ValueNotifier with current value', () {
      store.set<String>(testKey, 'listenableValue');
      final listener = prop.listenable();
      expect(listener.value, 'listenableValue');
    });
  });

  group('MockStorePropDefault', () {
    late MockStore store;
    late MockStorePropDefault<String> propDefault;
    const testKey = 'testPropDefaultKey';
    const defaultValue = 'defaultValue';

    setUp(() {
      store = MockStore(updateLastUpdateTsOnSet: true);
      store.set(store.lastUpdateTsKey, <String, int>{}); // Ensure TS map is init
      propDefault = MockStorePropDefault<String>(store, testKey, defaultValue);
    });

    test('get returns value from store if exists', () {
      store.set<String>(testKey, 'actualValue');
      expect(propDefault.get(), 'actualValue');
    });

    test('get returns defaultValue if value not in store', () {
      expect(propDefault.get(), defaultValue);
    });

    test('set uses store.set', () {
      propDefault.set('newActualValue');
      expect(store.get<String>(testKey), 'newActualValue');
      expect(propDefault.get(), 'newActualValue');
    });

    test('set updates lastUpdateTs if configured on prop', () async {
      final propDefUpdateTs = MockStorePropDefault<String>(store, 'propDefUpdateTsKey', 'def', updateLastUpdateTsOnSetProp: true);
      propDefUpdateTs.set('initial');
      final ts1 = store.lastUpdateTs!['propDefUpdateTsKey'];
      expect(ts1, isNotNull);

      await Future.delayed(const Duration(milliseconds: 1));
      propDefUpdateTs.set('updated');
      final ts2 = store.lastUpdateTs!['propDefUpdateTsKey'];
      expect(ts2, greaterThan(ts1!));
    });

    test('listenable returns a ValueNotifier with current value or default', () {
      final listener1 = propDefault.listenable();
      expect(listener1.value, defaultValue);

      store.set<String>(testKey, 'specificValue');
      final propDefaultWithValue = MockStorePropDefault<String>(store, testKey, defaultValue);
      final listener2 = propDefaultWithValue.listenable();
      expect(listener2.value, 'specificValue');
    });
  });
}
