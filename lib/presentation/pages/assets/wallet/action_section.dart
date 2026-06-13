import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/asset/asset_detail_model.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/price_info_row_widget.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/view_models/asset/asset_detail_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ActionSection extends StatefulWidget {
  final AssetDetailModel asset;
  final AssetDetailViewModel viewModel;

  const ActionSection({
    super.key,
    required this.asset,
    required this.viewModel,
  });

  @override
  State<ActionSection> createState() => _ActionSectionState();
}

class _ActionSectionState extends State<ActionSection> {
  TextEditingController amountController = TextEditingController();
  final ValueNotifier<double> amount = ValueNotifier(0);

  @override
  void dispose() {
    amountController.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppButton(
          text: context.appLocaleLanguage.assetsButtonDeposit,
          fontWeight: FontWeight.w400,
          onPressed: () {
            context.push(
              RouterPath.deposit,
              extra: widget.asset.asset.id.toUpperCase(),
            );
          },
          width: AppSize.size123.w,
          height: AppSize.size38.h,
        ),
        AppButton(
          text: context.appLocaleLanguage.assetsButtonWithdraw,
          fontWeight: FontWeight.w400,
          onPressed: () {
            context.push(
              RouterPath.withdraw,
              extra: widget.asset.asset.id.toUpperCase(),
            );
          },
          width: AppSize.size123.w,
          height: AppSize.size38.h,
          backgroundColor: AppColors.tertiaryButton,
          borderColor: AppColors.primary,
        ),
        AppButton(
          text: context.appLocaleLanguage.rewards,
          fontWeight: FontWeight.w400,
          onPressed: () {
            _showRewardsBottomSheet(
              context,
              widget.viewModel,
              widget.asset.asset.id,
            );
          },
          width: AppSize.size123.w,
          height: AppSize.size38.h,
          backgroundColor: AppColors.tertiaryButton,
          borderColor: AppColors.primary,
        ),
      ],
    );
  }

  void _showRewardsBottomSheet(
    BuildContext context,
    AssetDetailViewModel vm,
    String assetId,
  ) {
    final product = vm.getFirstProductByAssetId(assetId);
    final earnWallet = vm.getFirstWalletByAssetId(assetId);

    if (product == null || earnWallet == null) {
      return;
    }
    AppBottomSheetWidget.show(
      context: context,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.space20,
          right: AppSpacing.space20,
        ),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.space10.h),
            HandleBar(),
            SizedBox(height: AppSpacing.space18.h),
            Text(
              context.appLocaleLanguage.earnRewards,
              style: AppTextStyles.title2.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: AppSpacing.space18.h),
            Row(
              children: [
                CircleAvatar(
                  radius: AppSize.size16.r,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.network(
                      product.iconUrl,
                      width: AppSize.size28.w,
                      height: AppSize.size30.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.space10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: AppSpacing.space8.h),
                    Text(
                      product.currencyId.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.content2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: AppSpacing.space14.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space10.w,
                        vertical: AppSpacing.space10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderCard),
                        borderRadius: BorderRadius.circular(AppSize.size4.r),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppSvg.earn,
                                width: AppSize.size24.w,
                                height: AppSize.size24.h,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: AppSpacing.space10.w),
                              Text(
                                context.appLocaleLanguage.holding,
                                style: AppTextStyles.content3.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          PriceInfoRowWidget(
                            label: context.appLocaleLanguage.apr,
                            value: product.annualRate,
                            valueColor: AppColors.green,
                            valueFontWeight: FontWeight.w600,
                            labelFontSize: AppSize.size12,
                          ),
                          SizedBox(height: 10.h),
                          PriceInfoRowWidget(
                            label: context.appLocaleLanguage.hourlyRate,
                            labelFontSize: AppSize.size12,
                            value: "${product.hourlyRate}%",
                            valueColor: AppColors.green,
                            valueFontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 10.h),
                          PriceInfoRowWidget(
                            label: context.appLocaleLanguage.minAmount,
                            labelFontSize: AppSize.size12,
                            value:
                                '${product.minAmount} ${product.currencyId.toUpperCase()}',
                            valueColor: AppColors.textPrimary,
                            valueFontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.space14.h),
                    _buildTextField(
                      hintText: context
                          .appLocaleLanguage
                          .enterAmountInToCalculateReward,
                      keyboardType: TextInputType.number,
                      suffixIcon: _buildAmountSuffix(context),
                      decimalLimit: 8,
                      controller: amountController,
                      amount: amount,
                    ),
                    SizedBox(height: AppSpacing.space14.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.size10.w,
                        vertical: AppSize.size10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderCard),
                        borderRadius: BorderRadius.circular(AppSize.size4.r),
                      ),
                      child: Column(
                        children: [
                          PriceInfoRowWidget(
                            label: context.appLocaleLanguage.earnBalance,
                            value:
                                '${earnWallet.balance} ${product.currencyId.toUpperCase()}',
                            valueColor: AppColors.textPrimary,
                            valueFontWeight: FontWeight.w600,
                            labelFontSize: AppSize.size12,
                          ),
                          SizedBox(height: 10.h),
                          PriceInfoRowWidget(
                            label: context.appLocaleLanguage.usdValue,
                            value:
                                "${context.appLocaleLanguage.prefixConvert}${earnWallet.usdtBalance}",
                            valueColor: AppColors.textPrimary,
                            labelFontSize: AppSize.size12,
                            valueFontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSpacing.space14.h),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.borderCard),
                        borderRadius: BorderRadius.circular(AppSize.size4.r),
                      ),
                      child: ValueListenableBuilder(
                        valueListenable: amount,
                        builder: (context, value, child) {
                          if (value <= 0) {
                            return const SizedBox.shrink();
                          }
                          final min =
                              double.tryParse(product.minAmount.toString()) ??
                              0;
                          double perHour;
                          if (value < min) {
                            perHour = 0;
                          } else {
                            perHour =
                                value *
                                ((double.tryParse(product.hourlyRate) ?? 0) /
                                    100);
                          }
                          final daily = perHour * 24;
                          final monthly = daily * 30;
                          final yearly = daily * 365;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.size10.w,
                              vertical: AppSize.size10.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.appLocaleLanguage.estimatedValue,
                                  style: AppTextStyles.content3.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.space14.h),
                                PriceInfoRowWidget(
                                  label: context.appLocaleLanguage.perHour,
                                  value:
                                      '${context.appLocaleLanguage.prefixConvert}${perHour.truncateToDecimalPlaces(widget.asset.asset.precision)} ${widget.asset.asset.symbol}',
                                  valueColor: AppColors.green,
                                  valueFontWeight: FontWeight.w600,
                                ),
                                SizedBox(height: AppSpacing.space10.h),
                                PriceInfoRowWidget(
                                  label: context.appLocaleLanguage.daily,
                                  value:
                                      '${context.appLocaleLanguage.prefixConvert}${daily.truncateToDecimalPlaces(widget.asset.asset.precision)} ${widget.asset.asset.symbol}',
                                  valueColor: AppColors.green,
                                  valueFontWeight: FontWeight.w600,
                                ),
                                SizedBox(height: AppSpacing.space10.h),
                                PriceInfoRowWidget(
                                  label: context.appLocaleLanguage.monthly,
                                  value:
                                      '${context.appLocaleLanguage.prefixConvert}${monthly.truncateToDecimalPlaces(widget.asset.asset.precision)} ${widget.asset.asset.symbol}',
                                  valueColor: AppColors.green,
                                  valueFontWeight: FontWeight.w600,
                                ),
                                SizedBox(height: AppSpacing.space10.h),
                                PriceInfoRowWidget(
                                  label: context.appLocaleLanguage.yearly,
                                  value:
                                      '${context.appLocaleLanguage.prefixConvert}${yearly.truncateToDecimalPlaces(widget.asset.asset.precision)} ${widget.asset.asset.symbol}',
                                  valueColor: AppColors.green,
                                  valueFontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.space30.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text:
                        "${context.appLocaleLanguage.buy} ${widget.asset.asset.symbol}",
                    fontWeight: FontWeight.w700,
                    onPressed: () {},
                    height: AppSize.size38.h,
                    backgroundColor: AppColors.background,
                    borderColor: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppSpacing.space28.w),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: amountController,
                    builder: (context, value, child) {
                      return AppButton(
                        text: context.appLocaleLanguage.assetsButtonWithdraw,
                        fontWeight: FontWeight.w700,
                        onPressed: () {
                          context.push(
                            RouterPath.withdraw_earn,
                            extra: widget.asset.asset.id.toUpperCase(),
                          );
                        },
                        isEnabled: value.text.isNotEmpty,
                        height: AppSize.size38.h,
                        backgroundColor: AppColors.primary,
                        borderColor: AppColors.primary,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.space50.h),
          ],
        ),
      ),
      maxChildSize: AppSize.size0_9,
      minChildSize: AppSize.size0_75,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    final String? Function(String?)? validator,
    int decimalLimit = 8,
    FocusNode? focusNode,
    required ValueNotifier<double> amount,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      style: AppTextStyles.content2.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      onChanged: (value) {
        final text = controller.text.trim();
        final parsed = double.tryParse(text) ?? 0;
        amount.value = parsed;
      },
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [FormatterUtils.decimalInputFormatter(decimalLimit)],
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
        errorBorder: _buildBorder().copyWith(
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: _buildBorder().copyWith(
          borderSide: BorderSide(color: AppColors.error),
        ),
        isDense: true,
        errorMaxLines: 2,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSize.size15.w,
          vertical: AppSize.size10.h,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.content2.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(),
      ),
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.size4.r),
      borderSide: BorderSide(color: AppColors.stock),
    );
  }

  Widget _buildAmountSuffix(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {
            amountController.text = widget.asset.asset.spot.toString();
            amount.value =
                double.tryParse(widget.asset.asset.spot.toString()) ?? 0;
          },
          child: Text(
            context.appLocaleLanguage.all,
            style: AppTextStyles.content2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
