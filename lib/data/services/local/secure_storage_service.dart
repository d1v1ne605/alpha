import 'package:alpha/injection/injector.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // we use a singleton pattern to ensure only one instance of this service exists
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal();

  Future<void> saveData(String key, String value) async {
    try {
      await getIt<FlutterSecureStorage>().write(key: key, value: value);
    } on Exception catch (e) {
      throw Exception("Error saving data: $e");
    }
  }

  Future<String?> readData(String key) async {
    try {
      final value = await getIt<FlutterSecureStorage>().read(key: key);
      return value;
    } on Exception catch (e) {
      throw Exception("Error reading data: $e");
    }
  }

  Future<void> deleteData(String key) async {
    try {
      await getIt<FlutterSecureStorage>().delete(key: key);
    } on Exception catch (e) {
      throw Exception("Error deleting data: $e");
    }
  }
}
