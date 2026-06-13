import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/two_fa/enable_two_fa.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/widget/show_2fa_for_api_key.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:flutter/material.dart';

class ApiKey2FAHandler {
  static Future<void> handleTwoFA({
    required BuildContext context,
    required ProfileViewModel vm,
    required String buttonText,
    required Future<void> Function(String otpCode) onVerified,
  }) async {
    if (vm.is2FAEnabled) {
      Show2FAForApiKey(
        context: context,
        buttonText: buttonText,
        onSubmit: (otpCode) async {
          await onVerified(otpCode);
          return Future.value(true);
        },
      );
    } else {
      AppBottomSheetWidget.show(
        minChildSize: 0.7,
        context: context,
        child: EnableTwoFa(
          vm: vm,
          onSubmit: (otpCode) async {
            final success = await vm.toggleTwoFA(
              twoFACode: otpCode,
              isEnable: true,
            );

            if (success && context.mounted) {
              Show2FAForApiKey(
                context: context,
                buttonText: buttonText,
                onSubmit: (otp) async {
                  await onVerified(otp);
                  return Future.value(true);
                },
              );
            }
            return success;
          },
        ),
      );
    }
  }
}
