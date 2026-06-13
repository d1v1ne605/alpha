import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/presentation/pages/assets/deposit/share/deposit_selection_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinSelectionEarn extends StatelessWidget {
  final EarnWalletData? selectedCoin;
  final VoidCallback onOpenList;

  const CoinSelectionEarn({
    Key? key,
    required this.selectedCoin,
    required this.onOpenList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DepositSelectionBar(
      prefixContent: selectedCoin != null
          ? Row(
              children: [
                Image.network(
                  selectedCoin!.iconUrl,
                  fit: BoxFit.cover,
                  width: AppSpacing.space24.w,
                  height: AppSpacing.space24.h,
                ),
                SizedBox(width: AppSpacing.space10.w),
                Text(
                  selectedCoin!.currencyId.toUpperCase(),
                  style: AppTextStyles.primaryLabel.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: AppSpacing.space10.w),
                Text(
                  selectedCoin!.currencyName,
                  style: AppTextStyles.primaryLabel.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.subtitleText,
                  ),
                ),
              ],
            )
          : Text(
              context.appLocaleLanguage.chooseAvailableCoin,
              style: AppTextStyles.content2.copyWith(color: AppColors.hintText),
            ),
      title: context.appLocaleLanguage.coin,
      toggleOpenList: onOpenList,
    );
  }
}
