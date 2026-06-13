import 'package:alpha/presentation/pages/announcements/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../view_models/profile/profile_view_model.dart';
import 'account_activity_item.dart';

class BodyAccountSecurityScreen extends StatelessWidget {
  const BodyAccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (BuildContext context, ProfileViewModel vm, Widget? child) {
        if (vm.isBusy) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (vm.accountLogs.isEmpty) {
          return Center(child: NoDataWidget());
        }
        final currentDevice = vm.currentDevice;
        final historyDevices = vm.historyDevices;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentDevice != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space15.w,
                          vertical: AppSpacing.space11.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSize.size8.r),
                          border: Border.all(
                            color: AppColors.stock,
                            width: AppSize.size1.w,
                          ),
                        ),
                        child: AccountActivityItem(
                          deviceName: currentDevice.userAgent,
                          dateTime: currentDevice.createdAt.toString(),
                          ipAddress: currentDevice.userIp,
                          status: currentDevice.result,
                        ),
                      ),

                    SizedBox(height: AppSpacing.space14.h),
                    if (historyDevices.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSize.size8.r),
                          border: Border.all(
                            color: AppColors.stock,
                            width: AppSize.size1.w,
                          ),
                        ),
                        child: Column(
                          children: List.generate(historyDevices.length, (
                            index,
                          ) {
                            final item = historyDevices[index];
                            return Column(
                              children: [
                                if (index != 0)
                                  Divider(
                                    color: AppColors.stock,
                                    height: AppSize.size0_5.h,
                                  ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.space15.w,
                                    vertical: AppSpacing.space11.h,
                                  ),
                                  child: AccountActivityItem(
                                    deviceName: item.userAgent,
                                    dateTime: item.createdAt.toString(),
                                    ipAddress: item.userIp,
                                    status: item.result,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
