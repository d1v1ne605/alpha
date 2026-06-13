import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/assets/deposit/share/deposit_selection_bar.dart';
import 'package:alpha/presentation/pages/assets/share/network_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NetworkSelection extends StatelessWidget {
  final CurrencyModel? selectedNetwork;
  final List<CurrencyModel> networks;
  final ValueChanged<CurrencyModel> onNetworkSelected;
  final String? placeholderText;
  final WalletActionType actionType;

  const NetworkSelection({
    Key? key,
    required this.selectedNetwork,
    required this.networks,
    required this.onNetworkSelected,
    this.placeholderText,
    required this.actionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DepositSelectionBar(
      prefixContent: selectedNetwork != null
          ? Text(
              selectedNetwork!.blockchainName ?? '',
              style: AppTextStyles.primaryLabel.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            )
          : Text(
              placeholderText ?? "",
              style: AppTextStyles.content2.copyWith(color: AppColors.hintText),
            ),
      title: context.appLocaleLanguage.network,
      toggleOpenList: () {
        AppBottomSheetWidget.show(
          minChildSize: AppSize.size0_75,
          maxChildSize: AppSize.size0_9,
          context: context,
          child: NetworkItem(
            networks: networks,
            onNetworkSelected: (network) {
              onNetworkSelected(network);
              context.pop();
            },
            actionType: actionType,
          ),
        );
      },
    );
  }
}
