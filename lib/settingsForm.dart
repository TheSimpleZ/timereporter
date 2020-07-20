// Define a custom Form widget.
import 'package:Timereporter/hooks/useSnackBar.dart';
import 'package:Timereporter/loginGuard.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:intl/intl.dart';
import 'hooks/useAutoReporter.dart';
import 'hooks/useSecureStorage.dart';
import 'constants.dart';
import 'hooks/usePersistentTextEditingController.dart';
import 'customTextFormField.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'hooks/useSharedPrefs.dart';

part 'settingsForm.g.dart';

@hwidget
Widget settingsForm(BuildContext context) {
  final _formKey = useMemoized(() => GlobalKey<FormState>());
  final autoTimeReport =
      useSharedPrefs(StorageKeys.autoTimeReport, initialValue: false);
  final ready = useSharedPrefs(StorageKeys.ready, initialValue: false);
  final autoReporter = useAutoReporter(context);
  final snackBar = useSnackBar(context);

  final username = useSecureStorage(StorageKeys.username);
  final password = useSecureStorage(StorageKeys.password);
  final isLoggedIn =
      useSecureStorage(StorageKeys.isLoggedIn, initialValue: false);
  final workOrder =
      useSharedPrefs<String>(StorageKeys.workOrder, initialValue: null);

  final workOrderList =
      useSharedPrefs(StorageKeys.workOrderList, initialValue: List<dynamic>());

  final hoursPerDay = usePersistentTextEditingController(
      StorageKeys.hoursPerDay, useSharedPrefs);

  toggleAutoSwitch(newValue) async {
    autoReporter.setAutoReport(newValue);
    autoTimeReport.value = newValue;
  }

  sendTimeReportNow() async {
    if (_formKey.currentState.validate()) {
      await autoReporter.sendNow();
      toggleAutoSwitch(false);
      snackBar.showText('Timesheet will be sent soon.');
    }
  }

  _clearDataAndLogout() async {
    // Clear form
    _formKey.currentState.reset();
    workOrder.value = null;

    hoursPerDay.text = "";
    autoTimeReport.value = false;
    ready.value = false;

    // // Logout
    username.value = "";
    password.value = "";
    isLoggedIn.value = false;

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginGuard()));
  }

  // Build a Form widget using the _formKey created above.
  return SingleChildScrollView(
    child: Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: <Widget>[
              // Add TextFormFields and RaisedButton here.
              DropdownButtonFormField<String>(
                hint: Text("Work order"),
                value: workOrder.value,
                icon: Icon(Icons.arrow_downward),
                onChanged: (newValue) {
                  workOrder.value = newValue;
                },
                validator: (value) =>
                    value.isEmpty ? "Please choose a work order" : null,
                items: workOrderList.value
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
              ),
              CustomTextFormField(
                textController: hoursPerDay,
                errorMessage:
                    'Please enter the amount of hours you work per day',
                hintText: 'The amount of hours you work per day',
                labelText: 'Hours per day',
                icon: Icons.access_time,
                keyBoardType: TextInputType.number,
              ),
              SwitchListTile(
                title: const Text('Ready'),
                secondary: const Icon(Icons.check),
                value: ready.value,
                onChanged: (newVal) => ready.value = newVal,
              ),
              SwitchListTile(
                title: const Text("Auto report"),
                subtitle: autoReporter.nextRun != null
                    ? Text("Next run: ${autoReporter.nextRun}")
                    : null,
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
                    onPressed: _clearDataAndLogout,
                    child: Text('Log out & clear form'),
                  )
                ],
              ),
            ]))),
  );
}
