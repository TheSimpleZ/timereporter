import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<T> useSharedPrefs<T>(String key, {T initialValue, objType}) {
  final result = useState<T>(initialValue);

  getSecureValue() async {
    final storage = await SharedPreferences.getInstance();
    final val = storage.getString(key);
    var decoded = jsonDecode(val);
    if (objType != null) decoded = objType.fromJson();
    if (val != null) result.value = decoded;
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
