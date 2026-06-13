import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_svg.dart';
import '../../../../core/widgets/app_text_field.dart';

class PasswordFieldInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;

  const PasswordFieldInput({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
  });

  @override
  State<PasswordFieldInput> createState() => _PasswordFieldInputState();
}

class _PasswordFieldInputState extends State<PasswordFieldInput> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: _obscure,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSize.size4.r),
        borderSide: BorderSide(
          color: AppColors.stock,
          width: AppSize.size0_5.w,
        ),
      ),
      suffixIcon: IconButton(
        icon: _obscure
            ? SvgPicture.asset(AppSvg.eyeHidden)
            : SvgPicture.asset(AppSvg.eyeVisible),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
