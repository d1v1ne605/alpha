import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/custom_card_favorites.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/presentation/view_models/home/home_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_button.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<HomeViewModel, List<CoinModel>>(
      selector: (context, viewModel) => viewModel.targetFavoriteCoins,
      builder: (context, targetFavoriteCoins, child) {
        if (targetFavoriteCoins.isEmpty) {
          return Center(child: CustomNoData());
        }
        return Container(
          color: AppColors.background,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space20.w,
            vertical: AppSpacing.space4.h,
          ),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: AppSpacing.space16.h,
                    bottom: AppSpacing.space24.h,
                  ),
                  itemCount: targetFavoriteCoins.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.space16.w,
                    mainAxisSpacing: AppSpacing.space16.h,
                    childAspectRatio: 1.78,
                  ),
                  itemBuilder: (context, index) {
                    final coin = targetFavoriteCoins[index];
                    return CustomCardFavorites(
                      title: coin.name,
                      price: double.parse(coin.lastPrice),
                      change: FormatterUtils.toDoubleCleaned(
                        coin.priceChangePercent.toString(),
                      ),
                      isFavorite: coin.ishar,
                      onFavoriteToggle: () {
                        context.read<HomeViewModel>().toggleFavorite(coin.id);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: AppSpacing.space30.h),
              AppButton(
                text: context.appLocaleLanguage.addFavoritesLabel,
                onPressed: () {
                  context.push(RouterPath.discover);
                },
                size: AppButtonSizeEnum.medium,
              ),

              SizedBox(height: AppSpacing.space35.h),
            ],
          ),
        );
      },
    );
  }
}
