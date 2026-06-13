import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/auth/register_body_request_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/auth/choose-language/show_countries.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_header.dart';
import 'package:alpha/presentation/view_models/auth/choose_language_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final RegisterBodyRequest bodyFromRegister;

  const ChooseLanguageScreen({super.key, required this.bodyFromRegister});

  @override
  Widget build(BuildContext context) {
    return BaseView<ChooseLanguageViewModel>(
      viewModelBuilder: () {
        final vm = getIt<ChooseLanguageViewModel>();
        vm.init(bodyFromRegister);
        return vm;
      },
      builder: (context, vm, child) => Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.space20.w,
                  right: AppSpacing.space20.w,
                  top: AppSpacing.space15.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.space15.h),
                    AuthHeader(
                      textAction: context.appLocaleLanguage.backLabel,
                      onTap: () {
                        context.pop();
                      },
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: AppSize.size25.h,
                        ),
                        child: Column(
                          children: [
                            Text(
                              context.appLocaleLanguage.authHeading,
                              style: AppTextStyles.heading2.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: AppSpacing.space10.h),
                            Text(
                              context.appLocaleLanguage.registerSubheading,
                              style: AppTextStyles.subtitle.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              context.appLocaleLanguage.language,
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '*',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textWarning,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.space10.h),
                        ShowCountries(),
                        SizedBox(height: AppSpacing.space15.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              shape: const CircleBorder(),
                              value: vm.isChecked,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                vm.setChecked(value);
                              },
                              side: const BorderSide(
                                color: AppColors.stock,
                                width: 2,
                              ),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            SizedBox(width: AppSpacing.space10.w),
                            Expanded(
                              child: Text(
                                context.appLocaleLanguage.chooseLanguageConfirm,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.space15.h),
                        AppButton(
                          text: context.appLocaleLanguage.registerButton,
                          fontWeight: FontWeight.w700,
                          onPressed: () async {
                            final message = await vm.handleNextPressed(context);
                            if (message ==
                                    context
                                        .appLocaleLanguage
                                        .chooseLanguageValidate ||
                                message ==
                                    context
                                        .appLocaleLanguage
                                        .chooseLanguageValidate2) {
                              context.showErrorSnackBar(message!);
                              return;
                            }
                            if (message == null) {
                              context.go(RouterPath.login, extra: vm.email);
                              return;
                            }
                            context.showErrorSnackBar(message);
                            context.pop();
                          },
                          size: AppButtonSizeEnum.medium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (vm.isBusy)
                Positioned.fill(
                  child: Container(
                    color: AppColors.background.withOpacity(AppSize.size0_4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
