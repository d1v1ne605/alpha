import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/assets/deposit/share/deposit_selection_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinSelection extends StatelessWidget {
  final CurrencyModel? selectedCoin;
  final VoidCallback onOpenList;

  const CoinSelection({
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
                  selectedCoin!.icon_url,
                  fit: BoxFit.cover,
                  width: AppSpacing.space24.w,
                  height: AppSpacing.space24.h,
                ),
                SizedBox(width: AppSpacing.space10.w),
                Text(
                  selectedCoin!.id.toUpperCase(),
                  style: AppTextStyles.primaryLabel.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: AppSpacing.space10.w),
                Text(
                  selectedCoin!.name,
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
