import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<T> useSharedPrefs<T>(String key, [T initialData]) {
  final result = useState<T>(initialData);

  getSecureValue() async {
    final storage = await SharedPreferences.getInstance();
    final val = storage.getString(key);
    if (val != null) result.value = jsonDecode(val);

    result.addListener(() {
      storage.setString(key, jsonEncode(result.value));
    });
  }

  useEffect(() {
    getSecureValue();
    return null;
  }, []);

  return result;
}
