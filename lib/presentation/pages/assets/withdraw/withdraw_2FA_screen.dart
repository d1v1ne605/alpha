import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_bottom_sheet.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/enums.dart';
import '../../../../core/widgets/two_fa/enable_two_fa.dart';

class Withdraw2FAScreen extends StatelessWidget {
  const Withdraw2FAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WithdrawViewModel>(
      builder: (context, vm, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.appLocaleLanguage.withdrawEnable2FA,
                style: AppTextStyles.content2.copyWith(
                  color: AppColors.textFourth,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSize.size10.h),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: context.appLocaleLanguage.enable2FA,
                  fontWeight: FontWeight.w700,
                  onPressed: () async {
                    AuthBottomSheetWidget.show(
                      context: context,
                      minChildSize: 0.7,
                      child: EnableTwoFa(
                        vm: vm,
                        onSubmit: (code) async {
                          final result = await vm.toggleTwoFA(
                            twoFACode: code,
                            isEnable: true,
                          );
                          return result;
                        },
                      ),
                    );
                  },
                  borderRadius: AppSize.size8.r,
                  size: AppButtonSizeEnum.medium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
