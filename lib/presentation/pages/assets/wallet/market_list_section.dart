import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MarketListSection extends StatelessWidget {
  final List<CoinModel> coins;

  const MarketListSection({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.appLocaleLanguage.marketList,
          style: AppTextStyles.content4.copyWith(color: AppColors.textPrimary),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: AppSpacing.space2_5,
              crossAxisSpacing: AppSpacing.space36.w,
              mainAxisSpacing: AppSpacing.space15.h,
            ),
            itemCount: coins.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  context.go(RouterPath.trade, extra: coins[index]);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundSearch,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.space0.h,
                    horizontal: AppSpacing.space0.w,
                  ),
                ),
                child: Text(
                  coins[index].name,
                  style: AppTextStyles.content2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
