import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/data/models/trading/trade/depth_response_model.dart';
import 'package:alpha/domain/usecase/trading/get_order_book_usecase.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/header_order_book_depth.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/order_book_depth.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderBookChart extends StatefulWidget {
  final String market;
  final TabController tabController;

  const OrderBookChart({
    Key? key,
    required this.market,
    required this.tabController,
  }) : super(key: key);

  @override
  State<OrderBookChart> createState() => _OrderBookChartState();
}

class _OrderBookChartState extends State<OrderBookChart>
    with AutomaticKeepAliveClientMixin {
  TradeViewModel? _tradeViewModel;

  TradeViewModel get vm {
    return _tradeViewModel ??= context.read<TradeViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQueryHeight = MediaQuery.of(context).size.height * 0.4;
    final vm = Provider.of<TradeViewModel>(context, listen: false);
    return StreamBuilder<DepthResponseModel>(
      stream: vm.orderBookStream,
      initialData: vm.depthOrderBook,
      builder: (context, snapshot) {
        final orderBook = snapshot.data;
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (orderBook == null ||
            (orderBook.bids.isEmpty && orderBook.asks.isEmpty)) {
          return const CustomNoData();
        }
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.space20.w,
            right: AppSpacing.space20.w,
            top: AppSpacing.space15.h,
          ),
          child: Column(
            children: [
              Container(
                height: mediaQueryHeight,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          HeaderOrderBookDepth(
                            titleLeft: context.appLocaleLanguage.amount,
                            titleRight: context.appLocaleLanguage.buyPrice,
                            titleColor: AppColors.grey,
                          ),
                          SizedBox(height: AppSize.size8.h),
                          Expanded(
                            child: RepaintBoundary(
                              child: createOrderBookDepth(
                                orderBookType: OrderTypeEnum.buy,
                                orders: orderBook.bids,
                                reverseDepthInfoRow: true,
                                reverseDepthBar: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSize.size5.w),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          HeaderOrderBookDepth(
                            titleLeft: context.appLocaleLanguage.sellPrice,
                            titleRight: context.appLocaleLanguage.amount,
                            titleColor: AppColors.grey,
                          ),
                          SizedBox(height: AppSize.size8.h),
                          Expanded(
                            child: RepaintBoundary(
                              child: createOrderBookDepth(
                                orderBookType: OrderTypeEnum.sell,
                                orders: orderBook.asks,
                                reverseDepthInfoRow: false,
                                reverseDepthBar: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget createOrderBookDepth({
    required OrderTypeEnum orderBookType,
    required List<List<String>> orders,
    required bool reverseDepthInfoRow,
    required bool reverseDepthBar,
  }) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    OrderBookList displayOrders = orders
        .take(AppStorageKey.numberOfItemsOrderBookInLimit)
        .toList();

    return OrderBookDepth(
      orderBookType: orderBookType,
      orders: displayOrders,
      reverseDepthInfoRow: reverseDepthInfoRow,
      reverseDepthBar: reverseDepthBar,
    );
  }
}
