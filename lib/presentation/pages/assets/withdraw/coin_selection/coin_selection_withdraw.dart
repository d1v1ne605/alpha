import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/assets/share/coin_item.dart';
import 'package:alpha/presentation/pages/assets/share/coin_selection.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CoinSelectionWithdraw extends StatelessWidget {
  const CoinSelectionWithdraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WithdrawViewModel>();
    return Selector<WithdrawViewModel, CurrencyModel?>(
      selector: (_, vm) => vm.coinSelected,
      builder: (context, coinSelected, child) => CoinSelection(
        selectedCoin: coinSelected,
        onOpenList: () {
          AppBottomSheetWidget.show(
            minChildSize: AppSize.size0_8,
            maxChildSize: AppSize.size0_9,
            context: context,
            child: ValueListenableBuilder<List<CurrencyModel>>(
              valueListenable: vm.filteredItemsNotifier,
              builder: (context, filteredCoins, _) {
                return CoinItem(
                  searchController: vm.searchController,
                  filterCoins: filteredCoins,
                  onSearch: vm.onSearchChanged,
                  onCoinSelected: vm.selectCoinWithdraw,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
