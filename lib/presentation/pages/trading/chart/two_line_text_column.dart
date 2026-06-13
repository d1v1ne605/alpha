import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TwoLineTextColumn extends StatelessWidget {
  final String label;
  final String title;
  final Color color;
  final CrossAxisAlignment alignment;

  const TwoLineTextColumn({
    super.key,
    required this.label,
    required this.title,
    this.color = AppColors.grey,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: color),
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
        ),
        Text(
          title,
          style: AppTextStyles.caption.copyWith(color: color),
          textAlign: alignment == CrossAxisAlignment.end
              ? TextAlign.end
              : TextAlign.start,
        ),
      ],
    );
  }
}
