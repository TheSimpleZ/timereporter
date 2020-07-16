import 'package:json_annotation/json_annotation.dart';

part 'WeeklyData.g.dart';

@JsonSerializable()
class WeeklyData {
  final List<String> businessDays;
  final List<String> workOrders;
  final double hoursPerDay;

  WeeklyData(this.businessDays, this.workOrders, this.hoursPerDay);

  static WeeklyData fromJson(Map<String, dynamic> json) =>
      _$WeeklyDataFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklyDataToJson(this);
}
