import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/home_market/coin_model/list_top_coin.dart';
import 'package:alpha/data/models/home_market/coin_model/top_coin_display_data.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../presentation/view_models/home/home_view_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';

class CustomCoin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double coinColumnWidth = screenWidth / 3;

    return Selector<HomeViewModel, ListTopCoin>(
      selector: (context, viewModel) => ListTopCoin(
        coins: viewModel.coins.take(3).map((coin) {
          return TopCoinDisplayData(
            name: coin.name,
            lastPriceCurrency: coin.lastPrice,
            priceChangePercent: coin.priceChangePercent,
            coinObject: coin,
          );
        }).toList(),
      ),
      builder: (context, data, child) {
        if (data.coins.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(AppSpacing.space20.w),
            child: Text(
              context.appLocaleLanguage.noCoin,
              style: AppTextStyles.content3.copyWith(color: AppColors.grey),
            ),
          );
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: data.coins.map((coin) {
                final percentAndColor = getPercentAndColor(
                  coin.priceChangePercent,
                );
                final changeColor = percentAndColor.changeColor;
                final changePercent = percentAndColor.changePercent;
                return GestureDetector(
                  onTap: () {
                    context.go(RouterPath.trade, extra: coin.coinObject);
                  },
                  child: SizedBox(
                    width: coinColumnWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              coin.name,
                              style: AppTextStyles.content3.copyWith(
                                color: AppColors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(width: AppSpacing.space4.w),
                            Text(
                              changePercent,
                              style: AppTextStyles.content1.copyWith(
                                color: changeColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.space4.h),
                        Text(
                          '\$${FormatterUtils.formatTokenValue(value: double.parse(coin.lastPriceCurrency))}',
                          style: AppTextStyles.content1.copyWith(
                            color: changeColor,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  ({Color changeColor, String changePercent}) getPercentAndColor(
    String priceChangePercent,
  ) {
    final percent = FormatterUtils.toDoubleCleaned(priceChangePercent);

    final changeColor = percent >= 0 ? AppColors.green : AppColors.red;
    final changePercent = FormatterUtils.formatPercentage(percent / 100);
    return (changeColor: changeColor, changePercent: changePercent);
  }
}
