import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_string_uri.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/utils/get_data_record.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:alpha/presentation/pages/assets/record/bottom_sheet_content/bottom_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordItem extends StatelessWidget {
  final RecordData record;
  final RecordType type;

  const RecordItem({super.key, required this.record, required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBottomSheetWidget.show(
          context: context,
          child: BottomSheetRecordContent(record: record, type: type),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.size10.h,
          horizontal: AppSize.size15.w,
        ),
        decoration: BoxDecoration(
          color: AppColors.transparent,
          border: Border.all(
            color: AppColors.borderCard,
            width: AppSize.size1.r,
          ),
          borderRadius: BorderRadius.circular(AppSize.size8.r),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                spacing: AppSpacing.space10.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        record.iconUrl ?? AppStringUri.alphaIconUrl,
                        width: AppSize.size30.r,
                        height: AppSize.size30.r,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.network(
                            AppStringUri.alphaIconUrl,
                            width: AppSize.size30.r,
                            height: AppSize.size30.r,
                          );
                        },
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
                  Text(
                    FormatterUtils.isoToFormattedDateTime(
                      RecordHelper.getDateTime(record, type).toString(),
                    ),
                    style: AppTextStyles.content2.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                spacing: AppSpacing.space10.h,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space7.w,
                      vertical: AppSpacing.space2.h,
                    ),
                    decoration: BoxDecoration(
                      color: RecordHelper.getStatus(
                        record,
                        type,
                        context,
                      ).getStatusBgColor(context),
                      borderRadius: BorderRadius.circular(AppSize.size4.r),
                    ),
                    child: Text(
                      RecordHelper.getStatus(record, type, context),
                      style: AppTextStyles.body.copyWith(
                        color: RecordHelper.getStatus(
                          record,
                          type,
                          context,
                        ).getStatusColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${RecordHelper.getAmount(record, type).toString()} ${RecordHelper.getCurrency(record, type).toUpperCase()}",
                      style: AppTextStyles.content2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: AppSize.size19.h),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: AppSize.size20.r,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
