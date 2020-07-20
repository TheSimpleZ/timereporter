import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifications.dart';
import 'services/timereport-api.dart';
import 'constants.dart';

class LocalStorage {
  final secureStorage = FlutterSecureStorage();

  Future<T> getItem<T>(key) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final item = sharedPrefs.getString(key);
    return item == null ? null : jsonDecode(item);
  }

  Future<T> getSecureItem<T>(key) async {
    final item = await secureStorage.read(key: key);
    return item == null ? null : jsonDecode(item);
  }

  Future<bool> setItem<T>(key, value) async {
    final sharedPrefs = await SharedPreferences.getInstance();

    final val = jsonEncode(value);
    return sharedPrefs.setString(key, val);
  }
}

// Sync weekly data from unit4 to local storage
Future<bool> syncWeeklyData() async {
  final storage = LocalStorage();
  final username = await storage.getSecureItem(StorageKeys.username);
  final password = await storage.getSecureItem(StorageKeys.password);

  final data = await getWeeklyData(username, password);

  if (data?.businessDays?.isNotEmpty == true) {
    await storage.setItem(StorageKeys.plans,
        {for (var d in data.businessDays) d: TimeCodes.normalTime});

    await storage.setItem(StorageKeys.hoursPerDay, data.hoursPerDay.toString());
    await storage.setItem(StorageKeys.workOrderList, data.workOrders);

    return true;
  } else {
    return false;
  }
}

// Fetch everything from storage using native methods because we cannot access hooks here
Future<void> backgroundJob() async {
  debugPrint("Background job started");
  final storage = LocalStorage();

  final workOrder = await storage.getItem(StorageKeys.workOrder);
  final hoursPerDay = await storage.getItem(StorageKeys.hoursPerDay);
  final ready = await storage.getItem(StorageKeys.ready);

  final username = await storage.getSecureItem(StorageKeys.username);
  final password = await storage.getSecureItem(StorageKeys.password);

  final plans = await storage.getItem<Map<String, dynamic>>(StorageKeys.plans);

  final response = await sendTimeReport(username, password, plans,
      workOrder: workOrder, hoursPerDay: hoursPerDay, ready: ready);

  if (response.statusCode == 200) {
    // Set next run to next thursday
    final isRunning = await storage.getItem("useAutoReporter.isRunning");

    if (isRunning) {
      final nextRun = DateTime.now().add(Duration(days: 7));
      final DateFormat formatter = DateFormat('EEEE dd/MM');
      await storage.setItem(
          "useAutoReporter.nextRun", formatter.format(nextRun));
    }

    final success = await syncWeeklyData();

    if (success) {
      notify("Timereporter",
          "Successfully reported time for this week and get next weeks info");
    } else {
      notify("Timereporter",
          "Successfully reported time for this week, but failed to get next weeks info!");
    }
  } else {
    notify("Timereporter", "Failed to report time for this week!");
  }
}
