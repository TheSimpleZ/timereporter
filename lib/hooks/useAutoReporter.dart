import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import '../hooks/useSharedPrefs.dart';
import '../syncUtils.dart';

extension on DateTime {
  DateTime next(int day) {
    return this.add(
      Duration(
        days: (day - this.weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}

class AutoReporter {
  final String nextRun;
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
      final DateFormat formatter = DateFormat('EEEE dd/MM');
      nextRun.value = formatter.format(startTime);
    } else if (!run && isRunning.value) {
      AndroidAlarmManager.cancel(id);
      debugPrint("Periodic alarm canceled");
      isRunning.value = false;
      nextRun.value = null;
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
      () => AutoReporter(autoReport, sendNow, nextRun.value),
      [isRunning, nextRun.value]);

  return autoreporter;
}
