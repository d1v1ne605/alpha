import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _TrophyData {
  final String asset;
  final Color color;

  const _TrophyData(this.asset, this.color);
}

class BuildTrophy extends StatelessWidget {
  final int top;

  const BuildTrophy({Key? key, required this.top}) : super(key: key);

  _TrophyData? get _trophyData {
    switch (top) {
      case 1:
        return _TrophyData(AppSvg.trophyGold, AppColors.gold);
      case 2:
        return _TrophyData(AppSvg.trophySilver, AppColors.silver);
      case 3:
        return _TrophyData(AppSvg.trophyBronze, AppColors.bronze);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _trophyData;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space9.w,
        vertical: AppSpacing.space4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        border: Border.all(
          color: data?.color ?? AppColors.primary,
          width: AppSize.size1.w,
        ),
        borderRadius: BorderRadius.circular(AppSize.size4.r),
      ),
      child: Row(
        children: [
          Visibility(
            visible: data != null,
            child: SvgPicture.asset(
              data?.asset ?? '',
              width: AppSize.size18.w,
              height: AppSize.size18.h,
            ),
          ),
          Visibility(
            visible: data != null,
            child: SizedBox(width: AppSpacing.space4.w),
          ),
          Text(
            '${context.appLocaleLanguage.prefixTopRank} $top',
            style: AppTextStyles.content2.copyWith(
              color: data?.color ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
