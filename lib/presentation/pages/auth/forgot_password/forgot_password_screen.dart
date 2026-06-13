import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/auth/forgot_password/bottom_sheet_content.dart';
import 'package:alpha/presentation/pages/auth/forgot_password/forgot_password_form.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_bottom_sheet.dart';
import 'package:alpha/presentation/view_models/auth/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
      viewModelBuilder: () => getIt<ForgotPasswordViewModel>(),
      builder: (context, vm, child) {
        if (vm.showSheet) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            vm.triggerOpenSheet(false);
            await AuthBottomSheetWidget.show(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSize.size0.r),
                ),
              ),
              child: const ForgotPasswordBottomSheetContent(),
            );
          });
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            child: Column(
              children: [
                AppHeader(
                  textTitle: context.appLocaleLanguage.forgotPassword,
                  onTap: () => context.pop(),
                ),
                ForgotPasswordForm(),
              ],
            ),
          ),
        );
      },
    );
  }
}
