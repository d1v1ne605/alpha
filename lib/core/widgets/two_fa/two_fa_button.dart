import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_button.dart';

class TwoFaButton extends StatelessWidget {
  final bool isEnabled;
  final Future<bool> Function() onSubmit;

  const TwoFaButton({
    super.key,
    required this.isEnabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: context.appLocaleLanguage.enable2FA,
      fontWeight: FontWeight.w700,
      onPressed: isEnabled
          ? () async {
              final success = await onSubmit();
              if (!context.mounted) return;
              if (success) {
                context.showSuccessSnackBar(
                  context.appLocaleLanguage.enable2FAsuccessful,
                );
                context.pop();
              } else {
                context.showOverlayError(
                  context.appLocaleLanguage.enable2FAFailed,
                );
              }
            }
          : null,
    );
  }
}
