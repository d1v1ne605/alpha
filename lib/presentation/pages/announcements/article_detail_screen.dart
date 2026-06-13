import 'package:alpha/presentation/pages/announcements/widgets/announcement_body_widget.dart';
import 'package:alpha/presentation/pages/announcements/widgets/breadcrumb_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../core/base/base_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/banner_models/banner_model.dart';
import '../../view_models/announcements/announcements_viewmodel.dart';
import 'widgets/announcements_app_bar.dart';

class ArticleDetailScreen extends StatelessWidget {
  final BannerModel item;
  final String tabTitle;
  final String subTabTitle;

  const ArticleDetailScreen({
    super.key,
    required this.item,
    required this.tabTitle,
    required this.subTabTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<AnnouncementsViewModel>(
      viewModelBuilder: () => GetIt.I<AnnouncementsViewModel>(),
      onModelReady: (vm) {
        vm.loadTranslation(item);
      },
      builder: (context, vm, _) {
        final translation = vm.translation;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.space10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnnouncementsAppBar(),
                  SizedBox(height: AppSpacing.space20.h),
                  BreadcrumbWidget(
                    tabTitle: tabTitle,
                    subTabTitle: subTabTitle,
                  ),
                  SizedBox(height: AppSpacing.space15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space20.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translation?.headline ?? '',
                          style: AppTextStyles.content2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: AppSpacing.space15.h),
                        AnnouncementBodyWidget(
                          body: translation?.body ?? '',
                          photoUrl: item.photoUrl ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
