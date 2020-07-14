// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportTimePage.dart';

// **************************************************************************
// FunctionalWidgetGenerator
// **************************************************************************

class ReportRow extends HookWidget {
  const ReportRow(this.day, {Key key}) : super(key: key);

  final String day;

  @override
  Widget build(BuildContext _context) => reportRow(day);
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('day', day));
  }
}

class ReportTimePage extends HookWidget {
  const ReportTimePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _context) => reportTimePage(_context);
}
