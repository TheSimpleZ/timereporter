// Define a custom Form widget.
import 'package:Timereporter/timeSheetState.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'constants.dart';
import 'hooks/useSharedPrefs.dart';

part 'reportTimePage.g.dart';

@hwidget
Widget reportTimePage(BuildContext context) {
  final ValueNotifier<TimeSheetState> timesheet = useSharedPrefs(timeSheetKey);

  final days = timesheet.value.bussinessDays;
  // Build a Form widget using the _formKey created above.
  return ListView(
    padding: const EdgeInsets.all(8),
    children: <Widget>[
      Container(
        height: 50,
        color: Colors.red[600],
        child: const Center(child: Text('Entry A')),
      ),
      Container(
        height: 50,
        color: Colors.red[500],
        child: const Center(child: Text('Entry B')),
      ),
      Container(
        height: 50,
        color: Colors.red[100],
        child: const Center(child: Text('Entry C')),
      ),
    ],
  );
}
