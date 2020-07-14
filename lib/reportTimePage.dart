// Define a custom Form widget.
import 'package:Timereporter/timeSheetState.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'hooks/useSharedPrefs.dart';

part 'reportTimePage.g.dart';

@hwidget
Widget reportRow(String day) {
  final _isSelected = useState([true, false, false]);

  const textStyle = TextStyle(fontWeight: FontWeight.bold);

  final daySplit = day.split(" ");

  return Card(
    child: ListTile(
      title: Text(daySplit[0]),
      subtitle: Text(daySplit[1]),
      trailing: ToggleButtons(
        borderWidth: 0,
        textStyle: textStyle,
        children: <Widget>[
          Text(
            "N",
          ),
          Text(
            "HS",
          ),
          Text(
            "V",
          ),
        ],
        onPressed: (int index) {
          _isSelected.value = _isSelected.value
              .asMap()
              .entries
              .map((e) => e.key == index)
              .toList();
        },
        isSelected: _isSelected.value,
      ),
    ),
  );
}

@hwidget
Widget reportTimePage(BuildContext context) {
  final ValueNotifier<TimeSheetState> timesheet =
      useSharedPrefs(timeSheetKey, deserializer: TimeSheetState.fromJson);

  final days = timesheet.value?.bussinessDays;

  if (days == null) {
    return Container();
  }

  final items =
      useMemoized(() => days.map((day) => ReportRow(day)).toList(), [days]);

  // Build a Form widget using the _formKey created above.
  return ListView(padding: const EdgeInsets.all(8), children: items);
}
