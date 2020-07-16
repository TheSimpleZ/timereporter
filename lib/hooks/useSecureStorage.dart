import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants.dart';

ValueNotifier<T> useSecureStorage<T>(String key,
    {T initialValue, Deserializer<T> deserializer}) {
  final result = useState<T>(initialValue);

  initValue() async {
    final storage = FlutterSecureStorage();
    final val = await storage.read(key: key);
    if (val != null) {
      var decoded = jsonDecode(val);
      if (deserializer != null) decoded = deserializer(decoded);
      result.value = decoded;
    }

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
