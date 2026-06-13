import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/mixins.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_data.dart';
import 'package:flutter/material.dart';

class TabOrder extends StatefulWidget {
  const TabOrder({super.key});

  @override
  State<TabOrder> createState() => _TabOrderState();
}

class _TabOrderState extends State<TabOrder>
    with SingleTickerProviderStateMixin, Trade {
  late TabController tabOrderController;
  late final ValueNotifier<int> orderPendingLengthNotifier = ValueNotifier<int>(
    0,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabOrderController = TabController(
      length: buildTabList().length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: orderPendingLengthNotifier,
          builder: (context, pendingOrderCount, child) {
            return CustomTabBar(
              controller: tabOrderController,
              tabs: buildTabList(pendingOrderCount: pendingOrderCount),
              containerLeftPadding: AppSpacing.space0,
              tabBarLeftPadding: AppSpacing.space10,
            );
          },
        ),
        Expanded(
          child: TabBarView(
            controller: tabOrderController,
            children: [
              OrderData(
                type: OrderPortalType.order,
                orderPendingLengthNotifier: orderPendingLengthNotifier,
              ),
              OrderData(
                type: OrderPortalType.orderHistory,
                orderPendingLengthNotifier: orderPendingLengthNotifier,
              ),
              OrderData(
                type: OrderPortalType.tradeHistory,
                orderPendingLengthNotifier: orderPendingLengthNotifier,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Tab> buildTabList({int pendingOrderCount = 0}) {
    return [
      Tab(text: '${context.appLocaleLanguage.orders} ($pendingOrderCount)'),
      Tab(text: context.appLocaleLanguage.orderHistory),
      Tab(text: context.appLocaleLanguage.tradeHistory),
    ];
  }
}
