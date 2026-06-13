import 'package:alpha/core/mixins/two_fa_mixin/two_fa_mixin.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/two_fa/code_input_section.dart';
import 'package:alpha/core/widgets/two_fa/qr_code_section.dart';
import 'package:alpha/core/widgets/two_fa/store_links_text.dart';
import 'package:alpha/core/widgets/two_fa/two_fa_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_text_styles.dart';

class EnableTwoFa extends StatefulWidget {
  final TwoFAMixin vm;
  final bool autoFocus;
  final Function(String code) onSubmit;

  const EnableTwoFa({
    super.key,
    required this.vm,
    this.autoFocus = false,
    required this.onSubmit,
  });

  @override
  State<EnableTwoFa> createState() => _EnableTwoFaState();
}

class _EnableTwoFaState extends State<EnableTwoFa> {
  final TextEditingController codeController = TextEditingController();
  bool _isCodeValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.vm.generateQRCode();
    });
    codeController.addListener(() {
      final isValid = codeController.text.trim().length == 6;
      if (isValid != _isCodeValid) {
        setState(() {
          _isCodeValid = isValid;
        });
      }
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom + AppSize.size30.h;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSize.size20.w,
        right: AppSize.size20.w,
        bottom: bottomPadding,
        top: AppSize.size10.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.size68.w,
              height: AppSize.size2.h,
              decoration: BoxDecoration(
                color: AppColors.stock,
                borderRadius: BorderRadius.circular(AppSize.size8.r),
              ),
            ),
            SizedBox(height: AppSize.size18.h),
            Center(
              child: Text(
                context.appLocaleLanguage.enable2FAAuth,
                style: AppTextStyles.content5.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: AppSize.size40.h),
            QRCodeSection(vm: widget.vm),
            SizedBox(height: AppSize.size15.h),
            StoreLinksText(),
            SizedBox(height: AppSize.size15.h),
            CodeInputSection(codeController: codeController),
            SizedBox(height: AppSize.size30.h),
            TwoFaButton(
              isEnabled: _isCodeValid,
              onSubmit: () async {
                final code = codeController.text.trim();
                final success = await widget.onSubmit(code);
                return success;
              },
            ),
          ],
        ),
      ),
    );
  }
}
