import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_timers.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomToast {
  static void show(
    BuildContext context, {
    required Widget content,
    Color backgroundColor = Colors.transparent,
    FlushbarPosition position = FlushbarPosition.BOTTOM,
    Duration duration = AppTimers.second2,
    double borderRadius = AppSize.size4,
    EdgeInsets margin = const EdgeInsets.all(AppSize.size16),
    double? maxWidth,
  }) {
    Flushbar(
      messageText: content,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius.r),
      margin: margin.r,
      duration: duration,
      flushbarPosition: position,
      maxWidth: maxWidth,
    ).show(context);
  }
}
