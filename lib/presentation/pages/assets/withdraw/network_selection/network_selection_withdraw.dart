import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/assets/share/network_selection.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../share/network_item.dart';

class NetworkSelectionWithdraw extends StatelessWidget {
  const NetworkSelectionWithdraw({super.key});
  @override
  Widget build(BuildContext context) {
    return Selector<WithdrawViewModel, CurrencyModel?>(
      selector: (_, vm) => vm.networkSelected,
      builder: (context, networkSelected, child) => NetworkSelection(
        selectedNetwork: networkSelected,
        actionType: WalletActionType.withdraw,
        networks:
            context
                .read<WithdrawViewModel>()
                .childCurrencies
                ?.childCurrenciesData ??
            [],
        placeholderText: context.appLocaleLanguage.selectWithdrawNetwork,
        onNetworkSelected: context
            .read<WithdrawViewModel>()
            .selectNetworkWithdraw,
      ),
    );
  }
}
