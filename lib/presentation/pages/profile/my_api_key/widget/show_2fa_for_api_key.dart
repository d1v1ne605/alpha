import 'package:flutter/material.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/presentation/pages/auth/login/verification_2FA.dart';
import 'package:go_router/go_router.dart';

Future<bool> Show2FAForApiKey({
  required BuildContext context,
  String? buttonText,
  required Future<bool> Function(String otpCode) onSubmit,
}) async {
  bool success = false;

  await Future.delayed(const Duration(milliseconds: 100));
  if (!context.mounted) return false;

  await AppBottomSheetWidget.show(
    context: context,
    child: Verification2FAWidget(
      buttonText: buttonText,
      autoClose: false,
      onSubmit: (code) async {
        final result = await onSubmit(code);
        success = result;
        if (result && context.mounted) {
          context.pop();
        }
        return result;
      },
    ),
  );

  if (context.mounted) FocusScope.of(context).unfocus();

  return success;
}
