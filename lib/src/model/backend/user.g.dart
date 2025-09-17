// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  createdTime: json['create_time'] as String,
  updatedTime: json['update_time'] as String,
  name: json['name'] as String,
  group: json['group'] as String,
  avatar: json['avatar'] as String?,
  oauth: json['oauth'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'create_time': instance.createdTime,
  'update_time': instance.updatedTime,
  'name': instance.name,
  'group': instance.group,
  'avatar': instance.avatar,
  'oauth': instance.oauth,
};
