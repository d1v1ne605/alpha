import 'package:flutter/foundation.dart';

mixin AddListenerMixin {
  void viewModelAddListener<T extends ChangeNotifier>(
    T viewModel,
    Function() listener,
  ) {
    viewModel.addListener(listener);
  }
}
