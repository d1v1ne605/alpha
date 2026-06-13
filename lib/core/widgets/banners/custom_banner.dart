import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../presentation/view_models/home/home_view_model.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_spacing.dart';
import 'carousel_banner.dart';
import 'custom_card.dart';

class CustomBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    double heightBanner = deviceHeight * .2283;
    return Consumer<HomeViewModel>(
      builder: (context, vm, child) {
        if (vm.isBusy) {
          return SizedBox(
            height: heightBanner,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (vm.errorMessage != null) {
          return SizedBox(
            height: heightBanner,
            child: Center(
              child: Text(
                vm.errorMessage ?? context.appLocaleLanguage.errorMessage,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          );
        }
        if (vm.banners.isEmpty) {
          return SizedBox(
            height: heightBanner,
            child: Center(child: Text(context.appLocaleLanguage.noBanner)),
          );
        }
        return Container(
          height: heightBanner,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: CarouselBanner()),
              SizedBox(width: AppSpacing.space16.w),
              Expanded(child: FeatureCardView()),
            ],
          ),
        );
      },
    );
  }
}
