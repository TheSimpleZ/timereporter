// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WeeklyData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeeklyData _$WeeklyDataFromJson(Map<String, dynamic> json) {
  return WeeklyData(
    (json['businessDays'] as List)?.map((e) => e as String)?.toList(),
    (json['workOrders'] as List)?.map((e) => e as String)?.toList(),
    (json['hoursPerDay'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$WeeklyDataToJson(WeeklyData instance) =>
    <String, dynamic>{
      'businessDays': instance.businessDays,
      'workOrders': instance.workOrders,
      'hoursPerDay': instance.hoursPerDay,
    };
