import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

ValueNotifier<T> useSharedPrefs<T>(String key,
    {T initialValue, Deserializer<T> deserializer}) {
  final result = useState<T>(initialValue);

  getSecureValue() async {
    final storage = await SharedPreferences.getInstance();
    final val = storage.getString(key);
    if (val != null) {
      var decoded = jsonDecode(val);
      if (deserializer != null) decoded = deserializer(decoded);
      result.value = decoded;
    }

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
