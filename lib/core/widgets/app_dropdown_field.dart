import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;
  final bool isRequire;
  final Widget? suffixIcon;

  const AppDropdownField({
    super.key,
    this.label,
    this.hintText,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.isRequire = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            children: [
              Text(
                label!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.size15.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              if (isRequire)
                Text(
                  AppStorageKey.requireChar,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: AppSize.size15.sp,
                  ),
                ),
            ],
          ),
        SizedBox(height: AppSize.size10.h),
        DropdownButtonFormField2<T>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.size8.r),
              borderSide: BorderSide(
                color: AppColors.borderInput,
                width: AppSize.size1.w,
              ),
            ),
            filled: true,
            fillColor: AppColors.transparent,
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSpacing.space14.h,
              horizontal: AppSpacing.space16.w,
            ),
            suffixIcon: suffixIcon,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: AppSize.size320.h,
            padding: EdgeInsets.symmetric(vertical: AppSpacing.space8.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSize.size8.r),
            ),
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: MaterialStateProperty.all(AppColors.hintText),
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_drop_down, color: AppColors.hintText),
          ),
          hint: hintText != null
              ? Text(
                  hintText!,
                  style: TextStyle(
                    color: AppColors.hintText,
                    fontSize: AppSize.size14.sp,
                  ),
                )
              : null,
          items: items,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: AppSize.size14.sp,
          ),
        ),
      ],
    );
  }
}
