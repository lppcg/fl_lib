// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'window_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WindowState _$WindowStateFromJson(Map<String, dynamic> json) => WindowState(
  const _SizeJsonConverter().fromJson(json['size'] as Map<String, dynamic>),
  const _OffsetJsonConverter().fromJson(
    json['position'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WindowStateToJson(WindowState instance) =>
    <String, dynamic>{
      'size': const _SizeJsonConverter().toJson(instance.size),
      'position': const _OffsetJsonConverter().toJson(instance.position),
    };
