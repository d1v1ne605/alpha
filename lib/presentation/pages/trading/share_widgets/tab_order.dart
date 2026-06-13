import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/mixins.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/order_data.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TabOrder extends StatefulWidget {
  final CoinModel coin;

  const TabOrder({super.key, required this.coin});

  @override
  State<TabOrder> createState() => _TabOrderState();
}

class _TabOrderState extends State<TabOrder>
    with SingleTickerProviderStateMixin, Trade {
  late TabController tabOrderController;
  late String baseUnit;
  late String quoteUnit;
  late final ValueNotifier<int> orderPendingLengthNotifier = ValueNotifier<int>(
    0,
  );

  @override
  void initState() {
    super.initState();

    final coinUnits = getCoinAndQuoteUnitByCoinName(widget.coin.name);
    baseUnit = coinUnits[AppStorageKey.keyBaseCoinUnit]!;
    quoteUnit = coinUnits[AppStorageKey.keyQuoteCoinUnit]!;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    tabOrderController = TabController(
      length: buildTabList().length,
      vsync: this,
    );
    final vm = Provider.of<TradeViewModel>(context, listen: false);
    final isLogin = await getIt<AuthChangeNotifier>().checkLogin;
    if (isLogin) {
      await vm.getTradeHistory(
        limit: AppStorageKey.transactionHistoryLimit.toString(),
        market: widget.coin.id,
      );
    } else {
      orderPendingLengthNotifier.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: orderPendingLengthNotifier,
          builder: (context, pendingOrderCount, child) {
            return CustomTabBar(
              controller: tabOrderController,
              tabs: buildTabList(pendingOrderCount: pendingOrderCount),
              containerLeftPadding: AppSpacing.space0,
              tabBarLeftPadding: AppSpacing.space10,
              trailing: orderPortalTrailing(context),
            );
          },
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: tabOrderController,
            children: [
              ValueListenableBuilder<List<OrderItemModel>>(
                valueListenable: context
                    .read<TradeViewModel>()
                    .orderPendingItemNotifier,
                builder: (context, pendingOrders, child) {
                  return OrderData(
                    coinId: widget.coin.id,
                    baseUnit: baseUnit,
                    quoteUnit: quoteUnit,
                    orders: pendingOrders,
                    statusOrder: AppStorageKey.waitStatusOrder,
                    orderPendingLengthNotifier: orderPendingLengthNotifier,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget orderPortalTrailing(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.space8.r),
        splashFactory: InkRipple.splashFactory,
        onTap: () => context.push(RouterPath.orderPortal, extra: widget.coin),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: AppSpacing.space36.w,
            minHeight: AppSpacing.space36.h,
          ),
          child: Center(
            child: SvgPicture.asset(
              AppSvg.order,
              height: AppSize.size18.h,
              width: AppSize.size18.w,
            ),
          ),
        ),
      ),
    );
  }

  List<Tab> buildTabList({int pendingOrderCount = 0}) {
    return [
      Tab(
        text: '${context.appLocaleLanguage.pendingOrder} ($pendingOrderCount)',
        height: AppSpacing.space36.h,
      ),
    ];
  }
}
