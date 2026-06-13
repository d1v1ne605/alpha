import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_size.dart';

class HandleBar extends StatelessWidget {
  const HandleBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.size68.w,
      height: AppSize.size2.h,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
      ),
    );
  }
}
