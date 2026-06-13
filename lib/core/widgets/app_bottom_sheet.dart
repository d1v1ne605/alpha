import 'package:alpha/core/constants/app_size.dart';
import 'package:flutter/material.dart';

class AppBottomSheetWidget {
  final Widget child;
  final double? heightFactor;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final double minChildSize;
  final double maxChildSize;

  const AppBottomSheetWidget({
    required this.child,
    this.heightFactor,
    this.isScrollControlled = true,
    this.backgroundColor,
    this.shape,
    this.minChildSize = AppSize.size0_5,
    this.maxChildSize = AppSize.size0_8,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double minChildSize = AppSize.size0_5,
    double maxChildSize = AppSize.size0_8,
    bool isScrollControlled = true,
    Color? backgroundColor,
    ShapeBorder? shape,
    bool isSingleChildScrollView = false,
  }) async {
    FocusScope.of(context).unfocus();
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final theme = Theme.of(context);

    final result = await showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSize.size16),
            ),
          ),
      constraints: BoxConstraints(
        minWidth: mediaQuery.size.width,
        maxWidth: mediaQuery.size.width,
        minHeight: isLandscape
            ? mediaQuery.size.height
            : mediaQuery.size.height * minChildSize,
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: minChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: ShapeDecoration(
              color: backgroundColor ?? theme.scaffoldBackgroundColor,
              shape:
                  shape ??
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppSize.size16),
                    ),
                  ),
            ),
            child: isSingleChildScrollView
                ? SingleChildScrollView(
                    controller: scrollController,
                    child: child,
                  )
                : child,
          ),
        ),
      ),
    );

    return result;
  }
}
