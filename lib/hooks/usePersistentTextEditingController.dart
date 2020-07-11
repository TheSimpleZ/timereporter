import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef ValueNotifier<T> StorageHook<T>(String key, [T initialData]);

TextEditingController usePersistentTextEditingController(
    String key, StorageHook useStorageHook,
    [String initialData]) {
  final result = useTextEditingController();
  final storage = useStorageHook(key, initialData);

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
