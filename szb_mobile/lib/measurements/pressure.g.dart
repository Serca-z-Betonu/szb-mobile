// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pressure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pressure _$PressureFromJson(Map<String, dynamic> json) => Pressure(
      json['low'] as int,
      json['high'] as int,
      DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$PressureToJson(Pressure instance) => <String, dynamic>{
      'low': instance.low,
      'high': instance.high,
      'time': instance.time.toIso8601String(),
    };
