import 'dart:convert';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
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

// Fetch everything from storage using native methods because we cannot access hooks here
Future<void> backgroundJob() async {
  debugPrint("Background job started");
  final sharedPrefs = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage();

  T getItem<T>(key) {
    final item = sharedPrefs.getString(key);
    return item == null ? null : jsonDecode(item);
  }

  Future<T> getSecureItem<T>(key) async {
    final item = await secureStorage.read(key: StorageKeys.username);
    return item == null ? null : jsonDecode(item);
  }

  Future<bool> setItem<T>(key, value) {
    final val = jsonEncode(value);
    return sharedPrefs.setString(key, val);
  }

  final workOrder = getItem(StorageKeys.workOrder);
  final hoursPerDay = getItem(StorageKeys.hoursPerDay);
  final ready = getItem(StorageKeys.ready);

  final username = await getSecureItem(StorageKeys.username);
  final password = await getSecureItem(StorageKeys.password);

  final plans = getItem<Map<String, dynamic>>(StorageKeys.plans);

  final response = await sendTimeReport(username, password, plans,
      workOrder: workOrder, hoursPerDay: hoursPerDay, ready: ready);

  if (response.statusCode == 200) {
    notify("Timereporter", "Successfully reported time for this week!");

    // Set next run to next thursday
    await setItem(
        "useAutoReporter.nextRun", DateTime.now().add(Duration(days: 7)));
  } else {
    notify("Timereporter", "Failed to report time for this week!");
  }
}

class AutoReporter {
  final DateTime nextRun;
  final Function(bool) setAutoReport;
  final Function() sendNow;

  AutoReporter(this.setAutoReport, this.sendNow, this.nextRun);
}

bool isInitialized = false;
AutoReporter useAutoReporter([BuildContext context]) {
  final isRunning =
      useSharedPrefs("useAutoReporter.isRunning", initialValue: false);
  final nextRun = useSharedPrefs("useAutoReporter.nextRun");

  const id = 0;
  useEffect(() {
    if (!isInitialized) {
      AndroidAlarmManager.initialize();
      isInitialized = true;
    }
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
      debugPrint("Periodic alarm set");
      isRunning.value = true;
      nextRun.value = startTime;
    } else if (!run && isRunning.value) {
      AndroidAlarmManager.cancel(id);
      debugPrint("Periodic alarm canceled");
      isRunning.value = false;
    }
  }

  sendNow() => AndroidAlarmManager.oneShot(
        Duration.zero,
        id,
        backgroundJob,
        allowWhileIdle: true,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

  final autoreporter = useMemoized(
      () => AutoReporter(autoReport, sendNow, nextRun.value), [isRunning]);

  return autoreporter;
}
