import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/earn/share_widget/custom_item_widget.dart';
import 'package:alpha/presentation/pages/earn/share_widget/list_section_generic.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EarnListSection extends StatelessWidget {
  const EarnListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EarnViewModel>(
      builder: (context, vm, child) => ValueListenableBuilder(
        valueListenable: vm.filteredWallets,
        builder: (context, wallets, child) => ListSectionGeneric(
          title: context.appLocaleLanguage.earnList,
          searchHint: context.appLocaleLanguage.search,
          isLoading: vm.isBusy,
          items: wallets,
          searchController: vm.searchController,
          onSearchChanged: vm.onSearchChanged,
          itemBuilder: (context, wallet, index) {
            return CustomItemWidget(
              wallet: wallet,
              isCheckEarn: true,
              onTap: () {
                vm.selectCoinWithdraw(wallet);
                context.push(
                  RouterPath.withdraw_earn,
                  extra: wallet.currencyId.toUpperCase(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
