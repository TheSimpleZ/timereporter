import 'package:json_annotation/json_annotation.dart';

part 'timeSheetState.g.dart';

@JsonSerializable(nullable: false)
class TimeSheetState {
  final List<String> bussinessDays;

  TimeSheetState(this.bussinessDays);

  static TimeSheetState fromJson(Map<String, dynamic> json) =>
      _$TimeSheetStateFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSheetStateToJson(this);
}
