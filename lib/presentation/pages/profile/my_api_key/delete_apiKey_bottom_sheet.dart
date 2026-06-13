import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/widget/api_key_2fa_handler.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../change_pasword/handle_bar.dart';

class DeleteApiKeyBottomSheet extends StatelessWidget {
  final BuildContext parentContext;
  const DeleteApiKeyBottomSheet({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      autoDispose: false,
      viewModelBuilder: () => getIt<ProfileViewModel>(),
      builder: (context, vm, child) {
        final kid = vm.selectedApiKeyKid;
        if (kid == null) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.space8.r),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppSpacing.space10.h),
                HandleBar(),
                SizedBox(height: AppSpacing.space20.h),
                SvgPicture.asset(AppSvg.top_warning),
                SizedBox(height: AppSpacing.space15.h),
                _buildTitle(context),
                SizedBox(height: AppSpacing.space10.h),
                _buildMessage(context),
                SizedBox(height: AppSpacing.space30.h),
                _buildActions(context, vm, kid),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) => Text(
    context.appLocaleLanguage.deleteApiKey,
    style: AppTextStyles.content4.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildMessage(BuildContext context) => Text(
    context.appLocaleLanguage.deleteApiKeyQuestion,
    style: AppTextStyles.content2.copyWith(
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    textAlign: TextAlign.center,
  );

  Widget _buildActions(BuildContext context, ProfileViewModel vm, String kid) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            backgroundColor: AppColors.background,
            borderColor: AppColors.primary,
            text: context.appLocaleLanguage.cancel,
            size: AppButtonSizeEnum.small,
            onPressed: () => context.pop(),
          ),
        ),
        SizedBox(width: AppSpacing.space30.w),
        Expanded(
          child: AppButton(
            text: context.appLocaleLanguage.delete,
            size: AppButtonSizeEnum.small,
            onPressed: () {
              final errorMessage =
                  context.appLocaleLanguage.apiKeyDeletionFailed;
              context.pop();
              ApiKey2FAHandler.handleTwoFA(
                context: parentContext,
                vm: vm,
                buttonText: context.appLocaleLanguage.delete,
                onVerified: (otpCode) async {
                  vm.deleteApiKeyWithOtp(
                    kid: kid,
                    otpCode: otpCode,
                    onComplete: (success) {
                      if (success) {
                        parentContext.pop();
                      } else {
                        parentContext.showOverlayError(errorMessage);
                      }
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
