import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    if (!kIsWeb) {
      var path = Directory.current.path;
      if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        path = directory.path;
      }
      Hive.init(path);
    }
  }

  Future<Box> getBox({required String name}) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box(name);
    }
    return await Hive.openBox(name);
  }

  Future<void> put({
    required String key,
    required dynamic value,
    required String boxName,
  }) async {
    final box = await getBox(name: boxName);
    await box.put(key, value);
  }

  Future<dynamic> get({required String key, required String boxName}) async {
    final box = await getBox(name: boxName);
    return box.get(key);
  }

  Future<void> delete({required String key, required String boxName}) async {
    final box = await getBox(name: boxName);
    await box.delete(key);
  }

  Future<void> clear({required String boxName}) async {
    final box = await getBox(name: boxName);
    await box.clear();
  }

  Future<void> closeAll() async {
    await Hive.close();
  }
}
