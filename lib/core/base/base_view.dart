import 'dart:io';

import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/global_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

typedef ViewModelBuilder<T> =
    Widget Function(BuildContext context, T viewModel, Widget? child);

class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  final T Function() viewModelBuilder;
  final ViewModelBuilder<T> builder;
  final Function(T)? onModelReady;
  final Function(T)? onModelDispose;
  final bool autoDispose;
  final bool padding;
  final bool useSelector;

  const BaseView({
    Key? key,
    required this.viewModelBuilder,
    required this.builder,
    this.onModelReady,
    this.onModelDispose,

    this.autoDispose = true,
    this.padding = true,
    this.useSelector = false,
  }) : super(key: key);

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>>
    with WidgetsBindingObserver {
  final globalViewModel = getIt<GlobalViewModel>();
  late T viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    viewModel = widget.viewModelBuilder();
    widget.onModelReady?.call(viewModel);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isLogin = await AuthChangeNotifier().checkLogin;
      if (isLogin) {
        // globalViewModel.startBalancesAndCurrenciesPolling(isInitPolling: true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.onModelDispose?.call(viewModel);
    if (widget.autoDispose) {
      viewModel.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    globalViewModel.setAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: _buildSafeAreaPadding(context),
    );
  }

  Widget _buildSafeAreaPadding(BuildContext context) {
    if (Platform.isIOS) {
      return SafeArea(child: Consumer<T>(builder: widget.builder));
    } else {
      return SafeArea(
        top: false,
        child: Padding(
          padding: widget.padding
              ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
              : EdgeInsets.zero,
          child: widget.useSelector
              ? Builder(
                  builder: (context) {
                    final vm = Provider.of<T>(context, listen: false);
                    return widget.builder(context, vm, null);
                  },
                )
              : Consumer<T>(builder: widget.builder),
        ),
      );
    }
  }
}
