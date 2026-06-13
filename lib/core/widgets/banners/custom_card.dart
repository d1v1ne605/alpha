import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/banner_models/feature_card_model.dart';
import '../../../routers/router_name.dart';
import '../../constants/app_size.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_svg.dart';
import '../../constants/app_text_styles.dart';

class FeatureCardView extends StatelessWidget {
  const FeatureCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FeatureCardModel> _cards = [
      FeatureCardModel(
        iconAsset: AppSvg.spot,
        title: context.appLocaleLanguage.spotTrading,
        description: context.appLocaleLanguage.descriptionSpot,
        routeName: RouterName.trade,
      ),
      FeatureCardModel(
        iconAsset: AppSvg.alpha,
        title: context.appLocaleLanguage.alphaEarn,
        description: context.appLocaleLanguage.descriptionalpha,
        routeName: RouterName.earn,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final card = _cards[index];
        return Container(
          padding: EdgeInsets.all(AppSpacing.space12.w),
          margin: EdgeInsets.only(
            bottom: index == _cards.length - 1 ? 0 : AppSpacing.space20.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            border: Border.all(color: AppColors.stock),
          ),
          child: GestureDetector(
            onTap: () => {context.pushNamed(card.routeName)},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(card.iconAsset),
                    SizedBox(width: AppSpacing.space8.w),
                    Expanded(
                      child: Text(
                        card.title,
                        style: AppTextStyles.content5.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.space8.h),
                Text(
                  card.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.content2.copyWith(
                    color: AppColors.grey_40,
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
