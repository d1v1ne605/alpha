import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/data/models/stake/stake_record_model.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/pages/stakes/stake_record/stake_record_item.dart';
import 'package:alpha/presentation/view_models/stake/stake_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class StakeRecordList extends StatefulWidget {
  const StakeRecordList({super.key});

  @override
  State<StakeRecordList> createState() => _StakeRecordListState();
}

class _StakeRecordListState extends State<StakeRecordList> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<StakeViewModel>(context, listen: false);
      vm.getStakeRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
          child: Selector<StakeViewModel, List<StakeRecordModel>>(
            selector: (_, vm) => vm.stakeRecords,
            builder: (context, stakeRecords, child) => Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stakeRecords.length,
                  itemBuilder: (context, index) {
                    final record = stakeRecords[index];
                    return GestureDetector(
                      onTap: () =>
                          _showDetailRecordBottomSheet(context, record),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.size10.h,
                          horizontal: AppSize.size14.w,
                        ),
                        margin: EdgeInsets.only(bottom: AppSize.size14.h),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(AppSize.size4.r),
                          border: Border.all(
                            color: AppColors.borderCard,
                            width: 1,
                          ),
                        ),
                        child: StakeRecordItem(record: record),
                      ),
                    );
                  },
                ),
                SizedBox(height: AppSize.size20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    String? value,
    Widget? customValue,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.size8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.content2.copyWith(
              fontSize: AppSize.size14.sp,
              color: AppColors.textTertiary,
            ),
          ),
          customValue ??
              Text(
                value ?? "",
                style: AppTextStyles.content3.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
        ],
      ),
    );
  }

  void _showDetailRecordBottomSheet(
    BuildContext context,
    StakeRecordModel record,
  ) {
    double amount = double.tryParse(record.amount) ?? 0.0;
    double aprValue = double.tryParse(record.aprBase) ?? 0.0;
    double.tryParse(record.aprBase.replaceAll('%', '')) ?? 0.0;
    AppBottomSheetWidget.show(
      context: context,
      child: Column(
        children: [
          SizedBox(height: AppSpacing.space10.h),
          HandleBar(),
          SizedBox(height: AppSpacing.space18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                record.imgUrl ?? '',
                width: AppSize.size32.w,
                height: AppSize.size32.h,
              ),
              SizedBox(width: AppSize.size10.w),
              Text(
                record.currencyId.toUpperCase(),
                style: AppTextStyles.title2.copyWith(
                  fontSize: AppSize.size18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.space20.w,
                right: AppSpacing.space20.w,
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    label: context.appLocaleLanguage.status,
                    customValue: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.size10.w,
                        vertical: AppSize.size2.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            record.status.toLowerCase() == AppStorageKey.pending
                            ? AppColors.backgroundMain
                            : AppColors.green_36,
                        borderRadius: BorderRadius.circular(AppSize.size4.r),
                      ),
                      child: Text(
                        record.status,
                        style: AppTextStyles.content2.copyWith(
                          fontWeight: FontWeight.w500,
                          color:
                              record.status.toLowerCase() ==
                                  AppStorageKey.pending
                              ? AppColors.textSecondary
                              : AppColors.green,
                        ),
                      ),
                    ),
                  ),
                  _buildDetailRow(
                    label: context.appLocaleLanguage.apr,
                    customValue: Text(
                      '${aprValue.truncateToDecimalPlaces(aprValue.currentFractionalDigits).toString()}%',
                      style: AppTextStyles.content3.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.green,
                      ),
                    ),
                  ),
                  _buildDetailRow(
                    label: context.appLocaleLanguage.amount,
                    value: amount
                        .truncateToDecimalPlaces(amount.currentFractionalDigits)
                        .toString(),
                  ),
                  _buildDetailRow(
                    label: context.appLocaleLanguage.lockPeriod,
                    value:
                        '${record.lockDays.toString()} ${context.appLocaleLanguage.days}',
                  ),
                  _buildDetailRow(
                    label: context.appLocaleLanguage.timeRemaining,
                    value: record.timeRemaining,
                  ),
                  _buildDetailRow(
                    label: context.appLocaleLanguage.startedAt,
                    value: record.startedAt,
                  ),
                  _buildDetailRow(
                    label: context.appLocaleLanguage.unlockAt,
                    value: record.unlockAt,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      maxChildSize: AppSize.size0_6,
      minChildSize: AppSize.size0_6,
    );
  }
}
