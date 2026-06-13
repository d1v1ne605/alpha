import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/presentation/pages/assets/record/share/filter_type_sheet.dart';
import 'package:alpha/presentation/view_models/asset/record/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RecordFilterType extends StatelessWidget {
  final RecordViewModel vm;

  const RecordFilterType({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => AppBottomSheetWidget.show(
            context: context,
            child: ChangeNotifierProvider.value(
              value: vm,
              child: FilterTypeSheet(),
            ),
            maxChildSize: AppSize.size0_8,
            minChildSize: AppSize.size0_5,
          ),
          child: Text(
            context.appLocaleLanguage.flowType,
            style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
          ),
        ),
        Icon(
          Icons.arrow_drop_down_outlined,
          color: AppColors.textTertiary,
          size: AppSize.size16.r,
        ),
      ],
    );
  }
}
