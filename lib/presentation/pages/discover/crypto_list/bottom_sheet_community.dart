import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/mixins/launch_url/launch_url.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/get_data_record.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/price_info_row_widget.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetCommunity extends StatelessWidget with LaunchUrl {
  final List<TokenSocial> tokenSocials;

  const BottomSheetCommunity({super.key, required this.tokenSocials});

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom + AppSize.size150.h;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSize.size20.w,
        right: AppSize.size20.w,
        bottom: bottomPadding,
        top: AppSize.size11.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HandleBar(),
          SizedBox(height: AppSize.size20.h),
          Center(
            child: Text(
              context.appLocaleLanguage.community,
              style: AppTextStyles.mediumTextButton.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: AppSize.size30.h),
          ...tokenSocials.map((social) {
            return PriceInfoRowWidget(
              verticalPadding: AppSpacing.space18.h,
              label: RecordHelper.readableSocialLabel(
                social.socialType ?? '',
                context,
              ),
              value: SvgPicture.asset(
                AppSvg.link,
                width: AppSize.size20.w,
                height: AppSize.size20.h,
              ),
              labelColor: AppColors.textPrimary,
              valueColor: AppColors.textTertiary,
              onTap: () {
                launchSocialUrl(social.url ?? '');
              },
            );
          }),
        ],
      ),
    );
  }
}
