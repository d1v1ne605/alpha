import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryFilterBar extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final Function(String) onItemSelected;

  const CategoryFilterBar({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(
        top: AppSpacing.space10.h,
        bottom: AppSpacing.space10.h,
        left: AppSpacing.space20.w,
        right: AppSpacing.space20.w,
      ),
      child: Row(
        children: items.map((item) {
          return CategoryItem(
            key: ValueKey(item),
            item: item,
            isSelected: item == selectedItem,
            onTap: () => onItemSelected(item),
          );
        }).toList(),
      ),
    );
  }
}
