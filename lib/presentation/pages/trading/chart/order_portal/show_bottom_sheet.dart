import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_detail_bottom_sheet/order_detail_content.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_filter_bottom_sheet/filter_date_sheet.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_filter_bottom_sheet/filter_pair_sheet.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_filter_bottom_sheet/filter_side_sheet.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_filter_bottom_sheet/filter_type_sheet.dart';
import 'package:alpha/presentation/view_models/trading/order_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

void showOrderBottomSheet({
  required BuildContext context,
  required OrderViewModel vm,
  OrderFilterType? filterType,
  required OrderPortalType type,
  dynamic data,
}) {
  AppBottomSheetWidget.show(
    isSingleChildScrollView: true,
    context: context,
    child: data == null
        ? ChangeNotifierProvider.value(
            value: vm,
            child: _getFilterSheet(
              filterType,
              type,
              vm,
              const SizedBox.shrink(),
            ),
          )
        : OrderDetailContent(
            data: data,
            type: type,
            coinName: vm.getCoinName(data),
          ),
    maxChildSize: AppSize.size0_8,
    minChildSize: AppSize.size0_6,
  );
}

Widget _getFilterSheet(
  OrderFilterType? filterType,
  OrderPortalType type,
  OrderViewModel vm,
  Widget widget,
) {
  switch (filterType) {
    case OrderFilterType.Type:
      return ChangeNotifierProvider.value(
        value: vm,
        child: OrderFilterTypeSheet(type: type),
      );
    case OrderFilterType.Pair:
      return ChangeNotifierProvider.value(
        value: vm,
        child: OrderFilterPairSheet(type: type),
      );
    case OrderFilterType.Side:
      return ChangeNotifierProvider.value(
        value: vm,
        child: OrderFilterSideSheet(type: type),
      );
    default:
      return ChangeNotifierProvider.value(
        value: vm,
        child: OrderFilterDateSheet(type: type),
      );
  }
}
