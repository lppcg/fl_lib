import 'package:fl_lib/fl_lib.dart';

/// {@template fllib_err}
/// An abstract class representing an error with a type and an optional message.
/// {@endtemplate}
abstract class Err<T extends Enum> {
  /// The type of the error, represented as an enum.
  final T type;

  /// An optional message providing additional information about the error.
  final String? message;

  /// The solution for the error, if available.
  ///
  /// ```dart
  /// String? get solution => switch (type) {
  ///   ErrType.network => 'Check your internet connection.',
  ///   ErrType.timeout => 'Try again later.',
  /// };
  /// ```
  String? get solution;

  /// {@macro fllib_err}
  const Err({required this.type, this.message});

  @override
  String toString() {
    return '$runtimeType<${type.name.capitalize}>: $message';
  }
}
