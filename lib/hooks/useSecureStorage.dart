import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

ValueNotifier<T> useSecureStorage<T>(String key, [T initialData]) {
  final result = useState<T>(initialData);

  initValue() async {
    final storage = FlutterSecureStorage();
    final val = await storage.read(key: key);
    if (val != null) result.value = jsonDecode(val);

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
