// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      json['description'] as String,
      DateTime.parse(json['end_timestamp'] as String),
      Duration(microseconds: json['duration_us'] as int),
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'description': instance.name,
      'end_timestamp': instance.time.toIso8601String(),
      'duration_us': instance.duration.inMicroseconds,
    };
