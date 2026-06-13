import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/assets/share/network_selection.dart';
import 'package:alpha/presentation/view_models/deposit/deposit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../share/network_item.dart';

class NetworkSelectionDeposit extends StatelessWidget {
  const NetworkSelectionDeposit({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Selector<
      DepositViewModel,
      ({CurrencyModel? selectedNetwork, List<CurrencyModel> networks})
    >(
      selector: (_, viewModel) => (
        selectedNetwork: viewModel.selectedNetwork,
        networks: viewModel.networks,
      ),
      builder: (context, record, child) => NetworkSelection(
        selectedNetwork: record.selectedNetwork,
        actionType: WalletActionType.deposit,
        networks: record.networks,
        placeholderText: context.appLocaleLanguage.selectDepositNetwork,
        onNetworkSelected: context.read<DepositViewModel>().onNetworkSelected,
      ),
    );
  }
}
