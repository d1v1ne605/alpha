import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_svg.dart';
import '../account_security/build_info_row.dart';

class BodyInfomationScreen extends StatefulWidget {
  final String? imageUrl;
  final Widget? avatarWidget;

  const BodyInfomationScreen({super.key, this.imageUrl, this.avatarWidget});

  @override
  State<BodyInfomationScreen> createState() => _BodyInfomationScreenState();
}

class _BodyInfomationScreenState extends State<BodyInfomationScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        final device = vm.currentDevice;
        final user = vm.currentUser;
        if (user == null || device == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final email = user.email ?? '';
        final uid = user.uid ?? '';
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            border: Border.all(
              color: AppColors.stock,
              width: AppSize.size0_5.w,
            ),
          ),
          child: Column(
            children: [
              BuildInfoRow(
                label: context.appLocaleLanguage.email,
                value: email,
              ),
              Divider(color: AppColors.stock, height: AppSize.size0_5.h),
              BuildInfoRow(
                label: context.appLocaleLanguage.uid,
                value: uid,
                actionIcon: SvgPicture.asset(AppSvg.copy),
                onIconTap: () {
                  Clipboard.setData(ClipboardData(text: uid));
                },
              ),
              Divider(color: AppColors.stock, height: AppSize.size0_5.h),
              BuildInfoRow(
                label: context.appLocaleLanguage.lastLoginTime,
                value: device.userAgent ?? '',
              ),
              Divider(color: AppColors.stock, height: AppSize.size0_5.h),

              BuildInfoRow(
                label: context.appLocaleLanguage.lastLogin,
                value: device != null
                    ? "${device.createdAt.toString()}\n${device.userIp}"
                    : '',
                multiLine: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
