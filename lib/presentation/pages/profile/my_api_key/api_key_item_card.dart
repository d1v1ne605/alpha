import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/widget/api_key_2fa_handler.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/widget/api_key_status_switch.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_svg.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/my_api_key/api_key_model.dart';

class ApiKeyItemCard extends StatelessWidget {
  final ApiKeyModel apiKey;
  final int index;

  const ApiKeyItemCard({super.key, required this.apiKey, required this.index});

  Widget _buildField({
    required String label,
    required String value,
    required CrossAxisAlignment alignment,
    double flex = 1,
  }) {
    return Expanded(
      flex: flex.toInt(),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            label,
            style: AppTextStyles.content2.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: AppSize.size5.h),
          Text(
            value,
            style: AppTextStyles.content3.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWithWidget({
    required String label,
    required Widget valueWidget,
    required CrossAxisAlignment alignment,
    double flex = 1,
  }) {
    return Expanded(
      flex: flex.toInt(),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            label,
            style: AppTextStyles.content2.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: AppSize.size5.h),
          valueWidget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.size10.h,
        horizontal: AppSize.size10.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildField(
            label: context.appLocaleLanguage.algorithm,
            value: apiKey.algorithm,
            alignment: CrossAxisAlignment.start,
            flex: 3,
          ),

          _buildField(
            label: context.appLocaleLanguage.kid,
            value: apiKey.kid,
            alignment: CrossAxisAlignment.start,
            flex: 5,
          ),

          _buildFieldWithWidget(
            label: context.appLocaleLanguage.status,
            alignment: CrossAxisAlignment.center,
            flex: 2,
            valueWidget: Selector<ProfileViewModel, String>(
              selector: (_, vm) {
                final found = vm.apiKeys.firstWhere(
                  (key) => key.kid == apiKey.kid,
                  orElse: () => apiKey,
                );
                return found.state;
              },
              builder: (context, state, _) {
                return ApiKeyStatusSwitch(
                  apiKey: apiKey.copyWith(state: state),
                  onToggle: (newValue) {
                    final vm = context.read<ProfileViewModel>();

                    ApiKey2FAHandler.handleTwoFA(
                      context: context,
                      vm: vm,
                      buttonText: context.appLocaleLanguage.disable,
                      onVerified: (otpCode) async {
                        vm.updateApiKeyStatusWithOtp(
                          kid: apiKey.kid,
                          state: newValue,
                          otpCode: otpCode,
                          onComplete: (success) {
                            if (!success) {
                              context.showOverlayError(
                                context.appLocaleLanguage.apiKeyUpdateFailed,
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          Expanded(
            flex: 1,
            child: Center(child: SvgPicture.asset(AppSvg.next)),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.size14.h),
      child: InkWell(
        onTap: () {
          context.pushNamed(RouterName.detailApiKey, extra: apiKey);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.size10.r),
            border: Border.all(color: AppColors.stock),
          ),
          child: cardContent,
        ),
      ),
    );
  }
}
