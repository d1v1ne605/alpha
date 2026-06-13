import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/presentation/pages/assets/record/share/filter_date_sheet.dart';
import 'package:alpha/presentation/view_models/asset/record/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RecordHeader extends StatelessWidget {
  final RecordViewModel vm;

  const RecordHeader({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      textTitle: context.appLocaleLanguage.walletRecord,
      actionWidget: GestureDetector(
        onTap: () => AppBottomSheetWidget.show(
          context: context,
          child: ChangeNotifierProvider.value(
            value: vm,
            child: FilterDateSheet(),
          ),
          maxChildSize: AppSize.size0_8,
          minChildSize: AppSize.size0_5,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space14.w),
          child: Icon(
            Icons.filter_alt_outlined,
            color: AppColors.iconPrimary,
            size: AppSize.size24.r,
          ),
        ),
      ),
    );
  }
}
