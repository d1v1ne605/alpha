import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../constants/app_text_styles.dart';
import '../app_text_field.dart';

class CodeInputSection extends StatelessWidget {
  final TextEditingController codeController;

  const CodeInputSection({Key? key, required this.codeController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.appLocaleLanguage.openGoogle,
          style: AppTextStyles.content4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: AppSize.size15.h),
        Text(
          context.appLocaleLanguage.faCode,
          style: AppTextStyles.content4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: AppSize.size9.h),
        AppTextField(
          controller: codeController,
          hintText: context.appLocaleLanguage.faCode,
          keyboardType: TextInputType.number,
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.size4.r),
            borderSide: BorderSide(
              color: AppColors.stock,
              width: AppSize.size1.w,
            ),
          ),
        ),
      ],
    );
  }
}
