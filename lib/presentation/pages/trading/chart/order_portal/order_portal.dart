import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/trading/chart/order_app_bar.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/tab_order.dart';
import 'package:alpha/presentation/view_models/trading/order_view_model.dart';
import 'package:flutter/material.dart';

class OrderPortal extends StatefulWidget {
  const OrderPortal({Key? key}) : super(key: key);

  @override
  State<OrderPortal> createState() => _OrderPortalState();
}

class _OrderPortalState extends State<OrderPortal> {
  @override
  Widget build(BuildContext context) {
    return BaseView<OrderViewModel>(
      viewModelBuilder: () => getIt<OrderViewModel>(),
      autoDispose: true,
      padding: true,
      builder: (context, vm, child) {
        return Scaffold(
          body: Column(
            children: [
              OrderAppBar(title: context.appLocaleLanguage.orderPortal),
              Expanded(child: TabOrder()),
            ],
          ),
        );
      },
    );
  }
}
