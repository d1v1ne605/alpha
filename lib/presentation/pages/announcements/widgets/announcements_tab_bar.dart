import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

class AnnouncementsTabBar extends StatelessWidget {
  final TabController tabController;
  final List<Map<String, dynamic>> tabItems;

  const AnnouncementsTabBar({
    Key? key,
    required this.tabController,
    required this.tabItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: AppSpacing.space5.w),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: AppSize.size1, color: AppColors.primary),
        ),
        labelStyle: AppTextStyles.content4.copyWith(
          fontWeight: FontWeight.bold,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        tabs: tabItems
            .map((item) => Tab(text: item['label'].toString()))
            .toList(),
      ),
    );
  }
}
