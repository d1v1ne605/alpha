import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/referall_model/referral_model.dart';
import 'package:alpha/presentation/pages/announcements/widgets/no_data_widget.dart';
import 'package:alpha/presentation/pages/invite_friends/referrals/info_column.dart';
import 'package:alpha/presentation/pages/invite_friends/share_widget/show_data_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabReferrals extends StatelessWidget {
  final List<ReferralModel> dataList;

  TabReferrals({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dataList.isEmpty
        ? Center(child: NoDataWidget())
        : ListView.separated(
            padding: EdgeInsets.all(AppSpacing.space0),
            itemCount: dataList.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: AppSpacing.space8.h),
            itemBuilder: (context, index) => ShowDataBox(
              content: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.space16.w,
                  vertical: AppSpacing.space15.h,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dataList[index].email,
                          style: AppTextStyles.title2.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.space14.w,
                            vertical: AppSpacing.space5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryButton,
                            borderRadius: BorderRadius.circular(
                              AppSize.size4.r,
                            ),
                          ),
                          child: Text(
                            context.appLocaleLanguage.active,
                            style: AppTextStyles.content1.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.space10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoColumn(
                          title: context.appLocaleLanguage.joined,
                          value: dataList[index].date,
                        ),
                        InfoColumn(
                          title: context.appLocaleLanguage.uid,
                          value: dataList[index].uid,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
