import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/referall_model/rewards_model.dart';
import 'package:alpha/presentation/pages/announcements/widgets/no_data_widget.dart';
import 'package:alpha/presentation/pages/invite_friends/rewards/build_trophy.dart';
import 'package:alpha/presentation/pages/invite_friends/share_widget/show_data_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabRewards extends StatelessWidget {
  const TabRewards({Key? key, required this.dataList}) : super(key: key);
  final List<RewardsModel> dataList;

  @override
  Widget build(BuildContext context) {
    return dataList.isEmpty
        ? Center(child: NoDataWidget())
        : ListView.separated(
            padding: EdgeInsets.all(AppSpacing.space0),
            separatorBuilder: (context, index) =>
                SizedBox(height: AppSpacing.space15.h),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return ShowDataBox(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space16.w,
                        vertical: AppSpacing.space12.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: context.appLocaleLanguage.season,
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textTertiary,
                              ),
                              children: [
                                TextSpan(
                                  text: dataList[index].season,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.space7.w,
                              vertical: AppSpacing.space4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryButton,
                              borderRadius: BorderRadius.circular(
                                AppSize.size4.r,
                              ),
                            ),
                            child: Text(
                              dataList[index].status,
                              style: AppTextStyles.content1.copyWith(
                                color: AppColors.completed,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space16.w,
                      ),
                      child: Text(
                        '${dataList[index].reward_amount} ${dataList[index].currency_id}',
                        style: AppTextStyles.title2.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.space8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.space7.r,
                        horizontal: AppSpacing.space16.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        border: Border(
                          top: BorderSide(
                            color: AppColors.borderCard,
                            width: AppSize.size0_5.w,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${context.appLocaleLanguage.date}: ${dataList[index].date}',
                            style: AppTextStyles.content2.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          BuildTrophy(top: dataList[index].top),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
