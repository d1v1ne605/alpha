import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_string_uri.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/get_data_record.dart';
import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'labels_column.dart';
import 'values_column.dart';

class BottomSheetRecordContent extends StatelessWidget {
  final RecordData record;
  final RecordType type;

  const BottomSheetRecordContent({
    super.key,
    required this.record,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.space20).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: AppSize.size68.w,
              height: AppSize.size2.h,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(AppSpacing.space2.r),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.space20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                record.withdrawCurrency?.iconUrl ?? AppStringUri.alphaIconUrl,
                height: AppSize.size30.r,
              ),
              SizedBox(width: AppSize.size10.w),
              Text(
                RecordHelper.getCurrency(record, type).toUpperCase(),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: LabelsColumn(type: type)),
              Expanded(
                child: ValuesColumn(record: record, type: type),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
