import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef ValueNotifier<T> StorageHook<T>(String key, {T initialValue, objType});

TextEditingController usePersistentTextEditingController(
    String key, StorageHook useStorageHook,
    {String initialValue, objType}) {
  final result = useTextEditingController();
  final storage =
      useStorageHook(key, initialValue: initialValue, objType: initialValue);

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
