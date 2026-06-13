import 'package:alpha/core/constants/app_svg.dart';
import 'package:flutter/material.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WarningWidget extends StatelessWidget {
  final String text;

  const WarningWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(right: AppSpacing.space8),
          child: GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(AppSvg.info_warning),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.content2.copyWith(
              color: AppColors.subtitleText,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
