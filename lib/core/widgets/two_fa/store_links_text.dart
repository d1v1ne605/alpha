import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_string_uri.dart';
import '../../constants/app_text_styles.dart';

class StoreLinksText extends StatelessWidget {
  const StoreLinksText({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: context.appLocaleLanguage.installGoogleAuthenticator,
            style: AppTextStyles.content4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: context.appLocaleLanguage.appStore,
            style: AppTextStyles.content4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openUrl(AppStringUri.appStore),
          ),
          TextSpan(
            text: context.appLocaleLanguage.or,
            style: AppTextStyles.content4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: context.appLocaleLanguage.googlePlay,
            style: AppTextStyles.content4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openUrl(AppStringUri.googlePlay),
          ),
        ],
      ),
    );
  }
}
