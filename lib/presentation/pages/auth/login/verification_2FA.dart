import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/pages/auth/login/input_verification.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/view_models/auth/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection/injector.dart';

class Verification2FAWidget extends StatefulWidget {
  final bool autoFocus;
  final Function(String code) onSubmit;
  final String? title;
  final String? subtitle;
  final String? buttonText;
  final bool autoClose;

  const Verification2FAWidget({
    super.key,
    this.autoFocus = false,
    required this.onSubmit,
    this.title,
    this.subtitle,
    this.buttonText,
    this.autoClose = true,
  });

  @override
  State<Verification2FAWidget> createState() => _Verification2FAWidgetState();
}

class _Verification2FAWidgetState extends State<Verification2FAWidget> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {});
  }

  String get code => _controllers.map((controller) => controller.text).join();

  Future<void> _handleLoginPressed() async {
    // Clear all focus before closing
    for (final node in _focusNodes) {
      node.unfocus();
    }
    FocusScope.of(context).unfocus();
    final otp_code = code;
    if (otp_code.length == 6) {
      widget.onSubmit(otp_code);
      if (widget.autoClose) {
        if (!mounted) return;
        final vm = getIt<LoginViewModel>();
        if (vm.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(vm.errorMessage!)));
          vm.clearError();
        } else {
          context.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final screenHeight = mediaQuery.size.height;
    final availableHeight = screenHeight - keyboardHeight;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Material(
        color: AppColors.background,
        child: SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: isLandscape ? screenHeight : availableHeight * 0.8,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSize.size20.w,
                right: AppSize.size20.w,
                bottom: AppSize.size20.h,
                top: AppSize.size11.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HandleBar(),
                  SizedBox(height: AppSize.size20.h),
                  Text(
                    widget.title ?? context.appLocaleLanguage.verification2FA,
                    style: AppTextStyles.title2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSize.size5.h),

                  Text(
                    widget.subtitle ??
                        context.appLocaleLanguage.enter6DigitCode,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSize.size20.h),

                  // Generate 6 input fields
                  InputVerification(
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                    onChanged: _onChanged,
                    autoFocus: widget.autoFocus,
                  ),
                  SizedBox(height: AppSize.size25.h),

                  AppButton(
                    text:
                        widget.buttonText ??
                        context.appLocaleLanguage.loginButton,
                    size: AppButtonSizeEnum.medium,
                    isEnabled: code.length == 6,
                    onPressed: code.length == 6 ? _handleLoginPressed : null,
                  ),
                  SizedBox(height: AppSize.size16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
