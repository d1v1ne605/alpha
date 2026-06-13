import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/presentation/pages/stakes/stake/stake_bottom_sheet.dart';
import 'package:alpha/presentation/pages/stakes/stake/widget/striped_linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/stake/stake_view_model.dart';

class StakingProductCard extends StatelessWidget {
  final StakeProductResponse product;
  final String logoUrl;
  final String aprRange;
  final List<StakeProduct> sortedOptions;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(StakeProduct) onOptionSelected;
  final Function(StakeProduct) getProgressValue;
  final Function(StakeProduct, String) getProgressText;

  const StakingProductCard({
    Key? key,
    required this.product,
    required this.logoUrl,
    required this.aprRange,
    required this.sortedOptions,
    required this.isExpanded,
    required this.onToggle,
    required this.onOptionSelected,
    required this.getProgressValue,
    required this.getProgressText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.size4.r),
        side: const BorderSide(color: AppColors.stock, width: AppSize.size0_5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(onTap: onToggle, child: _buildHeader(context)),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: _buildBody(context),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space16.w,
        vertical: AppSpacing.space10.h,
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: AppSize.size16.r,
                backgroundColor: AppColors.transparent,
                backgroundImage: (logoUrl.isNotEmpty)
                    ? NetworkImage(logoUrl)
                    : AssetImage(AppImage.btc),
              ),
              const SizedBox(width: AppSpacing.space12),
              Text(
                product.currencyId.toUpperCase(),
                style: AppTextStyles.content4,
              ),
            ],
          ),
          const Spacer(),
          if (!isExpanded)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.appLocaleLanguage.apr,
                  style: AppTextStyles.content2.copyWith(
                    color: AppColors.stock,
                  ),
                ),
                const SizedBox(width: AppSpacing.space4),
                Text(
                  aprRange,
                  style: AppTextStyles.primaryLabel.copyWith(
                    color: AppColors.changeButton,
                  ),
                ),
              ],
            ),
          const Spacer(),
          Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space16.w),
          child: Divider(
            color: AppColors.stock,
            height: AppSize.size1,
            thickness: AppSize.size0_5,
          ),
        ),
        ...sortedOptions.map((option) => _buildStakingRow(option, context)),
      ],
    );
  }

  Widget _buildStakingRow(StakeProduct option, BuildContext context) {
    final double progressValue = getProgressValue(option);
    final String progressText = getProgressText(option, product.currencyId);
    return InkWell(
      onTap: () => onOptionSelected(option),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space16.w,
          vertical: AppSpacing.space12.h,
        ),
        child: Row(
          children: [
            SizedBox(
              width: AppSize.size80.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${option.aprBase}%',
                    style: AppTextStyles.content2.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${option.lockDays} ${context.appLocaleLanguage.days}',
                    style: AppTextStyles.content2.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space16),
            Expanded(
              child: Column(
                children: [
                  StripedLinearProgressIndicator(
                    value: progressValue,
                    height: AppSize.size10.h,
                    backgroundColor: AppColors.stock,
                    stripeColor: AppColors.primaryButton,
                    stripeColorSecondary: AppColors.indicator,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  Text(
                    progressText,
                    style: AppTextStyles.content2.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Consumer<StakeViewModel>(
              builder: (context, vm, _) => Padding(
                padding: EdgeInsets.only(left: AppSpacing.space16.w),
                child: GestureDetector(
                  onTap: () {
                    vm.selectOption(option);
                    StakeBottomSheet.show(context, vm: vm);
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: AppSize.size16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
