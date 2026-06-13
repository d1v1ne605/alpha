import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/referall_model/ranking_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../announcements/widgets/no_data_widget.dart';

class TabRanking extends StatelessWidget {
  TabRanking({Key? key, required this.rankingItems}) : super(key: key);
  final List<RankingModel> rankingItems;

  @override
  Widget build(BuildContext context) {
    if (rankingItems.isEmpty) {
      return SizedBox(
        height: AppSize.size210.h,
        child: Center(child: NoDataWidget()),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: rankingItems.length,
      itemBuilder: (context, index) {
        return _buildRankingItem(rankingItems[index], context);
      },
    );
  }

  Widget _buildRankingItem(RankingModel item, BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(
              bottom: AppSize.size20.h,
              top: AppSize.size12.w,
              left: AppSize.size15.w,
            ),
            padding: EdgeInsets.only(
              left: AppSize.size72.w,
              right: AppSize.size15.w,
              top: AppSize.size20.h,
              bottom: AppSize.size20.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSize.size8.w),
              border: Border.all(
                color: AppColors.stock,
                width: AppSize.size0_5.w,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.uid,
                        style: AppTextStyles.content3.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSize.size4.h),
                      Row(
                        children: [
                          SvgPicture.asset(AppSvg.patternUp),
                          SizedBox(width: AppSize.size4.w),
                          Text(
                            '${item.total_trade_amount}',
                            style: AppTextStyles.content3.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(AppSvg.gift),
                        SizedBox(width: AppSize.size4.w),
                        Text(
                          item.reward,
                          style: AppTextStyles.content3.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.size4.h),
                    Text(
                      '${context.appLocaleLanguage.date} ${item.distribute_date}',
                      style: AppTextStyles.content3.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(child: SvgPicture.asset(AppSvg.cup)),
          Positioned(
            left: AppSize.size38.w,
            top: AppSize.size30.w,
            child: Text(
              item.top.toString(),
              style: AppTextStyles.number1.copyWith(
                color: AppColors.textSecondary,
                shadows: [
                  Shadow(
                    offset: Offset(AppSize.size2.h, AppSize.size2.w),
                    blurRadius: AppSize.size4.r,
                    color: AppColors.stock,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
