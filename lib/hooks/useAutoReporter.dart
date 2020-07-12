import 'dart:convert';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../hooks/useSharedPrefs.dart';
import '../notifications.dart';
import '../services/timereport-api.dart';
import '../constants.dart';

extension on DateTime {
  DateTime next(int day) {
    return this.add(
      Duration(
        days: (day - this.weekday) % DateTime.daysPerWeek,
      ),
    );
  }
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

  final response = await sendNormalTimeReport(
      username, password, workOrder, activity, hoursPerDay, timesheetIsReady);

  if (response.statusCode == 200)
    notify("Timereporter", "Successfully reported time for this week!");
  else
    notify("Timereporter", "Failed to report time for this week!");
}

Function(bool) useAutoReporter([BuildContext context]) {
  final isRunning = useSharedPrefs("usePeriodicBackgroundJob.isRunning", false);
  const id = 0;
  useEffect(() {
    AndroidAlarmManager.initialize();
    return null;
  }, []);

  autoReport(bool run) {
    if (run && !isRunning.value) {
      final startTime = DateTime.now().next(DateTime.thursday);
      AndroidAlarmManager.periodic(
        const Duration(days: 7),
        id,
        backgroundJob,
        startAt: startTime,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      if (context != null) {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Time report scheduled for next Thursday')));
      }
    } else if (!run && isRunning.value) {
      AndroidAlarmManager.cancel(id);
    }
  }

  return autoReport;
}
