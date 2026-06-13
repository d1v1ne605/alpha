import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_data_list_item.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/show_bottom_sheet.dart';
import 'package:alpha/presentation/view_models/trading/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderData extends StatefulWidget {
  final OrderPortalType type;
  final ValueNotifier<int> orderPendingLengthNotifier;

  const OrderData({
    required this.type,
    required this.orderPendingLengthNotifier,
    super.key,
  });

  @override
  State<OrderData> createState() => _OrderDataState();
}

class _OrderDataState extends State<OrderData>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<OrderViewModel>();
      vm.init(
        widget.type == OrderPortalType.order
            ? AppStorageKey.waitStatusOrder
            : null,
        widget.type,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    OrderPortalType type = widget.type;
    return Consumer<OrderViewModel>(
      builder: (context, vm, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (type == OrderPortalType.order) {
            vm.addListener(() {
              widget.orderPendingLengthNotifier.value = vm
                  .getOrdersByType(OrderPortalType.order)
                  .length;
            });
          }
        });
        final stateManager = vm.getStateManager(type);
        final orders = vm.getOrdersByType(type);
        final isLoading = vm.isBusy;
        final hasNoData = orders.isEmpty && stateManager.hasInitialLoaded;
        if (isLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.space16.h),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.background,
          onRefresh: () async {
            await vm.refresh(type);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.space20.w,
                  top: AppSpacing.space10.h,
                  right: AppSpacing.space20.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Visibility(
                          visible: type != OrderPortalType.tradeHistory,
                          child: GestureDetector(
                            onTap: () => showOrderBottomSheet(
                              context: context,
                              vm: vm,
                              type: type,
                              filterType: OrderFilterType.Type,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  context.appLocaleLanguage.type,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: AppSize.size16.r,
                                  color: AppColors.iconPrimary,
                                ),
                                SizedBox(width: AppSpacing.space25.w),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showOrderBottomSheet(
                            context: context,
                            vm: vm,
                            type: type,
                            filterType: OrderFilterType.Pair,
                          ),
                          child: Row(
                            children: [
                              Text(
                                context.appLocaleLanguage.pair,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: AppSize.size16.r,
                                color: AppColors.iconPrimary,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSpacing.space25.w),
                        GestureDetector(
                          onTap: () => showOrderBottomSheet(
                            context: context,
                            vm: vm,
                            type: type,
                            filterType: OrderFilterType.Side,
                          ),
                          child: Row(
                            children: [
                              Text(
                                context.appLocaleLanguage.side,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                                textAlign: TextAlign.end,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: AppSize.size16.r,
                                color: AppColors.iconPrimary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: type != OrderPortalType.order,
                      child: GestureDetector(
                        onTap: () => showOrderBottomSheet(
                          context: context,
                          vm: vm,
                          type: type,
                        ),
                        child: Icon(
                          Icons.filter_alt_outlined,
                          color: AppColors.iconPrimary,
                          size: AppSize.size24.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space10.h),
              Expanded(
                child: (hasNoData)
                    ? SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height:
                              MediaQuery.of(context).size.height *
                              AppSize.size0_7.h,
                          child: const CustomNoData(),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.space40.h),
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: AppSpacing.space20.w,
                            right: AppSpacing.space20.w,
                          ),
                          itemCount: orders.length,
                          controller: stateManager.scrollController,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: vm.isBusy
                                  ? null
                                  : () => showOrderBottomSheet(
                                      context: context,
                                      vm: vm,
                                      type: type,
                                      data: orders[index],
                                    ),
                              child: OrderDataListItem(
                                data: orders[index],
                                vm: vm,
                                type: type,
                                parentContext: context,
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
