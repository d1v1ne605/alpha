import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/two_fa/enable_two_fa.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_bottom_sheet.dart';
import 'package:alpha/presentation/pages/profile/account_security/build_info_row.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../auth/login/verification_2FA.dart';
import '../change_pasword/change_password_bottom_sheet.dart';

class HeaderAccountSecurityScreen extends StatelessWidget {
  const HeaderAccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (BuildContext context, ProfileViewModel vm, Widget? child) {
        final email = vm.currentUser?.email ?? '';
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            border: Border.all(
              color: AppColors.stock,
              width: AppSize.size0_5.w,
            ),
          ),
          child: Column(
            children: [
              BuildInfoRow(
                label: context.appLocaleLanguage.email,
                value: email,
                trailingText: SvgPicture.asset(
                  AppSvg.next,
                  width: AppSize.size9.w,
                  height: AppSize.size18.h,
                ),
                valueStyle: AppTextStyles.content3.copyWith(
                  color: AppColors.subtitleText,
                  fontWeight: FontWeight.w500,
                ),
                valueAlign: TextAlign.right,
                onTrailingTap: () {
                  context.pushNamed(RouterName.infomation);
                },
              ),
              Divider(color: AppColors.stock, height: AppSize.size0_5.h),
              BuildInfoRow(
                label: context.appLocaleLanguage.password,
                value: "",
                valuePass: '************',
                trailingText: Text(
                  context.appLocaleLanguage.change,
                  style: AppTextStyles.content3.copyWith(
                    color: AppColors.subtitleText,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                valueAlign: TextAlign.left,
                onTrailingTap: () {
                  AuthBottomSheetWidget.show(
                    context: context,
                    minChildSize: 0.60,
                    child: const ChangePasswordBottomSheet(),
                  );
                },
              ),
              Divider(color: AppColors.stock, height: AppSize.size0_5.h),
              BuildInfoRow(
                label: context.appLocaleLanguage.twoFactorAuthentication,
                value: '',
                trailingText: Text(
                  vm.isTwoFAEnabled
                      ? context.appLocaleLanguage.disable
                      : context.appLocaleLanguage.enable,
                  style: AppTextStyles.content3.copyWith(
                    color: AppColors.subtitleText,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),

                onTrailingTap: () {
                  if (vm.isTwoFAEnabled) {
                    AuthBottomSheetWidget.show(
                      context: context,
                      child: Verification2FAWidget(
                        buttonText: context.appLocaleLanguage.disable2FA,
                        autoClose: false,
                        onSubmit: (code) async {
                          final result = await vm.toggleTwoFA(
                            twoFACode: code,
                            isEnable: false,
                          );
                          if (result) {
                            context.pop();
                          } else {
                            context.showOverlayError(
                              context.appLocaleLanguage.incorrectTwoFACode,
                            );
                          }
                        },
                      ),
                    );
                  } else {
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
                  }
                },
              ),
              Divider(color: AppColors.stock, height: AppSize.size0_5.h),
              BuildInfoRow(
                label: context.appLocaleLanguage.myApiKey,
                value: "",
                trailingText: SvgPicture.asset(
                  AppSvg.next,
                  width: AppSize.size9.w,
                  height: AppSize.size18.h,
                ),
                valueAlign: TextAlign.left,
                onTap: () {
                  context.pushNamed(RouterName.myApiKey);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
