import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/pages/assets/deposit/deposit_action/deposit_data_section.dart';
import 'package:alpha/presentation/pages/assets/deposit/deposit_action/deposit_qr_section.dart';
import 'package:alpha/presentation/pages/auth/share_widgets/auth_bottom_sheet.dart';
import 'package:alpha/presentation/view_models/deposit/deposit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/two_fa/enable_two_fa.dart';

class DepositAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<DepositViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<DepositViewModel, bool>(
          selector: (context, viewModel) => viewModel.is2FAEnabled,
          builder: (context, is2FAEnabled, child) {
            return DepositQrSection(
              data: vm.selectedBalance?.depositAddress?.address ?? '',
              isisEnable2FA: is2FAEnabled,
            );
          },
        ),
        SizedBox(height: AppSize.size15.h),
        Selector<DepositViewModel, bool>(
          selector: (context, viewModel) => viewModel.is2FAEnabled,
          builder: (context, is2FAEnabled, child) {
            return DepositDataSection(
              confirmation: vm.selectedChildCurrency!.min_confirmations,
              minimum: vm.selectedChildCurrency!.min_deposit_amount,
              minimumId: vm.selectedChildCurrency!.id,
              isShow: is2FAEnabled,
            );
          },
        ),

        SizedBox(height: AppSize.size15.h),
        Visibility(
          visible: !context.select((DepositViewModel vm) => vm.is2FAEnabled),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.appLocaleLanguage.depositRequire,
                style: AppTextStyles.content2.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: AppSize.size15.h),
              AppButton(
                text: context.appLocaleLanguage.enable2FA,
                fontWeight: FontWeight.w700,
                onPressed: () {
                  AuthBottomSheetWidget.show(
                    context: context,
                    minChildSize: 0.7,
                    child: EnableTwoFa(
                      vm: vm,
                      onSubmit: (code) async {
                        final result = await vm.toggleTwoFA(
                          twoFACode: code,
                          isEnable: true,
                        );
                        return result;
                      },
                    ),
                  );
                },
                size: AppButtonSizeEnum.medium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
