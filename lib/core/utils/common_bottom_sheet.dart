import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:flutter/material.dart';

class CommonBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double heightFactor = 0.6,
    Color? backgroundColor,
    double borderRadius = AppSize.size6,
    Duration duration = const Duration(milliseconds: 300),
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierLabel: "BottomSheet",
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      transitionDuration: duration,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: backgroundColor ?? AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * heightFactor,
              width: double.infinity,
              child: child,
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }
}
