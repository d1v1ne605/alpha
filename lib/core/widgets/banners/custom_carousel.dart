import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../presentation/view_models/home/home_view_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../constants/app_spacing.dart';

class CustomCarouselBanner extends StatelessWidget {
  const CustomCarouselBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
        if (homeViewModel.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return ValueListenableBuilder(
          valueListenable: homeViewModel.currentIndexNotifier,
          builder: (context, currentIndex, child) {
            return Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: AppSize.size80.h,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      homeViewModel.updateCurrentIndex(index);
                    },
                  ),
                  items: homeViewModel.banners.map((banner) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            if (banner.thumbnailUrl != null) {
                              context.push(banner.thumbnailUrl!);
                            }
                          },
                          child: ClipRRect(
                            child: Image.network(
                              banner.photoUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: AppSpacing.space12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: homeViewModel.banners.asMap().entries.map((entry) {
                    final bool isActive = currentIndex == entry.key;
                    final Color indicatorColor = isActive ? AppColors.primary : AppColors.grey;
                    return Container(
                      width: AppSize.size15.w,
                      height: AppSize.size3.h,
                      margin: EdgeInsets.symmetric(horizontal: AppSpacing.space3.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.size4.r),
                        color: indicatorColor,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}