import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/presentation/pages/earn/withdraw/coin_item_earn.dart';
import 'package:alpha/presentation/pages/earn/withdraw/coin_selection_earn.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinEarnSelectionWithdraw extends StatelessWidget {
  const CoinEarnSelectionWithdraw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EarnViewModel>();

    return Selector<EarnViewModel, EarnWalletData?>(
      selector: (_, vm) => vm.selectedWallet,
      builder: (context, coinSelected, child) => CoinSelectionEarn(
        selectedCoin: coinSelected,
        onOpenList: () {
          AppBottomSheetWidget.show(
            minChildSize: AppSize.size0_8,
            maxChildSize: AppSize.size0_9,
            context: context,
            child: ValueListenableBuilder<List<EarnWalletData>>(
              valueListenable: vm.filteredWallets,
              builder: (context, filteredCoins, _) {
                return CoinItemEarn(
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
