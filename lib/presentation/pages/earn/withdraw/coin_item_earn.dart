import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CoinItemEarn extends StatelessWidget {
  final TextEditingController searchController;
  final List<EarnWalletData> filterCoins;
  final ValueChanged<String> onSearch;
  final ValueChanged<EarnWalletData> onCoinSelected;

  const CoinItemEarn({
    Key? key,
    required this.searchController,
    required this.filterCoins,
    required this.onSearch,
    required this.onCoinSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.space20.r),
      child: Column(
        children: [
          HandleBar(),
          SizedBox(height: AppSpacing.space18.h),
          AppTextField(
            controller: searchController,
            onChanged: (value) => onSearch(value.trim().toLowerCase()),
            prefixIcon: const Icon(Icons.search),
            hintText: context.appLocaleLanguage.search,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.size4.r),
              borderSide: BorderSide.none,
            ),
            fillColor: AppColors.backgroundSearch,
          ),
          SizedBox(height: AppSpacing.space12.h),
          Expanded(
            child: ListView.builder(
              itemCount: filterCoins.length,
              itemBuilder: (context, index) {
                final coin = filterCoins[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    onCoinSelected(coin);
                    context.pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.space15.h,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: AppSize.size17.r,
                          backgroundImage: NetworkImage(coin.iconUrl),
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: AppSpacing.space8.w),
                        Text(
                          coin.currencyId.toUpperCase(),
                          style: AppTextStyles.primaryLabel.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: AppSpacing.space8.w),
                        Text(
                          coin.currencyName,
                          style: AppTextStyles.primaryLabel.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.subtitleText,
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
