// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'hooks/useSharedPrefs.dart';

part 'reportTimePage.g.dart';

@hwidget
Widget reportRow(String day) {
  final plans = useSharedPrefs<Map<String, dynamic>>(StorageKeys.plans);

  const textStyle = TextStyle(fontWeight: FontWeight.bold);

  final daySplit = day.split(" ");

  final timeCodes = TimeCodes.abbreviations.keys.toList();
  final _isSelected = useSharedPrefs<List<dynamic>>("reportRow $day isSelected",
      initialValue: [true, false, false]);

  return Card(
    child: ListTile(
      title: Text(daySplit[0]),
      subtitle: Text(daySplit[1]),
      trailing: ToggleButtons(
        borderWidth: 0,
        textStyle: textStyle,
        children: timeCodes.map((e) => Text(e)).toList(),
        onPressed: (int index) {
          _isSelected.value = _isSelected.value
              .asMap()
              .entries
              .map((e) => e.key == index)
              .toList();

          // Set current day to the selected timeCode value
          plans.value = plans.value.map(
            (key, value) => key == day
                ? MapEntry(key, TimeCodes.abbreviations[timeCodes[index]])
                : MapEntry(key, value),
          );
        },
        isSelected: _isSelected.value.cast<bool>(),
      ),
    ),
  );
}

@hwidget
Widget reportTimePage(BuildContext context) {
  final ValueNotifier<Map<String, dynamic>> plans =
      useSharedPrefs(StorageKeys.plans);

  final days = plans.value?.keys?.toList();

  if (days == null) {
    return Container();
  }

  // Build a Form widget using the _formKey created above.
  return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: days.length,
      itemBuilder: (BuildContext context, int index) {
        return ReportRow(days[index]);
      });
}
