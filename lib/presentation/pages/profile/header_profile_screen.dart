import 'package:alpha/core/utils/validate.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_image.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_svg.dart';
import '../../../core/constants/app_text_styles.dart';

class HeaderProfileScreen extends StatefulWidget {
  const HeaderProfileScreen({super.key});

  @override
  State<HeaderProfileScreen> createState() => _HeaderProfileScreenState();
}

class _HeaderProfileScreenState extends State<HeaderProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        final user = vm.currentUser;
        final email = user?.email ?? '';
        final uid = user?.uid ?? '';
        final isVerified = user?.labels[0]['value'] ?? "";

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                context.push(RouterPath.accountSecurity);
              },
              child: Row(
                children: [
                  Container(
                    width: AppSize.size40.w,
                    height: AppSize.size40.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(AppImage.profile),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.size15.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FormatEmail.formatEmail(email),
                        style: AppTextStyles.content4.copyWith(
                          color: AppColors.tertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        uid,
                        style: AppTextStyles.content2.copyWith(
                          color: AppColors.subtitleText,
                        ),
                      ),
                    ],
                  ),
                  // Badge
                  Container(
                    margin: EdgeInsets.only(
                      left: AppSize.size13.w,
                      bottom: AppSize.size22.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space7.w,
                      vertical: AppSpacing.space2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.navBottom,
                      borderRadius: BorderRadius.circular(AppSize.size4.r),
                      border: Border.all(
                        color: AppColors.navBottom,
                        width: AppSize.size1.w,
                      ),
                    ),
                    child: Text(
                      isVerified,
                      style: AppTextStyles.content1.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.changeButton,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space10),
              child: SvgPicture.asset(
                AppSvg.next,
                width: AppSize.size9.w,
                height: AppSize.size18.h,
              ),
            ),
          ],
        );
      },
    );
  }
}
