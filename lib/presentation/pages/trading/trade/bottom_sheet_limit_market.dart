import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BottomSheetLimitMarket extends StatelessWidget {
  final String selectedValue;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const BottomSheetLimitMarket({
    Key? key,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).viewInsets.bottom + AppSize.size150.h;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSize.size20.w,
        right: AppSize.size20.w,
        bottom: bottomPadding,
        top: AppSize.size11.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: const HandleBar()),
          SizedBox(height: AppSize.size20.h),
          for (final option in options) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(option, style: AppTextStyles.content2),
              trailing: option == selectedValue
                  ? Icon(
                      Icons.check_circle_outline,
                      size: AppSize.size12,
                      color: AppColors.primary,
                    )
                  : null,
              onTap: () {
                onSelected(option);
                context.pop(context);
              },
            ),
            if (option != options.last) const Divider(height: AppSize.size1),
          ],
        ],
      ),
    );
  }
}
