import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum WalletActionType { deposit, withdraw }

class NetworkItem extends StatelessWidget {
  final List<CurrencyModel> networks;
  final ValueChanged<CurrencyModel> onNetworkSelected;
  final WalletActionType actionType;

  const NetworkItem({
    Key? key,
    required this.networks,
    required this.onNetworkSelected,
    required this.actionType,
  }) : super(key: key);

  bool _isNetworkEnabled(CurrencyModel network) {
    if (actionType == WalletActionType.deposit) {
      return network.deposit_enabled ?? false;
    } else {
      return network.withdrawal_enabled ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.space20.r),
      child: Column(
        children: [
          HandleBar(),
          SizedBox(height: AppSpacing.space10.h),
          Align(
            alignment: Alignment.center,
            child: Text(
              context.appLocaleLanguage.selectNetwork,
              style: AppTextStyles.title2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.space20.h),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppSpacing.space25.h),
              itemCount: networks.length,
              itemBuilder: (context, index) {
                final network = networks[index];
                final enabled = _isNetworkEnabled(network);
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onNetworkSelected(network),
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.space15.r),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSpacing.space8.r),
                      border: Border.all(
                        color: AppColors.borderCard,
                        width: AppSpacing.space1.w,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          enabled
                              ? (network.blockchainName ?? '')
                              : '${network.blockchainName ?? ''} - ${context.appLocaleLanguage.disabled}',
                          style: AppTextStyles.title2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
