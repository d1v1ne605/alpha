import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/referall_model/commission_model.dart';
import 'package:alpha/presentation/pages/announcements/widgets/no_data_widget.dart';
import 'package:alpha/presentation/pages/invite_friends/commission/commission_info.dart';
import 'package:alpha/presentation/pages/invite_friends/share_widget/show_data_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabCommission extends StatelessWidget {
  final List<CommissionModel> dataList;

  TabCommission({Key? key, required this.dataList}) : super(key: key);

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.space8.h,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dataList[index].referral_email,
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
                            dataList[index].status.toUpperCase(),
                            style: AppTextStyles.content1.copyWith(
                              fontWeight: FontWeight.w500,
                              color:
                                  dataList[index].status ==
                                      AppStorageKey.finished
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${context.appLocaleLanguage.date} ${dataList[index].date}',
                      style: AppTextStyles.title2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CommissionInfo(
                      usdPrice: dataList[index].usd_value,
                      coinPrice:
                          '${dataList[index].total} ${dataList[index].currency_id.toUpperCase()}',
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
