import 'package:hive/hive.dart';

class HiveService {
  Future<dynamic> get(String key) async {
    if (!Hive.box('system').isOpen) {
      await Hive.openBox('system');
    }
    dynamic result = await Hive.box('system').get(key);
    return result;
  }

  Future<void> set(String key, dynamic value) async {
    if (!Hive.box('system').isOpen) {
      await Hive.openBox('system');
    }
    await Hive.box('system').put(key, value);
  }

  Future<void> delete(String key) async {
    if (!Hive.box('system').isOpen) {
      await Hive.openBox('system');
    }
    await Hive.box('system').delete(key);
  }
}
