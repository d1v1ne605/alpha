import 'package:alpha/core/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

class StripedLinearProgressIndicator extends StatelessWidget {
  final double value;
  final double height;
  final Color backgroundColor;
  final Color stripeColor;
  final Color stripeColorSecondary;

  StripedLinearProgressIndicator({
    Key? key,
    required this.value,
    this.height = AppSize.size10,
    this.backgroundColor = Colors.grey,
    this.stripeColor = AppColors.primaryButton,
    this.stripeColorSecondary = AppColors.indicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.size2.r),
        child: Stack(
          children: [
            Container(color: backgroundColor),
            FractionallySizedBox(
              widthFactor: value,
              child: CustomPaint(
                painter: _StripePainter(
                  stripeColor: stripeColor,
                  stripeColorSecondary: stripeColorSecondary,
                ),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  final Color stripeColor;
  final Color stripeColorSecondary;

  _StripePainter({
    required this.stripeColor,
    required this.stripeColorSecondary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          stripeColor,
          stripeColor,
          stripeColorSecondary,
          stripeColorSecondary,
        ],
        stops: [0.0, 0.5, 0.5, 1.0],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        tileMode: TileMode.repeated,
      ).createShader(Rect.fromLTWH(-5, -5, 10, 10));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
