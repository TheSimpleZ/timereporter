import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../constants.dart';

typedef ValueNotifier<T> StorageHook<T>(String key,
    {T initialValue, Deserializer deserializer});

TextEditingController usePersistentTextEditingController(
    String key, StorageHook useStorageHook,
    {String initialValue, deserializer}) {
  final result = useTextEditingController();
  final storage = useStorageHook(key,
      initialValue: initialValue, deserializer: deserializer);

  useEffect(() {
    result.addListener(() {
      storage.value = result.text;
    });

    rehydrate() {
      result.text = storage.value;
      storage.removeListener(rehydrate);
    }

    storage.addListener(rehydrate);
    return null;
  }, []);

  return result;
}
