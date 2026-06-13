import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListSectionGeneric<T> extends StatelessWidget {
  final String title;
  final String searchHint;
  final bool isLoading;
  final List<T> items;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final VoidCallback? onItemTap;

  const ListSectionGeneric({
    Key? key,
    required this.title,
    required this.searchHint,
    required this.isLoading,
    required this.items,
    required this.searchController,
    required this.onSearchChanged,
    required this.itemBuilder,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.title2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSpacing.space15.h),
        AppTextField(
          hintText: searchHint,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.size14.r),
            child: Icon(Icons.search, color: AppColors.iconPrimary),
          ),
          fillColor: AppColors.backgroundSearch,
          controller: searchController,
          borderColor: AppColors.transparent,
          onChanged: (value) => onSearchChanged(value.trim().toLowerCase()),
        ),
        SizedBox(height: AppSpacing.space16.h),
        isLoading
            ? Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            : Expanded(
                child: items.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: AppSpacing.space15.h),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return itemBuilder(context, items[index], index);
                        },
                      )
                    : CustomNoData(),
              ),
      ],
    );
  }
}
