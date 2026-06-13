import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/banner_models/translation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/banner_models/banner_model.dart';
import '../../../presentation/pages/announcements/announcement_detail_args.dart';
import '../../../presentation/view_models/announcements/announcements_viewmodel.dart';
import '../../../presentation/view_models/home/home_view_model.dart';
import '../../../routers/router_name.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';
import 'custom_carousel.dart';

class CarouselBanner extends StatelessWidget {
  const CarouselBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context, listen: false);

    return ValueListenableBuilder<int>(
      valueListenable: vm.currentIndexNotifier,
      builder: (context, value, child) {
        final BannerModel? banner = vm.currentBanner;
        if (banner == null) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(AppSpacing.space12),
            decoration: BoxDecoration(
              color: AppColors.stock,
              borderRadius: BorderRadius.circular(AppSize.size8.r),
            ),
            child: Text(
              context.appLocaleLanguage.noBanner,
              style: AppTextStyles.content2.copyWith(color: AppColors.grey),
            ),
          );
        }

        return FutureBuilder<TranslationModel?>(
          future: vm.getCurrentTranslation(banner),
          builder: (context, snapshot) {
            final translation = snapshot.data;
            final headline = translation?.headline ?? banner.headline ?? '';

            return GestureDetector(
              onTap: () {
                final annVm = GetIt.I<AnnouncementsViewModel>();
                context.pushNamed(
                  RouterName.articleDetail,
                  extra: AnnouncementDetailArgs(
                    item: banner,
                    tabTitle: annVm.currentTab['label'] as String,
                    subTabTitle: annVm.currentSubTabTitle ?? '',
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.space12.w,
                  vertical: AppSpacing.space10.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.stock,
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.content5.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const Spacer(),
                    const CustomCarouselBanner(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
