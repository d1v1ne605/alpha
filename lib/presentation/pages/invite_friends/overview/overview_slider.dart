import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/presentation/view_models/invite_friend/invite_friend_view_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OverviewSlider extends StatefulWidget {
  const OverviewSlider({super.key});

  @override
  State<OverviewSlider> createState() => _OverviewSliderState();
}

class _OverviewSliderState extends State<OverviewSlider> {
  @override
  Widget build(BuildContext context) {
    return Consumer<InviteFriendsViewModel>(
      builder: (context, vm, child) {
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                initialPage: vm.currentIndicatorCarousel,
                viewportFraction: 1.0,
                height: AppSize.size105.h,
                onPageChanged: (index, reason) {
                  vm.currentIndicatorCarousel = index;
                },
              ),
              carouselController: vm.carouselController,
              items: vm.slideItemsOverview.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(AppSpacing.space15.h.w),
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space5.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDeep,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.space8.r,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            i.title,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: AppSize.size16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppSpacing.space8.h),
                          Text(
                            i.description,
                            style: TextStyle(
                              color: AppColors.textFourth,
                              fontSize: AppSize.size14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: AppSpacing.space10.h),
            // Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: vm.slideItemsOverview.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => vm.carouselController.animateToPage(entry.key),
                  child: Container(
                    width: AppSize.size8.w,
                    height: AppSize.size8.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space4.w,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: vm.currentIndicatorCarousel == entry.key
                          ? AppColors.primary
                          : AppColors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
