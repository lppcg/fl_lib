/// Extension methods for [List] to provide additional functionality.
extension ListX<T> on List<T> {
  /// Joins all elements in the list with the given [item] as separator.
  ///
  /// - [item] the separator to insert between elements
  /// - [self] if true, modifies this list; if false, creates a new list
  ///
  /// Example: `[1, 2, 3].joinWith(0)` returns `[1, 0, 2, 0, 3]`
  List<T> joinWith(T item, [bool self = true]) {
    final list = self ? this : List<T>.from(this);
    for (var i = length - 1; i > 0; i--) {
      list.insert(i, item);
    }
    return list;
  }

  /// Combines this list with another list element by element.
  ///
  /// - [other] the list to combine with (must have same or greater length)
  /// - [self] if true, modifies this list; if false, creates a new list
  ///
  /// Each element at index i in this list is replaced with the element
  /// at the same index from [other].
  List<T> combine(List<T> other, [bool self = true]) {
    final list = self ? this : List<T>.from(this);
    for (var i = 0; i < length; i++) {
      list[i] = other[i];
    }
    return list;
  }
}

/// Extension methods for [Iterable] to provide null-safe operations.
extension IterX<T> on Iterable<T> {
  /// Returns the first element, or null if the iterable is empty.
  ///
  /// Safe alternative to [first] that doesn't throw an exception.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns the last element, or null if the iterable is empty.
  ///
  /// Safe alternative to [last] that doesn't throw an exception.
  T? get lastOrNull => isEmpty ? null : last;

  /// Returns the first element that satisfies the [test], or null if none found.
  ///
  /// Safe alternative to [firstWhere] that returns null instead of throwing.
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  /// Returns the last element that satisfies the [test], or null if none found.
  ///
  /// Safe alternative to [lastWhere] that returns null instead of throwing.
  T? lastWhereOrNull(bool Function(T element) test) {
    try {
      return lastWhere(test);
    } catch (_) {
      return null;
    }
  }
}
