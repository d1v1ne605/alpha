import 'dart:async';

import 'package:alpha/core/base/base_view_model.dart';
import 'package:flutter/foundation.dart';

import '../../../data/services/local/hive_service.dart';

mixin LocalStorageMixin on BaseViewModel {
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheExpiry = {};
  final Map<String, dynamic> _computedCache = {};
  final Map<String, List<String>> _computedDependencies = {};
  HiveService? _hiveService;

  void initLocalStorage(HiveService hiveService) {
    _hiveService = hiveService;
  }

  T? getCachedData<T>(String key) {
    if (_cache.containsKey(key)) {
      if (_cacheExpiry[key] == null ||
          _cacheExpiry[key]!.isAfter(DateTime.now())) {
        return _cache[key] as T;
      } else {
        _cache.remove(key);
        _cacheExpiry.remove(key);
      }
    }
    return null;
  }

  void setCachedData<T>(String key, T data, {Duration? expiry}) {
    _cache[key] = data;
    if (expiry != null) {
      _cacheExpiry[key] = DateTime.now().add(expiry);
    } else {
      _cacheExpiry.remove(key);
    }
  }

  void clearCachedData(String key) {
    _cache.remove(key);
    _cacheExpiry.remove(key);
  }

  void clearAllCache() {
    _cache.clear();
    _cacheExpiry.clear();
    _computedCache.clear();
    _computedDependencies.clear();
  }

  T getComputedData<T>(
    String key,
    T Function() compute, {
    List<String>? dependencies,
  }) {
    if (_computedCache.containsKey(key)) {
      return _computedCache[key] as T;
    }
    final result = compute();
    _computedCache[key] = result;
    if (dependencies != null) {
      _computedDependencies[key] = dependencies;
    }
    return result;
  }

  void invalidateComputedCache(String key) {
    _computedCache.remove(key);
    _computedDependencies.remove(key);
  }

  void invalidateDependency(String depKey) {
    final keysToInvalidate = _computedDependencies.entries
        .where((e) => e.value.contains(depKey))
        .map((e) => e.key)
        .toList();
    for (final key in keysToInvalidate) {
      invalidateComputedCache(key);
    }
  }

  void batchUpdate(void Function() updates) {
    updates();
    notifyListeners();
  }

  void selectiveNotify(List<String> keys) {
    for (final key in keys) {
      invalidateDependency(key);
    }
    notifyListeners();
  }

  @mustCallSuper
  void disposeResources() {
    clearAllCache();
    _hiveService = null;
  }

  Future<T?> loadFromHive<T>({
    required String key,
    required String boxName,
  }) async {
    if (_hiveService == null) return null;
    final data = await _hiveService!.get(key: key, boxName: boxName);
    return data as T?;
  }

  Future<void> saveToHive<T>({
    required String key,
    required String boxName,
    required T value,
  }) async {
    if (_hiveService == null) return;
    await _hiveService!.put(key: key, boxName: boxName, value: value);
  }

  bool isCacheValid(String key) {
    if (!_cache.containsKey(key)) return false;
    if (_cacheExpiry[key] == null) return true;
    return _cacheExpiry[key]!.isAfter(DateTime.now());
  }
}
