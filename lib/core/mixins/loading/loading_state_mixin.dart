import 'package:alpha/core/base/base_view_model.dart';

mixin LoadingStateMixin on BaseViewModel {
  final Map<String, bool> _loadingStates = {};

  void setLoading(String key, bool value) {
    _loadingStates[key] = value;
    notifyListeners();
  }

  bool isLoading(String key) => _loadingStates[key] ?? false;

  bool get isAnyLoading => _loadingStates.values.any((loading) => loading);

  void clearAllLoading() {
    _loadingStates.clear();
    notifyListeners();
  }

  Future<T> withLoading<T>(
    String key,
    Future<T> Function() operation,
    void Function()? onCompleteOperation,
  ) async {
    setLoading(key, true);
    try {
      final result = await operation();
      return result;
    } catch (e) {
      rethrow;
    } finally {
      if (onCompleteOperation != null) {
        onCompleteOperation();
      }
      setLoading(key, false);
    }
  }
}
