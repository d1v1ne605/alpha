import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/utils/get_data_record.dart';
import 'package:alpha/data/models/asset/Record/record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ValuesColumn extends StatelessWidget {
  final RecordData record;
  final RecordType type;

  const ValuesColumn({super.key, required this.record, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.space15.h,
      children: [
        if (type == RecordType.withdraw)
          Text(
            "${RecordHelper.getFee(record, type)} ${RecordHelper.getFeeCurrency(record, type).toUpperCase()}",
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
        Text(
          "${RecordHelper.getAmount(record, type)} ${RecordHelper.getCurrency(record, type).toUpperCase()}",
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
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
        if (type == RecordType.withdraw)
          Text(
            RecordHelper.getTid(record, type),
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
        Row(
          children: [
            Expanded(
              child: Text(
                RecordHelper.getTxId(record, type),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () => Clipboard.setData(
                ClipboardData(text: RecordHelper.getTxId(record, type)),
              ),
              child: SvgPicture.asset(
                AppSvg.copy,
                width: AppSize.size16.w,
                height: AppSize.size16.h,
                color: AppColors.iconUnselected,
              ),
            ),
          ],
        ),
        if (type == RecordType.withdraw)
          Row(
            children: [
              Expanded(
                child: Text(
                  RecordHelper.getAddress(record, type),
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => Clipboard.setData(
                  ClipboardData(text: RecordHelper.getAddress(record, type)),
                ),
                child: SvgPicture.asset(
                  AppSvg.copy,
                  width: AppSize.size16.w,
                  height: AppSize.size16.h,
                  color: AppColors.iconUnselected,
                ),
              ),
            ],
          ),
        Text(
          FormatterUtils.isoToFormattedDateTime(
            RecordHelper.getDateTime(record, type).toString(),
          ),
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
