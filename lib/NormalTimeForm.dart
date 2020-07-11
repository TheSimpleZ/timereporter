// Define a custom Form widget.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timereporter/hooks/useSecureStorage.dart';
import 'package:timereporter/notifications.dart';
import 'hooks/usePersistentTextEditingController.dart';
import 'secureFormTextField.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'hooks/useSharedPrefs.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

part 'NormalTimeForm.g.dart';

const portName = "BackgroundSignal";

const usernameKey = "username";
const passwordKey = "password";
const workOrderKey = "workOrder";
const activityKey = "activity";
const hoursPerDayKey = "hoursPerDay";
const autoTimeReportKey = "autoTimeReport";
const timesheetIsReadyKey = "timesheetIsReady";

extension on DateTime {
  DateTime next(int day) {
    return this.add(
      Duration(
        days: (day - this.weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}

Future<http.Response> sendTimeReport(String username, String password,
    String workOrder, String activity, String hoursPerDay, bool ready) async {
  var url = 'https://timereporter-api.herokuapp.com/';
  return http.post(url, body: {
    'username': username,
    'password': password,
    'workOrder': workOrder,
    'activity': activity,
    'timeCode': 'Normal time',
    'hoursPerDay': hoursPerDay,
    'ready': ready.toString(),
    'dryRun': "true"
  });
}

Future<void> backgroundJob() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  getItem(key) => jsonDecode(sharedPrefs.getString(key));

  final username = getItem(usernameKey);
  final workOrder = getItem(workOrderKey);
  final activity = getItem(activityKey);
  final hoursPerDay = getItem(hoursPerDayKey);
  final timesheetIsReady = getItem(timesheetIsReadyKey);

  final storage = FlutterSecureStorage();
  final password = jsonDecode(await storage.read(key: passwordKey));

  await sendTimeReport(
      username, password, workOrder, activity, hoursPerDay, timesheetIsReady);
}

@hwidget
Widget normalTimeForm(BuildContext context) {
  final _formKey = useMemoized(() => GlobalKey<FormState>());
  final autoTimeReport = useSharedPrefs(autoTimeReportKey, false);
  final timesheetIsReady = useSharedPrefs(timesheetIsReadyKey, false);

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
    final response = await sendTimeReport(
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

  useEffect(() {
    AndroidAlarmManager.initialize();
    return null;
  }, []);

  _clearData() async {
    _formKey.currentState.reset();
    username.text = "";
    password.text = "";
    workOrder.text = "";
    activity.text = "";
    hoursPerDay.text = "";
    autoTimeReport.value = false;
    timesheetIsReady.value = false;

    notify();
  }

  toggleAutoSwitch(newValue) async {
    if (newValue) {
      final startTime = DateTime.now().add(const Duration(minutes: 1));
      AndroidAlarmManager.periodic(
        const Duration(days: 7),
        0,
        backgroundJob,
        startAt: startTime,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );
    } else {
      AndroidAlarmManager.cancel(0);
    }

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
