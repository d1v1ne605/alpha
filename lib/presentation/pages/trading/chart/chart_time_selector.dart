import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartTimeSelector extends StatefulWidget {
  final String selected;
  final Function(String) onChanged;

  const ChartTimeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<ChartTimeSelector> createState() => _ChartTimeSelectorState();
}

class _ChartTimeSelectorState extends State<ChartTimeSelector> {
  final List<String> quickFrames = [
    AppStorageKey.fifteenMinutes,
    AppStorageKey.oneHour,
    AppStorageKey.fourHours,
    AppStorageKey.oneDay,
  ];

  final List<String> allFrames = [
    AppStorageKey.oneMinute,
    AppStorageKey.threeMinutes,
    AppStorageKey.fiveMinutes,
    AppStorageKey.fifteenMinutes,
    AppStorageKey.thirtyMinutes,
    AppStorageKey.oneHour,
    AppStorageKey.twoHours,
    AppStorageKey.fourHours,
    AppStorageKey.sixHours,
    AppStorageKey.twelveHours,
    AppStorageKey.oneDay,
    AppStorageKey.threeDays,
    AppStorageKey.oneWeek,
    AppStorageKey.oneMonth,
  ];

  OverlayEntry? _overlayEntry;

  void _toggleMoreMenu(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _toggleMoreMenu(context),
        child: Stack(
          children: [
            Positioned(
              top: offset.dy,
              left: AppSize.size0,
              right: AppSize.size0,
              bottom: AppSize.size0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.transparent, AppColors.bgOverlay],
                    stops: [0.0, 0.25],
                  ),
                ),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
              width: renderBox.size.width,
              child: Material(
                color: AppColors.background,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                  ),
                  child: Wrap(
                    spacing: AppSize.size10.w,
                    runSpacing: AppSize.size7.h,
                    children: allFrames.map((frame) {
                      final isSelected = widget.selected == frame;
                      return GestureDetector(
                        onTap: () {
                          widget.onChanged(frame);
                          _toggleMoreMenu(context);
                        },
                        child: Container(
                          width: AppSize.size65.w,
                          height: AppSize.size20.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.disabledButton,
                            borderRadius: BorderRadius.circular(
                              AppSize.size4.r,
                            ),
                          ),
                          child: Text(
                            frame,
                            style: AppTextStyles.content1.copyWith(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          context.appLocaleLanguage.time,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: AppSize.size10.w),
        ...quickFrames.map((value) {
          final isSelected = widget.selected == value;
          return GestureDetector(
            onTap: () {
              widget.onChanged(value);
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: Container(
              width: AppSize.size45.w,
              height: AppSize.size20.h,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: AppSize.size5.w),
              decoration: BoxDecoration(
                color: AppColors.disabledButton,
                borderRadius: BorderRadius.circular(AppSize.size4.r),
              ),
              child: Text(
                value,
                style: AppTextStyles.content1.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.white,
                ),
              ),
            ),
          );
        }),
        SizedBox(width: AppSize.size5.w),
        GestureDetector(
          onTap: () {
            _toggleMoreMenu(context);
          },
          child: Row(
            children: [
              quickFrames.contains(widget.selected)
                  ? Text(
                      context.appLocaleLanguage.more,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      widget.selected,
                      style: AppTextStyles.content1.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.grey,
                size: AppSize.size20,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSize.size5),
        Text(
          context.appLocaleLanguage.depth,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
