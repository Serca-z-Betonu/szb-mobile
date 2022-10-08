// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      json['name'] as String,
      DateTime.parse(json['time'] as String),
      Duration(microseconds: json['duration'] as int),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'name': instance.name,
      'time': instance.time.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
    };
