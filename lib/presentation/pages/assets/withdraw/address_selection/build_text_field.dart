import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType keyboardType;
  const BuildTextField({
    super.key,
    required this.hint,
    this.controller,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hint,
      maxLength: maxLength,
      keyboardType: keyboardType,
      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
      textInputStyle: const TextStyle(color: Colors.white),
      borderRadius: 4,
      borderColor: AppColors.stock,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSize.size15.w,
        vertical: AppSize.size10.h,
      ),
      validator: validator,
    );
  }
}
