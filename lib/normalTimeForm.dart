// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'hooks/useAutoReporter.dart';
import 'hooks/useSecureStorage.dart';
import 'constants.dart';
import 'hooks/usePersistentTextEditingController.dart';
import 'secureFormTextField.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'hooks/useSharedPrefs.dart';

import 'services/timereport-api.dart';

part 'normalTimeForm.g.dart';

@hwidget
Widget normalTimeForm(BuildContext context) {
  final _formKey = useMemoized(() => GlobalKey<FormState>());
  final autoTimeReport = useSharedPrefs(autoTimeReportKey, false);
  final timesheetIsReady = useSharedPrefs(timesheetIsReadyKey, false);
  final autoReport = useAutoReporter(context);

  final username =
      usePersistentTextEditingController(usernameKey, useSharedPrefs);
  final password =
      usePersistentTextEditingController(passwordKey, useSecureStorage);
  final workOrder =
      usePersistentTextEditingController(workOrderKey, useSharedPrefs);
  final activity =
      usePersistentTextEditingController(activityKey, useSharedPrefs);
  final hoursPerDay =
      usePersistentTextEditingController(hoursPerDayKey, useSharedPrefs);

  sendTimeReportNow() async {
    if (_formKey.currentState.validate()) {
      final response = await sendNormalTimeReport(
          username.text,
          password.text,
          workOrder.text,
          activity.text,
          hoursPerDay.text,
          timesheetIsReady.value);
      if (response.statusCode == 200)
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Success!')));
      else
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error!')));
    }
  }

  _clearData() async {
    _formKey.currentState.reset();
    username.text = "";
    password.text = "";
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
            SecureTextFormField(
              textController: username,
              errorMessage: 'Please enter your email address',
              hintText: 'Your short netlight email',
              labelText: 'Netlight email',
              icon: Icons.email,
              keyBoardType: TextInputType.emailAddress,
            ),
            SecureTextFormField(
              textController: password,
              errorMessage: 'Please enter your password',
              hintText: 'Your netlight password',
              labelText: 'Netlight password',
              icon: Icons.lock,
              keyBoardType: TextInputType.emailAddress,
              obscureText: true,
            ),
            SecureTextFormField(
              textController: workOrder,
              errorMessage: 'Please enter a Work order',
              hintText: 'The description text of a Work order',
              labelText: 'Work order',
              icon: Icons.work,
              keyBoardType: TextInputType.text,
            ),
            SecureTextFormField(
              textController: activity,
              errorMessage: 'Please enter an Activity',
              hintText: 'The description text of an Activity',
              labelText: 'Activity',
              icon: Icons.local_activity,
              keyBoardType: TextInputType.text,
            ),
            SecureTextFormField(
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
                  child: Text('Send timereport now'),
                ),
                RaisedButton(
                  color: Colors.red,
                  onPressed: _clearData,
                  child: Text('Clear form'),
                )
              ],
            ),
          ])));
}
