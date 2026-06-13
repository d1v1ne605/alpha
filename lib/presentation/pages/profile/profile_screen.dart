import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/base/base_view.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../injection/injector.dart';
import '../../view_models/profile/profile_view_model.dart';
import 'appbar_screen.dart';
import 'body_profile_screen.dart';
import 'header_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      onModelReady: (vm) async {
        vm.fetchAccountLogs();
      },
      autoDispose: false,
      padding: true,
      viewModelBuilder: () => getIt<ProfileViewModel>(),
      builder: (BuildContext context, ProfileViewModel vm, Widget? child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: AppSize.size20.w, right: AppSize.size20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBarScreen(),
                HeaderProfileScreen(),
                SizedBox(height: AppSize.size15.h),
                BodyProfileScreen(),
              ],
            ),
          ),
        );
      },
    );
  }
}
