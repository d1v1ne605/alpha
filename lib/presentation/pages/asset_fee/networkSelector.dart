import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkSelector extends StatelessWidget {
  final List<String> networks;
  final String? selected;
  final ValueChanged<String> onChanged;

  const NetworkSelector({
    super.key,
    required this.networks,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (AppSpacing.space10.w * 3)) / 4;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space15.w,
            vertical: AppSpacing.space10.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.stock,
            borderRadius: BorderRadius.circular(AppSpacing.space4.r),
          ),
          child: Wrap(
            runSpacing: AppSpacing.space8.h,
            children: networks.map((net) {
              final isActive = net == selected;
              return GestureDetector(
                onTap: () => onChanged(net),
                child: SizedBox(
                  width: itemWidth,
                  child: _buildNetworkButton(net, isActive: isActive),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildNetworkButton(String label, {bool isActive = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space10.w,
        vertical: AppSpacing.space4.h,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.space4.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.content2.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
