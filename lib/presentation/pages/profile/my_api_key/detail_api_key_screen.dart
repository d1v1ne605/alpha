import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/delete_apiKey_bottom_sheet.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/widget/api_key_2fa_handler.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/widget/api_key_status_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/base/base_view.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/my_api_key/api_key_model.dart';
import '../../../../injection/injector.dart';
import '../../../../presentation/view_models/profile/profile_view_model.dart';
import '../appbar_screen.dart';

class DetailApiKeyScreen extends StatelessWidget {
  final ApiKeyModel apiKey;

  const DetailApiKeyScreen({super.key, required this.apiKey});

  Widget _buildField(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.size15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.content3.copyWith(
              color: AppColors.subtitleText,
              fontWeight: FontWeight.w400,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.content3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String state) {
    final isActive = state.toLowerCase() == AppLocalKey.active;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size8.w,
        vertical: AppSize.size4.h,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.green_36 : AppColors.borderCard,
        borderRadius: BorderRadius.circular(AppSize.size4.r),
      ),
      child: Text(
        isActive ? AppLocalKey.active : AppLocalKey.disabled,
        style: AppTextStyles.content1.copyWith(
          color: isActive ? AppColors.green : AppColors.subtitleText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      viewModelBuilder: () => getIt<ProfileViewModel>(),
      autoDispose: false,
      builder: (context, vm, child) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarScreen(
                  title: context.appLocaleLanguage.apiKeyDetails,
                  showScan: false,
                  showNotification: false,
                ),
                SizedBox(height: AppSize.size20.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Selector<ProfileViewModel, String>(
                            selector: (_, vm) {
                              final found = vm.apiKeys.firstWhere(
                                (key) => key.kid == apiKey.kid,
                                orElse: () => apiKey,
                              );
                              return found.state;
                            },
                            builder: (context, state, child) {
                              return _buildStatusBadge(state);
                            },
                          ),

                          ApiKeyStatusSwitch(
                            apiKey: apiKey,
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
                                          context
                                              .appLocaleLanguage
                                              .apiKeyUpdateFailed,
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: AppSize.size15.h),

                      _buildField(context.appLocaleLanguage.kid, apiKey.kid),
                      _buildField(
                        context.appLocaleLanguage.algorithm,
                        apiKey.algorithm,
                      ),
                      _buildField(
                        context.appLocaleLanguage.created,
                        apiKey.createdAt.toIso8601String(),
                      ),
                      _buildField(
                        context.appLocaleLanguage.updated,
                        apiKey.updatedAt.toIso8601String(),
                      ),

                      SizedBox(height: AppSize.size30.h),

                      AppButton(
                        text: context.appLocaleLanguage.delete,
                        onPressed: () {
                          final vm = context.read<ProfileViewModel>();
                          vm.selectApiKey(apiKey.kid);

                          AppBottomSheetWidget.show(
                            context: context,
                            minChildSize: 0.6,
                            child: DeleteApiKeyBottomSheet(
                              parentContext: context,
                            ),
                          );
                        },
                        backgroundColor: AppColors.red,
                        size: AppButtonSizeEnum.small,
                      ),
                    ],
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
