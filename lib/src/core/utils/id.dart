/// Lightweight snowflake-like ID generator (timestamp + sequence).
abstract final class SnowflakeLite {
  static int _lastMs = 0;
  static int _seq = 0; // 12 bit No.

  /// Generates a unique ID using a simple snowflake algorithm.
  static String generate() {
    var now = DateTime.now().millisecondsSinceEpoch;

    if (now == _lastMs) {
      _seq = (_seq + 1) & 0xFFF; // 0-4095
      if (_seq == 0) {
        // Wait for the next millisecond
        while ((now = DateTime.now().millisecondsSinceEpoch) == _lastMs) {}
      }
    } else {
      _seq = 0;
      _lastMs = now;
    }

    // 54 bit ts + 12 bit No. = 66 bit
    final id = (now << 12) | _seq;
    return id.toRadixString(36);
  }

  /// Decodes a SnowflakeLite ID back to its timestamp and sequence number.
  static (DateTime, int)? decode(String id) {
    final intId = int.tryParse(id, radix: 36);
    if (intId == null) return null;
    final timestamp = DateTime.fromMillisecondsSinceEpoch(intId >> 12);
    final sequence = intId & 0xFFF;
    return (timestamp, sequence);
  }
}

/// Generate a short ID based on tiemstamp and random number.
///
/// Impl: toCustomString(timestamp + random number)
///   - toCustomString: convert to 64-bit string (a-Z, 0-9, -, +)
abstract final class ShortId {
  static const _chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-+';
  static const int _radix = _chars.length;
  static final Map<String, int> _charIndex = {
    for (var i = 0; i < _radix; i++) _chars[i]: i,
  };

  /// Converts a non-negative integer to a custom-base string.
  static String toCustomString(int id) {
    if (id <= 0) return '0';

    final buffer = StringBuffer();
    while (id > 0) {
      buffer.write(_chars[id % _radix]);
      id ~/= _radix;
    }
    return buffer.toString().split('').reversed.join();
  }

  /// Converts a custom-base string back to an integer.
  static int? fromCustomString(String str) {
    if (str.isEmpty) {
      return null;
    }
    var id = 0;
    for (final ch in str.split('')) {
      final digit = _charIndex[ch];
      if (digit == null) {
        return null; // Invalid character
      }
      id = id * _radix + digit;
    }
    return id;
  }

  static int _lastTs = 0;
  static int _seq = 0; // 12 bit No.

  /// Generates a short ID based on the current timestamp and a random number.
  static String generate() {
    var now = DateTime.now().millisecondsSinceEpoch;

    if (now == _lastTs) {
      _seq = (_seq + 1) & 0xFFF; // 0-4095
      if (_seq == 0) {
        // Wait for the next millisecond
        while ((now = DateTime.now().millisecondsSinceEpoch) == _lastTs) {}
      }
    } else {
      _seq = 0;
      _lastTs = now;
    }

    // 54 bit ts + 12 bit No. = 66 bit
    final id = (now << 12) | _seq;
    return toCustomString(id);
  }

  /// Decodes a short ID back to its timestamp and sequence number.
  static (DateTime, int)? decode(String id) {
    final intId = fromCustomString(id);
    if (intId == null) return null;
    final timestamp = DateTime.fromMillisecondsSinceEpoch(intId >> 12);
    final sequence = intId & 0xFFF;
    return (timestamp, sequence);
  }
}
