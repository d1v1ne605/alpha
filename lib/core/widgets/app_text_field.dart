import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatefulWidget {
  final TextStyle? textInputStyle;
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;
  final bool readOnly;
  final TextStyle? suffixTextStyle;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Color? fillColor;
  final bool isRequire;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final InputBorder? border;
  final int? borderRadius;
  final Widget? suffix;
  final EdgeInsetsGeometry? contentPadding;
  final Color? borderColor;
  final InputBorder? focusedBorder;
  final bool isDense;
  final List<TextInputFormatter>? inputFormatter;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;

  const AppTextField({
    super.key,
    this.label,
    this.focusNode,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isRequire = false,
    this.onChanged,
    this.fillColor,
    this.keyboardType,
    this.labelText,
    this.suffixText,
    this.suffixTextStyle,
    this.textInputStyle,
    this.labelTextStyle,
    this.floatingLabelBehavior,
    this.border,
    this.borderRadius,
    this.suffix,
    this.contentPadding,
    this.borderColor,
    this.focusedBorder,
    this.isDense = false,
    this.inputFormatter,
    this.maxLength,
    this.maxLengthEnforcement,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.label!,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (widget.isRequire)
                    Text(
                      '* ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textWarning,
                      ),
                    ),
                ],
              ),
              SizedBox(height: AppSize.size10.h),
            ],
          ),
        TextFormField(
          readOnly: widget.readOnly,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          inputFormatters: widget.inputFormatter != null
              ? widget.inputFormatter!
              : [],
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: widget.focusNode,
          controller: widget.controller,
          obscureText: widget.obscureText,
          scrollPadding: EdgeInsets.only(bottom: 200),
          style: widget.textInputStyle ?? AppTextStyles.primaryLabel,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            labelText: widget.labelText,
            labelStyle: widget.labelTextStyle ?? AppTextStyles.content1,
            floatingLabelBehavior:
                widget.floatingLabelBehavior ?? FloatingLabelBehavior.auto,
            hintStyle: AppTextStyles.primaryLabel.copyWith(
              color: AppColors.hintText,
              fontWeight: FontWeight.w300,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            suffixText: widget.suffixText,
            suffixStyle: widget.suffixTextStyle ?? AppTextStyles.content2,
            suffix: widget.suffix,
            filled: true,
            fillColor: widget.fillColor ?? AppColors.transparent,
            enabledBorder:
                widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                  borderSide: BorderSide(
                    color: widget.borderColor ?? AppColors.borderInput,
                    width: AppSize.size1.w,
                  ),
                ),
            isDense: widget.isDense,
            contentPadding:
                widget.contentPadding ??
                EdgeInsets.symmetric(
                  vertical: AppSize.size14.h,
                  horizontal: AppSize.size16.w,
                ),
            border:
                widget.border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                  borderSide: BorderSide(
                    color: AppColors.checkPasswordWeak, // Default border color
                    width: AppSize.size1.w,
                  ),
                ),
            focusedBorder:
                widget.focusedBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                  borderSide: BorderSide(
                    color: AppColors.checkPasswordMedium,
                    width: AppSize.size2.w,
                  ),
                ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.size8.r),
              borderSide: BorderSide(
                color: AppColors.borderError,
                width: AppSize.size2.w,
              ),
            ),
            errorStyle: TextStyle(
              color: AppColors.textError, // Change error text color here
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
