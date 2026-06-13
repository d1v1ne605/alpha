import 'package:flutter/cupertino.dart';

mixin RemoveListenerMixin {
  void viewModelRemoveListener<T extends ChangeNotifier>(
    T viewModel,
    Function() listener,
  ) {
    viewModel.removeListener(listener);
  }
}
