import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double>? onChanged;
  final int divisions;

  const CustomSlider({
    super.key,
    this.initialValue = 0.0,
    this.onChanged,
    this.divisions = 4,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue == 0) {
      setState(() {
        _sliderValue = widget.initialValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: _buildSlider());
  }

  Widget _buildSlider() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.divider,
        trackHeight: AppSize.size3.h.w,
        thumbShape: CustomSvgThumbShape(),
        overlayColor: AppColors.primary.withOpacity(AppSize.size0_2),
        overlayShape: RoundSliderOverlayShape(overlayRadius: AppSize.size10.r),
        trackShape: _CustomTrackShape(),
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        showValueIndicator: ShowValueIndicator.always,
        tickMarkShape: CustomSvgTickMarkShape(),
        activeTickMarkColor: AppColors.primary,
        inactiveTickMarkColor: AppColors.primary,
      ),
      child: Slider(
        value: _sliderValue,
        label: '${(_sliderValue * 100).toInt()}%',
        min: 0.0,
        max: 1.0,
        divisions: 4,
        onChanged: _handleSliderChange,
      ),
    );
  }

  void _handleSliderChange(double value) {
    setState(() {
      _sliderValue = value;
    });
    widget.onChanged?.call(value);
  }
}

// Custom track shape to make the slider full width (remove padding)
class _CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight!;
    final dotRadius = AppSize.size9.w / AppSize.size2;
    final trackLeft = offset.dx + dotRadius;
    final trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / AppSize.size2;
    final trackWidth = parentBox.size.width - dotRadius * AppSize.size2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class CustomSvgThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(AppSize.size11.w, AppSize.size11.h);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final customPainter = SvgThumbPainter();
    if (value == 1) {
      customPainter.paintCircle(canvas, center);
    } else {
      customPainter.paintThumbSlider(
        canvas,
        Size(AppSize.size11.w, AppSize.size11.h),
        center,
      );
    }
  }
}

class CustomSvgTickMarkShape extends SliderTickMarkShape {
  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool? isEnabled,
  }) {
    return Size(AppSize.size9.w, AppSize.size9.h);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> enableAnimation,
    required bool isEnabled,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required Offset thumbCenter,
  }) {
    final Canvas canvas = context.canvas;

    // Check if the thumb has passed this tick mark
    final bool isThumbPassed = _isThumbPassedTickMark(
      center: center,
      thumbCenter: thumbCenter,
      textDirection: textDirection,
    );

    if (isThumbPassed) {
      SvgThumbPainter().paintCircle(canvas, center);
    } else {
      SvgThumbPainter().paintThumbSlider(
        canvas,
        Size(AppSize.size9.w, AppSize.size9.h),
        center,
      );
    }
  }

  bool _isThumbPassedTickMark({
    required Offset center,
    required Offset thumbCenter,
    required TextDirection textDirection,
  }) {
    return textDirection == TextDirection.ltr
        ? thumbCenter.dx >= center.dx
        : thumbCenter.dx <= center.dx;
  }
}

class SvgThumbPainter {
  void paintThumbSlider(Canvas canvas, Size size, Offset center) {
    final double strokeWidth = AppSize.size1_5.w.h;
    final double radius = AppSize.size4_5.w - strokeWidth / 2.w;

    final Offset circleCenter = center;

    final Paint fillPaint = Paint()
      ..color = const Color(0xFF121212)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(circleCenter, radius, fillPaint);

    final Paint strokePaint = Paint()
      ..color = const Color(0xFFF7A600)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(circleCenter, radius, strokePaint);
  }

  void paintCircle(Canvas canvas, Offset center) {
    final double radius = AppSize.size5_5.w;
    final Paint paint = Paint()
      ..color = const Color(0xFFF7A600)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }
}
