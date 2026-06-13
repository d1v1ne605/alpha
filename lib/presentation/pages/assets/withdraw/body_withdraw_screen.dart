import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/assets/withdraw/withdraw_2FA_screen.dart';
import 'package:alpha/presentation/pages/assets/withdraw/withdraw_detail_screen.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class BodyWithdrawScreen extends StatefulWidget {
  const BodyWithdrawScreen({super.key});

  @override
  State<BodyWithdrawScreen> createState() => _BodyWithdrawScreenState();
}

class _BodyWithdrawScreenState extends State<BodyWithdrawScreen> {
  Widget _getSelectedScreen(
    bool? selectedNetwork,
    bool is2FAEnabled,
    WithdrawViewModel vm,
  ) {
    if (selectedNetwork == null) return Container();
    if (vm.networkSelected != null &&
        vm.networkSelected!.withdrawal_enabled == false) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.size20.w,
          vertical: AppSize.size60.h,
        ),
        child: Text(
          context.appLocaleLanguage.withdrawalsWillBeAvailableSoon,
          style: AppTextStyles.content4.copyWith(color: AppColors.primary),
        ),
      );
    }
    return is2FAEnabled ? WithdrawDetailScreen() : Withdraw2FAScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      child: Selector<WithdrawViewModel, bool>(
        selector: (context, vm) => vm.is2FAEnabled,
        builder: (context, is2FAEnabled, child) {
          return Column(
            children: [
              is2FAEnabled
                  ? SizedBox.shrink()
                  : SizedBox(height: AppSize.size80.h),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSize.size20.w),
                child: Text(
                  context.appLocaleLanguage.withdrawDetail,
                  style: AppTextStyles.content3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Expanded(
                child:
                    Selector<
                      WithdrawViewModel,
                      ({
                        bool? isSelectedNetwork,
                        bool is2FAEnabled,
                        CurrencyModel? networkSelected,
                      })
                    >(
                      selector: (context, vm) => (
                        isSelectedNetwork: vm.isSelectedNetwork,
                        is2FAEnabled: vm.is2FAEnabled,
                        networkSelected: vm.networkSelected,
                      ),
                      builder: (context, state, child) {
                        final vm = context.read<WithdrawViewModel>();
                        return _getSelectedScreen(
                          state.isSelectedNetwork,
                          state.is2FAEnabled,
                          vm,
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}
