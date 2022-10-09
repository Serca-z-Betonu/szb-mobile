// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dose _$DoseFromJson(Map<String, dynamic> json) => Dose(
      json['drug_name'] as String,
      (json['expected_daily_dosage'] as num).toDouble(),
    );

Map<String, dynamic> _$DoseToJson(Dose instance) => <String, dynamic>{
      'drug_name': instance.name,
      'expected_daily_dosage': instance.amount,
    };
