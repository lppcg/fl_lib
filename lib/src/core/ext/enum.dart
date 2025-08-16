/// Extensions on `List<T>` to safely access items by index.
extension EnumListX<T> on List<T> {
  /// Returns element at [index], or [defaultValue] if out of range.
  ///
  /// Throws [Exception] if the index is invalid and [defaultValue] is null.
  T fromIndex(int index, [T? defaultValue]) {
    try {
      return this[index];
    } catch (e) {
      if (defaultValue != null) {
        return defaultValue;
      }
      throw Exception('Invalid index: $index');
    }
  }
}
