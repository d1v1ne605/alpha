import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/core/widgets/custom_table_order.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/order_data_list_item.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderData extends StatefulWidget {
  final List<OrderItemModel> orders;
  final String coinId;
  final String baseUnit;
  final String quoteUnit;
  final bool enableDeleteAction;
  final String? statusOrder;
  final ValueNotifier<int> orderPendingLengthNotifier;

  const OrderData({
    required this.coinId,
    required this.orders,
    required this.baseUnit,
    required this.quoteUnit,
    this.enableDeleteAction = true,
    this.statusOrder,
    required this.orderPendingLengthNotifier,
    super.key,
  });

  @override
  State<OrderData> createState() => _OrderDataState();
}

class _OrderDataState extends State<OrderData>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  bool hasMoreData = true;
  final ValueNotifier<bool> hasInitialLoadedNotifier = ValueNotifier<bool>(
    false,
  );
  int currentPage = 1;
  int pageSize = AppStorageKey.orderPageSize;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageSize = widget.statusOrder == AppStorageKey.waitStatusOrder
        ? AppStorageKey.orderPageSize
        : AppStorageKey.orderHistoryLimit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_onScroll);
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasInitialLoadedNotifier.value) {
      await _loadInitialData(forceReload: true);
    }
  }

  @override
  void didUpdateWidget(OrderData oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coinId != widget.coinId ||
        oldWidget.statusOrder != widget.statusOrder) {
      _resetPagination();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    final isNearBottom = currentScroll >= maxScrollExtent * 0.8;
    final isScrollingDown =
        _scrollController.position.userScrollDirection ==
        ScrollDirection.reverse;
    if (isNearBottom &&
        (isScrollingDown || widget.orders.length <= 10) &&
        !isLoadingMore &&
        hasMoreData &&
        hasInitialLoadedNotifier.value) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (isLoadingMore || !hasMoreData) return;

    setState(() {
      isLoadingMore = true;
    });

    final vm = Provider.of<TradeViewModel>(context, listen: false);
    int initialOrderCount = widget.orders.length;

    final Map<String, int> dataOverflow = vm
        .checkOverflowPendingItemForPagination(
          initialOrderCount: initialOrderCount,
          currentPage: currentPage,
          statusOrder: widget.statusOrder,
        );
    final int overflowCount =
        dataOverflow[AppStorageKey.keyOverflowOrderLimit] ?? 0;
    initialOrderCount =
        dataOverflow[AppStorageKey.keyInitialOrderCount] ?? initialOrderCount;

    // load more with timeTo and limit
    int? timeTo;
    final limit = overflowCount > 0 ? pageSize + overflowCount : pageSize;
    final page = overflowCount > 0 ? 1 : currentPage + 1;
    if (overflowCount > 0) {
      timeTo = vm.timeToLoadMore;
    }

    await vm.loadOrders(
      market: widget.coinId,
      state: widget.statusOrder,
      limit: limit.toString(),
      page: page.toString(),
      isLoadMore: true,
      timeTo: timeTo,
    );

    final newOrderCount = widget.orders.length;
    vm.timeToLoadMore = null;
    currentPage++;
    hasMoreData = vm.hasMoreData(
      initialOrderCount: initialOrderCount,
      newOrderCount: newOrderCount,
      currentPage: currentPage,
    );

    if (mounted) {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> _loadInitialData({bool forceReload = false}) async {
    final isLogin = await getIt<AuthChangeNotifier>().checkLogin;
    if (forceReload) {
      currentPage = 1;
      isLoadingMore = false;
      hasMoreData = true;
    }

    if (!mounted) return;
    final vm = Provider.of<TradeViewModel>(context, listen: false);

    if (!isLogin) {
      _clearDataWhenLogout(vm);
      return;
    }

    await vm.loadOrders(
      market: widget.coinId,
      state: widget.statusOrder,
      limit: pageSize.toString(),
      page: currentPage.toString(),
      forceReload: forceReload,
    );

    hasInitialLoadedNotifier.value = true;
    if (AppStorageKey.waitStatusOrder == widget.statusOrder) {
      hasMoreData = vm.orderPendingItemNotifier.value.length >= pageSize;
    } else {
      hasMoreData = vm.orderItemNotifier.value.length >= pageSize;
    }
  }

  void _clearDataWhenLogout(TradeViewModel vm) {
    if (vm.orderPendingItemNotifier.value.isNotEmpty) {
      vm.orderPendingItemNotifier.value.clear();
    }
    if (vm.orderItemNotifier.value.isNotEmpty) {
      vm.orderItemNotifier.value.clear();
    }
    if (vm.tradeHistory.isNotEmpty) {
      vm.tradeHistory.clear();
    }
    if (widget.orderPendingLengthNotifier.value != 0) {
      widget.orderPendingLengthNotifier.value = 0;
    }
  }

  void _resetPagination() {
    currentPage = 1;
    isLoadingMore = false;
    hasMoreData = true;
    hasInitialLoadedNotifier.value = false;
    _loadInitialData();
  }

  int _getItemCount() {
    int count = widget.orders.length;
    if (isLoadingMore) count++;
    if (!hasInitialLoadedNotifier.value) count = 1;
    return count;
  }

  void clearAllOrders(TradeViewModel vm, BuildContext context) async {
    await vm.cancelAllOrders(widget.coinId);

    if (!mounted) return;
    if (!context.mounted) return;

    if (vm.errorMessage != null) {
      context.showErrorSnackBar(vm.errorMessage!);
      vm.clearError();
    } else {
      context.showSuccessSnackBar(context.appLocaleLanguage.clearAllSuccess);
    }
  }

  void refreshData() async {
    final vm = Provider.of<TradeViewModel>(context, listen: false);
    vm.setBusy(true);
    vm.isReloadOrdersDisabled = true;
    await _loadInitialData(forceReload: true);
    vm.setBusy(false);
    Future.delayed(const Duration(seconds: 3), () {
      vm.isReloadOrdersDisabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final vm = Provider.of<TradeViewModel>(context, listen: false);
    final isAuthenticated = context.select<AuthChangeNotifier, bool>(
      (auth) => auth.isAuthenticated,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.statusOrder == AppStorageKey.waitStatusOrder &&
          !isLoadingMore) {
        widget.orderPendingLengthNotifier.value = widget.orders.length;
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.enableDeleteAction)
          Padding(
            padding: EdgeInsets.only(
              right: AppSpacing.space20.w,
              top: AppSpacing.space8.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Selector<TradeViewModel, bool>(
                  selector: (_, vm) => vm.isReloadOrdersDisabled,
                  builder: (_, isReloadOrdersDisabled, __) => Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: !isReloadOrdersDisabled
                          ? () => refreshData()
                          : null,
                      borderRadius: BorderRadius.circular(AppSpacing.space12.r),
                      splashColor: AppColors.primary.withOpacity(0.2),
                      highlightColor: AppColors.primary.withOpacity(0.1),
                      child: Container(
                        padding: EdgeInsets.all(AppSpacing.space4.r),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.replay_outlined,
                              color: isReloadOrdersDisabled
                                  ? AppColors.grey
                                  : AppColors.primary,
                              size: 15.w,
                            ),
                            SizedBox(width: AppSpacing.space4.w),
                            Text(
                              context.appLocaleLanguage.refresh,
                              style: AppTextStyles.caption.copyWith(
                                color: isReloadOrdersDisabled
                                    ? AppColors.grey
                                    : AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.space10.w),
                GestureDetector(
                  onTap: () => clearAllOrders(vm, context),
                  child: Text(
                    context.appLocaleLanguage.clearAll,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        SizedBox(height: AppSpacing.space10.h),

        CustomTableOrder(
          orderNameHeader: context.appLocaleLanguage.orderTableName,
          orderFilledHeader: context.appLocaleLanguage.orderTableFilled,
          orderPriceHeader: context.appLocaleLanguage.orderTablePrice,
          orderAmountHeader: context.appLocaleLanguage.orderTableAmount,
        ),

        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: hasInitialLoadedNotifier,
            builder: (context, hasInitialLoaded, _) {
              if (!isAuthenticated ||
                  (widget.orders.isEmpty && hasInitialLoaded)) {
                return const CustomNoData();
              }
              if (!hasInitialLoaded) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.space20.w,
                  vertical: AppSpacing.space0,
                ),
                itemCount: _getItemCount(),
                itemBuilder: (context, index) => _buildListItem(index, vm),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(int index, TradeViewModel vm) {
    if (index >= widget.orders.length) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.space16.h),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final data = widget.orders[index];
    return OrderDataListItem(
      key: ValueKey('${data.id}_${data.price}'),
      currentPage: currentPage,
      data: data,
      baseUnit: widget.baseUnit,
      quoteUnit: widget.quoteUnit,
      enableDeleteAction: widget.enableDeleteAction,
      vm: vm,
      parentContext: context,
    );
  }
}
