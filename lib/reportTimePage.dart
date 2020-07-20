// Define a custom Form widget.
import 'package:Timereporter/syncUtils.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/foundation.dart';

import 'constants.dart';
import 'hooks/useSharedPrefs.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'reportTimePage.g.dart';

setPlans(weeklyData) {}

@hwidget
Widget reportRow(String day) {
  final plans = useSharedPrefs<Map<String, dynamic>>(StorageKeys.plans);
  if (plans.value == null) return Container();
  const textStyle = TextStyle(fontWeight: FontWeight.bold);

  final daySplit = day.split(" ");

  final timeCodes = TimeCodes.abbreviations.keys.toList();
  final _isSelected = timeCodes
      .map((e) => plans.value[day] == TimeCodes.abbreviations[e])
      .toList();

  return Card(
    child: ListTile(
      title: Text(daySplit[0]),
      subtitle: Text(daySplit[1]),
      trailing: ToggleButtons(
        borderWidth: 0,
        textStyle: textStyle,
        children: timeCodes.map((e) => Text(e)).toList(),
        onPressed: (int index) {
          // Set current day to the selected timeCode value
          plans.value = plans.value.map(
            (key, value) => key == day
                ? MapEntry(key, TimeCodes.abbreviations[timeCodes[index]])
                : MapEntry(key, value),
          );
        },
        isSelected: _isSelected,
      ),
    ),
  );
}

@hwidget
Widget reportTimePage(BuildContext context) {
  final ValueNotifier<Map<String, dynamic>> plans =
      useSharedPrefs(StorageKeys.plans);

  final _refreshController =
      useMemoized(() => RefreshController(initialRefresh: false));

  final days = plans.value?.keys?.toList();

  if (days == null) {
    return Container();
  }

  // Build a Form widget using the _formKey created above.
  return SmartRefresher(
    controller: _refreshController,
    onRefresh: () async {
      final success = await syncWeeklyData();
      if (success)
        _refreshController.refreshCompleted();
      else
        _refreshController.refreshFailed();
    },
    child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: days.length,
        itemBuilder: (BuildContext context, int index) {
          return ReportRow(days[index]);
        }),
  );
}
