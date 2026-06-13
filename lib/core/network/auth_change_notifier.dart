import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/data/services/local/secure_storage_service.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:flutter/foundation.dart';

class AuthChangeNotifier extends ChangeNotifier {
  bool _isFetchTokenSuccess = false;
  static final AuthChangeNotifier _instance = AuthChangeNotifier._internal();

  factory AuthChangeNotifier() => _instance;

  AuthChangeNotifier._internal();

  String? _token;

  String? get token => _token;

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  set token(String? value) {
    if (value == null || value.isEmpty) {
      clear();
      return;
    }
    if (_token == value) return; // Avoid unnecessary updates

    _token = value;

    if (_isFetchTokenSuccess) {
      return;
    }
    notifyListeners();
  }

  Future<void> clear() async {
    await getIt<HiveService>().delete(
      key: AppLocalKey.hiveKeyMainUser,
      boxName: AppLocalKey.hiveBoxNameUser,
    );
    await SecureStorageService().deleteData(AppStorageKey.accessToken);
    await SecureStorageService().deleteData(AppStorageKey.keyAuthCookie);
    _isFetchTokenSuccess = false;
    _token = null;
    final globalViewModel = getIt<GlobalViewModel>();
    globalViewModel.stopBalancesAndCurrenciesPolling();
    globalViewModel.disconnectSocket();
    globalViewModel.connectSocket();
    notifyListeners();
  }

  Future<void> fetchToken() async {
    try {
      final result = await SecureStorageService().readData(
        AppStorageKey.accessToken,
      );
      if (result != null) {
        _isFetchTokenSuccess = true;
        token = result;
      }
    } catch (e) {
      throw Exception('Failed to fetch token: $e');
    }
  }

  Future<bool> get checkLogin async {
    try {
      if (isAuthenticated) {
        return true;
      }
      await fetchToken();
      return isAuthenticated;
    } catch (e) {
      await clear();
      // Consider as not authenticated
      return false;
    }
  }
}
