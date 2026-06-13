import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/asset/asset_detail_model.dart';
import 'package:alpha/data/models/asset/asset_model.dart';
import 'package:alpha/data/models/mockdata/asset_mockdata.dart';
import 'package:alpha/presentation/pages/earn/share_widget/custom_item_widget.dart';
import 'package:alpha/presentation/pages/earn/share_widget/list_section_generic.dart';
import 'package:alpha/presentation/view_models/asset/asset_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WalletListSection extends StatelessWidget {
  const WalletListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetViewModel>(
      builder: (context, vm, child) {
        return ValueListenableBuilder<List<AssetModel>>(
          valueListenable: vm.filteredItemsNotifier,
          builder: (context, filteredAssets, _) {
            return ListSectionGeneric(
              title: context.appLocaleLanguage.assetsListTitle,
              searchHint: context.appLocaleLanguage.search,
              isLoading: vm.isBusy,
              items: filteredAssets,
              searchController: vm.searchController,
              onSearchChanged: vm.onSearchChanged,
              itemBuilder: (context, wallet, index) {
                return CustomItemWidget(
                  wallet: wallet,
                  onTap: () {
                    context.push(
                      '${RouterPath.assets}/${RouterPath.assetDetail}',
                      extra: AssetDetailModel(
                        asset: wallet,
                        overview: vm.assetOverview ?? defaultValue,
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
