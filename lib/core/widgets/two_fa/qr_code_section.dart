import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../constants/app_svg.dart';
import '../../constants/app_text_styles.dart';
import '../../mixins/two_fa_mixin/two_fa_mixin.dart';

class QRCodeSection extends StatefulWidget {
  final TwoFAMixin vm;

  const QRCodeSection({super.key, required this.vm});

  @override
  State<QRCodeSection> createState() => _QRCodeSectionState();
}

class _QRCodeSectionState extends State<QRCodeSection> {
  @override
  void initState() {
    super.initState();
    widget.vm.addListener(_onVmChanged);
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.vm.removeListener(_onVmChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barCode = widget.vm.barcode;
    final qrUrl = widget.vm.url;

    if (barCode.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        QrImageView(
          data: qrUrl,
          version: QrVersions.auto,
          size: AppSize.size95.w,
          backgroundColor: AppColors.white,
        ),
        SizedBox(height: AppSize.size15.h),
        Container(
          padding: EdgeInsets.only(left: AppSize.size18.w),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(AppSize.size4.r),
            border: Border.all(color: AppColors.stock, width: AppSize.size1.w),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  barCode,
                  style: AppTextStyles.content5.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: barCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied to clipboard'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: SvgPicture.asset(AppSvg.copy),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
