import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/data/models/my_api_key/api_key_model.dart';
import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ApiKeyStatusSwitch extends StatelessWidget {
  final ApiKeyModel apiKey;
  final void Function(String newValue)? onToggle;

  const ApiKeyStatusSwitch({super.key, required this.apiKey, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Selector<ProfileViewModel, String>(
      selector: (_, vm) {
        final found = vm.apiKeys.firstWhere(
          (key) => key.kid == apiKey.kid,
          orElse: () => apiKey,
        );
        return found.state;
      },
      shouldRebuild: (prev, next) => prev != next,
      builder: (context, state, child) {
        final isActive = state.toLowerCase() == AppLocalKey.active;
        return Transform.scale(
          scale: 0.6,
          child: SizedBox(
            width: AppSize.size34.w,
            height: AppSize.size16.h,
            child: Switch(
              value: isActive,
              onChanged: (val) {
                final newState = val
                    ? AppLocalKey.active
                    : AppLocalKey.disabled;
                if (onToggle != null) {
                  onToggle!(newState);
                }
              },
              activeColor: AppColors.lightGray,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: AppColors.lightGray,
              inactiveTrackColor: AppColors.neutralGray,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        );
      },
    );
  }
}
