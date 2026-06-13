import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/earn/withdraw/withdraw_earn_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BodyWithdrawEarnScreen extends StatefulWidget {
  const BodyWithdrawEarnScreen({Key? key}) : super(key: key);

  @override
  State<BodyWithdrawEarnScreen> createState() => _BodyWithdrawEarnScreenState();
}

class _BodyWithdrawEarnScreenState extends State<BodyWithdrawEarnScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: AppSize.size30.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSize.size20.w),
            child: Text(
              context.appLocaleLanguage.withdrawDetail,
              style: AppTextStyles.content3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(child: WithdrawEarnDetailScreen()),
        ],
      ),
    );
  }
}
