import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/announcements/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../routers/router_name.dart';
import '../../view_models/announcements/announcements_viewmodel.dart';
import 'announcement_detail_args.dart';

class SubTabView extends StatelessWidget {
  const SubTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AnnouncementsViewModel>(
      builder: (context, vm, _) {
        final subTabs = vm.currentSubTabs;
        final currentSubTabIndex = vm.currentSubTabIndex;
        final announcements = vm.currentFilteredAnnouncements;
        final languageCode = Localizations.localeOf(context).languageCode;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== SubTab buttons =====
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                left: AppSpacing.space20.w,
                bottom: AppSpacing.space15.h,
              ),
              child: Row(
                children: List.generate(subTabs.length, (index) {
                  final isSelected = currentSubTabIndex == index;
                  return Padding(
                    padding: EdgeInsets.only(right: AppSpacing.space15.w),
                    child: GestureDetector(
                      onTap: () => vm.changeSubTab(index),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space7.w,
                          vertical: AppSpacing.space2.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.backgroundMain
                              : AppColors.navBottom,
                          borderRadius: BorderRadius.circular(AppSize.size4.r),
                        ),
                        child: Text(
                          subTabs[index],
                          style: AppTextStyles.content2.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.iconPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: announcements.isEmpty
                  ? const Center(child: NoDataWidget())
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space20.w,
                      ),
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        final item = announcements[index];
                        final translation = item.translations.firstWhere(
                          (t) => t.language == languageCode,
                          orElse: () => item.translations.first,
                        );

                        return GestureDetector(
                          onTap: () {
                            final args = AnnouncementDetailArgs(
                              item: item,
                              tabTitle: vm.currentTab['label'],
                              subTabTitle: subTabs[currentSubTabIndex],
                            );
                            context.pushNamed(
                              RouterName.articleDetail,
                              extra: args,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: AppSpacing.space15.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  translation.headline,
                                  style: AppTextStyles.content2.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.space5.h),
                                Text(
                                  '${context.appLocaleLanguage.publishedOn} ${item.publishedAt}',
                                  style: AppTextStyles.content2.copyWith(
                                    color: AppColors.borderInput,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
