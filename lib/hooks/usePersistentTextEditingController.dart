import 'package:flutter/foundation.dart';
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
    // Write to storage

    writeToStorage() {
      storage.value = result.text;
    }

    result.addListener(writeToStorage);

    // Get from storage once
    rehydrate() {
      result.text = storage.value;
      storage.removeListener(rehydrate);
    }

    storage.addListener(rehydrate);
    return () => result.removeListener(writeToStorage);
  }, []);

  return result;
}
