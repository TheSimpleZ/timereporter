// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeSheetState.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSheetState _$TimeSheetStateFromJson(Map<String, dynamic> json) {
  return TimeSheetState(
    (json['bussinessDays'] as List).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$TimeSheetStateToJson(TimeSheetState instance) =>
    <String, dynamic>{
      'bussinessDays': instance.bussinessDays,
    };
