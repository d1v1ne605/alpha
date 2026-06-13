import 'dart:math';

import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_storage_key.dart';
import 'lang/config/app_locale_language.dart';

extension ContextExtensions on BuildContext {
  void showSuccessSnackBar(String message) async {
    if (!mounted) return;
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.size10),
        ),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.textWarning,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.size10),
        ),
      ),
    );
  }

  void showOverlayError(String message) {
    final overlay = Overlay.of(this, rootOverlay: true);
    if (overlay == null) return;
    final hightBottom = MediaQuery.of(this).viewInsets.bottom;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: AppSize.size30.h + hightBottom,
        left: AppSize.size20.w,
        right: AppSize.size20.w,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.size16.w,
              vertical: AppSize.size12.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.textWarning,
              borderRadius: BorderRadius.circular(AppSize.size4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppSvg.info_warning,
                  color: AppColors.white,
                  width: AppSize.size24.w,
                  height: AppSize.size24.h,
                ),
                SizedBox(width: AppSize.size8.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2)).then((_) => entry.remove());
  }

  Future<void> showErrorDialog(
    String message, {
    VoidCallback? onClosed,
    String? title,
    String? buttonText,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.size12.w.h),
        ),
        child: Container(
          padding: EdgeInsets.all(AppSize.size20.w.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error,
                color: AppColors.error,
                size: AppSize.size48.w.h,
              ),
              SizedBox(height: AppSize.size16.h),
              Text(
                title ?? AppStorageKey.anErrorOccurred,
                style: AppTextStyles.title2.copyWith(color: AppColors.error),
              ),
              SizedBox(height: AppSize.size8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.content2,
              ),
              SizedBox(height: AppSize.size20.h),
              AppButton(
                text: buttonText ?? AppStorageKey.closed,
                onPressed: () => Navigator.of(dialogContext).pop(),
                size: AppButtonSizeEnum.small,
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
      onClosed?.call();
    });
  }
}

extension TruncateDoubles on double {
  double truncateToDecimalPlaces(int fractionalDigits) =>
      (this * pow(10, fractionalDigits)).truncate() / pow(10, fractionalDigits);

  int get currentFractionalDigits {
    final str = toString();
    if (!str.contains('.')) return 0;
    return str.split('.')[1].length;
  }
}

extension StatusColorExt on String {
  Color getStatusColor(BuildContext context) {
    switch (toAppString(context)) {
      case AppStorageKey.processings:
        return AppColors.primary;
      case AppStorageKey.completeds:
        return AppColors.green;
      case AppStorageKey.blockchainError:
        return AppColors.red;
      case AppStorageKey.succeeds:
        return AppColors.green;
      case AppStorageKey.waitConfirmation:
        return AppColors.processing;
      case AppStorageKey.rejectedBySystem:
        return AppColors.red;
      case AppStorageKey.waitForConfirmation:
        return AppColors.fourth;
      case AppStorageKey.cancelByUserRequest:
        return AppColors.red;
      case AppStorageKey.waitWithdrawSubmit:
        return AppColors.processing;
      case AppStorageKey.pending:
        return AppColors.primary;
      case AppStorageKey.transferredOut:
        return AppColors.textError;
      case AppStorageKey.done:
        return AppColors.green;
      case AppStorageKey.cancel:
        return AppColors.red;
      case AppStorageKey.taker_type:
        return AppColors.green;
      case AppStorageKey.maker_type:
        return AppColors.red;
      case AppStorageKey.wait:
        return AppColors.primary;
      case AppStorageKey.denied:
        return AppColors.red;
      case AppStorageKey.processed:
        return AppColors.green;
      default:
        return AppColors.textPrimary;
    }
  }

  Color getStatusBgColor(BuildContext context) {
    switch (toAppString(context)) {
      case AppStorageKey.processings:
        return AppColors.processing;
      case AppStorageKey.completeds:
        return AppColors.bgcompleted;
      case AppStorageKey.succeeds:
        return AppColors.bgcompleted;
      case AppStorageKey.blockchainError:
        return AppColors.red_40;
      case AppStorageKey.collected:
        return AppColors.bgcompleted;
      case AppStorageKey.waitConfirmation:
        return AppColors.processing;
      case AppStorageKey.waitForConfirmation:
        return AppColors.blueGrey;
      case AppStorageKey.rejectedBySystem:
        return AppColors.red_40;
      case AppStorageKey.cancelByUserRequest:
        return AppColors.red_40;
      case AppStorageKey.waitApproveByAudit:
        return AppColors.processing;
      case AppStorageKey.waitWithdrawSubmit:
        return AppColors.processing;
      case AppStorageKey.pending:
        return AppColors.processing;
      case AppStorageKey.transferredOut:
        return AppColors.transferredOut;
      case AppStorageKey.done:
        return AppColors.bgcompleted;
      case AppStorageKey.wait:
        return AppColors.processing;
      case AppStorageKey.cancel:
        return AppColors.red_40;
      case AppStorageKey.denied:
        return AppColors.red_40;
      case AppStorageKey.processed:
        return AppColors.bgcompleted;
      default:
        return AppColors.primary;
    }
  }

  String toAppString(BuildContext context) {
    final lang = context.appLocaleLanguage;
    if (this == lang.processings) return AppStorageKey.processings;
    if (this == lang.completeds) return AppStorageKey.completeds;
    if (this == lang.succeeds) return AppStorageKey.succeeds;
    if (this == lang.blockchainError) return AppStorageKey.blockchainError;
    if (this == lang.collected) return AppStorageKey.collected;
    if (this == lang.waitConfirmation) return AppStorageKey.waitConfirmation;
    if (this == lang.waitForConfirmation)
      return AppStorageKey.waitForConfirmation;
    if (this == lang.rejectedBySystem) return AppStorageKey.rejectedBySystem;
    if (this == lang.cancelByUserRequest)
      return AppStorageKey.cancelByUserRequest;
    if (this == lang.waitApproveByAudit)
      return AppStorageKey.waitApproveByAudit;
    if (this == lang.waitWithdrawSubmit)
      return AppStorageKey.waitWithdrawSubmit;
    if (this == lang.pending) return AppStorageKey.pending;
    if (this == lang.transferredOut) return AppStorageKey.transferredOut;
    if (this == lang.done) return AppStorageKey.done;
    if (this == lang.wait) return AppStorageKey.wait;
    if (this == lang.cancel) return AppStorageKey.cancel;
    if (this == lang.denied) return AppStorageKey.denied;
    if (this == lang.processed) return AppStorageKey.processed;
    if (this == lang.pending) return AppStorageKey.pending;

    return this;
  }
}

extension StringExtensions on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get appLocaleLanguage => AppLocalizations.of(this)!;
}
