import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/profile/appbar_screen.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_size.dart';
import '../../../../injection/injector.dart';
import 'body_infomation_screen.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      autoDispose: false,
      viewModelBuilder: () => getIt<ProfileViewModel>(),
      builder: (BuildContext context, ProfileViewModel vm, Widget? child) {
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppSize.size20.w,
              right: AppSize.size20.w,
            ),
            child: Column(
              children: [
                AppBarScreen(
                  title: context.appLocaleLanguage.basicInformation,
                  showNotification: false,
                  showScan: false,
                ),
                SizedBox(height: AppSize.size30.h),
                BodyInfomationScreen(),
              ],
            ),
          ),
        );
      },
    );
  }
}
