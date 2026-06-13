import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_svg.dart';
import '../../../../core/constants/app_text_styles.dart';

class BreadcrumbWidget extends StatelessWidget {
  final String tabTitle;
  final String? subTabTitle;

  const BreadcrumbWidget({Key? key, required this.tabTitle, this.subTabTitle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [
      Text(
        context.appLocaleLanguage.announcement,
        style: AppTextStyles.content2,
      ),
      _arrowIcon(),
      Text(tabTitle, style: AppTextStyles.content2),
    ];

    if (subTabTitle != null && subTabTitle!.isNotEmpty) {
      items.addAll([
        _arrowIcon(),
        Text(subTabTitle!, style: AppTextStyles.content2),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space20),
      child: Row(children: items),
    );
  }

  Widget _arrowIcon() => Padding(
    padding: EdgeInsets.symmetric(horizontal: AppSpacing.space5.w),
    child: SvgPicture.asset(
      AppSvg.arrowDown,
      width: AppSize.size8.w,
      height: AppSize.size16.h,
    ),
  );
}
