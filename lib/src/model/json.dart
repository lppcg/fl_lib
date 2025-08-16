/// Function that creates a [T] from a JSON map.
typedef JsonFromJson<T> = T Function(Map<String, dynamic> json);

/// Function that converts a [T] to a JSON map.
typedef JsonToJson<T> = Map<String, dynamic> Function(T object);
