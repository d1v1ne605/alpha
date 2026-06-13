import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/mixins/launch_url/launch_url.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_bottom_sheet.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/bottom_sheet_community.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/coin_info_widget.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/common_button.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/price_info_row_widget.dart';
import 'package:alpha/presentation/view_models/home/home_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoinInforCrypto extends StatelessWidget with LaunchUrl {
  final CoinDetailModel? coin;

  const CoinInforCrypto({super.key, this.coin});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, child) {
        vm.setCryptoCoin(coin?.currencyId ?? '');
        final coinDetail = vm.coinDetail?.data;
        final change = FormatterUtils.toDoubleCleaned(
          coin?.price_change_percent,
        );
        final changeText = FormatterUtils.formatSignedPercentage(change);
        final isCorrectCoinDetail = coinDetail?.currencyId == coin?.currencyId;
        final updatedCoin = vm.coinsCrypto.firstWhere(
          (c) => c.id == coin?.id,
          orElse: () => coin!,
        );
        final shouldShowLoading =
            coin == null || coinDetail == null || !isCorrectCoinDetail;
        if (shouldShowLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(AppSpacing.space20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton(
                  text: context.appLocaleLanguage.assetsButtonDeposit,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    context.push(
                      RouterPath.deposit,
                      extra: coin!.id.toString().toUpperCase(),
                    );
                  },
                  size: AppButtonSizeEnum.large,
                  width: AppSize.size180.w,
                  height: AppSize.size38.h,
                ),
                AppButton(
                  text: context.appLocaleLanguage.trade,
                  fontWeight: FontWeight.w400,
                  onPressed: () {
                    final coinCrypto = vm.cryptoListCoin.first;
                    context.pushReplacement(
                      RouterPath.trade,
                      extra: coinCrypto,
                    );
                  },
                  size: AppButtonSizeEnum.large,
                  backgroundColor: AppColors.tertiaryButton,
                  borderColor: AppColors.primary,
                  width: AppSize.size180.w,
                  height: AppSize.size38.h,
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(AppSpacing.space20),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CoinInfoWidget(
                          iconPath: coin?.icon_url ?? AppImage.btc,
                          symbol: coinDetail.currencyId.toUpperCase(),
                          name: coinDetail.title,
                          date: FormatterUtils.formatDateYMD(
                            coinDetail.releaseDate,
                          ),
                          isStarred: updatedCoin.ishar,
                          onStarTap: () {
                            vm.toggleFavoriteCrypto(coin!.currencyId);
                          },
                        ),
                        const SizedBox(height: AppSpacing.space20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              CommonButton(
                                title:
                                    context.appLocaleLanguage.officialWebsite,
                                icon: AppSvg.link,
                                onTap: () {
                                  launchSocialUrl(coinDetail.officialWebsite);
                                },
                              ),
                              const SizedBox(width: AppSpacing.space8),
                              CommonButton(
                                title: coinDetail.blockchainExplorerDisplay,
                                icon: AppSvg.link,
                                onTap: () {
                                  launchSocialUrl(
                                    coinDetail.blockchainExplorerUrl,
                                  );
                                },
                              ),
                              const SizedBox(width: AppSpacing.space8),
                              CommonButton(
                                title: context.appLocaleLanguage.community,
                                icon: AppSvg.arrowdown,
                                onTap: () {
                                  AuthBottomSheetWidget.show(
                                    context: context,
                                    minChildSize: 0.60,
                                    child: BottomSheetCommunity(
                                      tokenSocials: coinDetail.tokenSocials,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: AppSpacing.space20),
                        Text(
                          "${coinDetail.currencyId.toUpperCase()} ${context.appLocaleLanguage.priceInfoToday}",
                          style: AppTextStyles.content2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space8),
                        Row(
                          children: [
                            Text(
                              coin?.last ?? '0.0',
                              style: AppTextStyles.content4.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space4),
                            Text(
                              context.appLocaleLanguage.usd.toUpperCase(),
                              style: AppTextStyles.content2.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.space24),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.space10,
                                vertical: AppSpacing.space4,
                              ),
                              decoration: BoxDecoration(
                                color: change >= 0
                                    ? AppColors.changeButton
                                    : AppColors.borderError,
                                borderRadius: BorderRadius.circular(
                                  AppSize.size4.r,
                                ),
                              ),
                              child: Text(
                                changeText,
                                style: AppTextStyles.smallTextButton.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.space20),
                        PriceInfoRowWidget(
                          label: context.appLocaleLanguage.lowerPriceLabel,
                          value: coin?.low ?? '0.0',
                        ),
                        PriceInfoRowWidget(
                          label: context.appLocaleLanguage.upperPriceLabel,
                          value: coin?.high ?? '0.0',
                        ),
                        PriceInfoRowWidget(
                          label: context.appLocaleLanguage.averagePriceLabel,
                          value: coin?.avg_price ?? '0.0',
                        ),
                        PriceInfoRowWidget(
                          label: context.appLocaleLanguage.openLabel,
                          value: coin?.open ?? '0.0',
                        ),
                        PriceInfoRowWidget(
                          label: context.appLocaleLanguage.volumeLabel,
                          value: coin?.volume ?? '0.0',
                        ),
                        PriceInfoRowWidget(
                          label: context.appLocaleLanguage.maxSupplyLabel,
                          value: coinDetail.maximumSupply,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          context.appLocaleLanguage.introduction,
                          style: AppTextStyles.title2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.space8),
                        Text(
                          coinDetail.information,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
