// Define a custom Form widget.
import 'package:Timereporter/hooks/useSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'hooks/useAutoReporter.dart';
import 'hooks/useSecureStorage.dart';
import 'constants.dart';
import 'hooks/usePersistentTextEditingController.dart';
import 'customTextFormField.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'hooks/useSharedPrefs.dart';

import 'services/timereport-api.dart';

part 'defaultSettingsForm.g.dart';

@hwidget
Widget defaultSettingsForm(BuildContext context) {
  final _formKey = useMemoized(() => GlobalKey<FormState>());
  final autoTimeReport = useSharedPrefs(autoTimeReportKey, initialValue: false);
  final timesheetIsReady =
      useSharedPrefs(timesheetIsReadyKey, initialValue: false);
  final autoReport = useAutoReporter(context);
  final snackBar = useSnackBar(context);

  final username = useSharedPrefs(usernameKey);
  final password = useSecureStorage(passwordKey);
  final workOrder =
      usePersistentTextEditingController(workOrderKey, useSharedPrefs);
  final activity =
      usePersistentTextEditingController(activityKey, useSharedPrefs);
  final hoursPerDay =
      usePersistentTextEditingController(hoursPerDayKey, useSharedPrefs);

  sendTimeReportNow() async {
    if (_formKey.currentState.validate()) {
      final response = await sendNormalTimeReport(
          username.value,
          password.value,
          workOrder.text,
          activity.text,
          hoursPerDay.text,
          timesheetIsReady.value);
      if (response.statusCode == 200)
        snackBar.showText('Success!');
      else
        snackBar.showText('Error!');
    }
  }

  _clearData() async {
    _formKey.currentState.reset();
    workOrder.text = "";
    activity.text = "";
    hoursPerDay.text = "";
    autoTimeReport.value = false;
    timesheetIsReady.value = false;
  }

  toggleAutoSwitch(newValue) async {
    autoReport(newValue);
    autoTimeReport.value = newValue;
  }

  // Build a Form widget using the _formKey created above.
  return Form(
      key: _formKey,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            // Add TextFormFields and RaisedButton here.
            CustomTextFormField(
              textController: workOrder,
              errorMessage: 'Please enter a Work order',
              hintText: 'The description text of a Work order',
              labelText: 'Work order',
              icon: Icons.work,
              keyBoardType: TextInputType.text,
            ),
            CustomTextFormField(
              textController: activity,
              errorMessage: 'Please enter an Activity',
              hintText: 'The description text of an Activity',
              labelText: 'Activity',
              icon: Icons.local_activity,
              keyBoardType: TextInputType.text,
            ),
            CustomTextFormField(
              textController: hoursPerDay,
              errorMessage: 'Please enter the amount of hours you work per day',
              hintText: 'The amount of hours you work per day',
              labelText: 'Hours per day',
              icon: Icons.access_time,
              keyBoardType: TextInputType.number,
            ),
            SwitchListTile(
              title: const Text('Timesheet is ready'),
              secondary: const Icon(Icons.check),
              value: timesheetIsReady.value,
              onChanged: (newVal) => timesheetIsReady.value = newVal,
            ),
            SwitchListTile(
              title: const Text('Auto time report'),
              secondary: const Icon(Icons.autorenew),
              value: autoTimeReport.value,
              onChanged: toggleAutoSwitch,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: sendTimeReportNow,
                  child: Text('Send report now'),
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: _clearData,
                  child: Text('Log out & clear form'),
                )
              ],
            ),
          ])));
}
