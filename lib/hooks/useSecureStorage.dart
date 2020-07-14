import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

ValueNotifier<T> useSecureStorage<T>(String key, {T initialValue, objType}) {
  final result = useState<T>(initialValue);

  initValue() async {
    final storage = FlutterSecureStorage();
    final val = await storage.read(key: key);
    var decoded = jsonDecode(val);
    if (objType != null) decoded = objType.fromJson();
    if (val != null) result.value = decoded;

    result.addListener(() {
      storage.write(key: key, value: jsonEncode(result.value));
    });
  }

  useEffect(() {
    initValue();
    return null;
  }, []);

  return result;
}
