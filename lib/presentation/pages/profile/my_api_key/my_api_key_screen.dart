import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/profile/appbar_screen.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/create_api_key_bottom_sheet.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/my_api_key_list_screen.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/widget/api_key_2fa_handler.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MyApiKeyScreen extends StatelessWidget {
  const MyApiKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      viewModelBuilder: () => getIt<ProfileViewModel>(),
      autoDispose: false,
      onModelReady: (vm) => vm.fetchApiKeys(),
      builder: (context, vm, _) => Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarScreen(
                    title: context.appLocaleLanguage.myApiKey,
                    showScan: false,
                    showNotification: false,
                  ),
                  SizedBox(height: AppSize.size10.h),
                  _buildCreateKeyButton(context, vm),
                  SizedBox(height: AppSize.size14.h),
                  const Expanded(child: MyApiKeyListScreen()),
                ],
              ),
            ),
            if (vm.isBusy)
              Container(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateKeyButton(BuildContext context, ProfileViewModel vm) {
    return Align(
      alignment: Alignment.centerRight,
      child: Selector<ProfileViewModel, bool>(
        selector: (_, vm) => vm.is2FAEnabled,
        builder: (_, is2FAEnabled, __) => GestureDetector(
          onTap: () => ApiKey2FAHandler.handleTwoFA(
            context: context,
            vm: vm,
            buttonText: context.appLocaleLanguage.confirm,
            onVerified: (otpCode) async {
              vm.createApiKey(
                totpCode: otpCode,
                onComplete: (apiKey) {
                  if (apiKey != null &&
                      vm.isApiKeyCreatedSuccess &&
                      context.mounted) {
                    AppBottomSheetWidget.show(
                      minChildSize: 0.55,
                      context: context,
                      child: CreatedApiKeyBottomSheet(
                        accessKey: apiKey.kid,
                        secretKey: apiKey.secret ?? "",
                      ),
                    );
                  } else {
                    context.showOverlayError(
                      context.appLocaleLanguage.apiKeyGenerationFailed,
                    );
                  }
                },
              );
            },
          ),
          child: SvgPicture.asset(AppSvg.addApiKey),
        ),
      ),
    );
  }
}
