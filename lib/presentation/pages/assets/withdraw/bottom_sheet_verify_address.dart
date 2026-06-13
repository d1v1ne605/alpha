import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/pages/assets/withdraw/address_selection/build_text_field.dart';
import 'package:alpha/presentation/pages/assets/withdraw/address_selection/custom_bottom_sheet.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showVerifyAddressBottomSheet({
  required BuildContext context,
  required int beneficiaryId,
  required WithdrawViewModel vm,
}) async {
  final parentContext = context;
  await AppBottomSheetWidget.show(
    context: parentContext,
    minChildSize: AppSize.size0_7,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    child: AnimatedBuilder(
      animation: vm,
      builder: (context, child) => PopScope(
        canPop: !vm.isLoadingBeneficiaries,
        child: Stack(
          children: [
            CustomBottomSheet(
              title: context.appLocaleLanguage.confirmNewAddress,
              description: context.appLocaleLanguage.descriptionAddress,
              fields: [
                BuildTextField(
                  hint: context.appLocaleLanguage.pinCode,
                  controller: vm.pinController,
                  keyboardType: TextInputType.number,
                ),
              ],
              actions: [
                AppButton(
                  text: context.appLocaleLanguage.btmSheetButton,
                  fontWeight: FontWeight.w700,
                  onPressed: () {},
                  borderRadius: AppSize.size4.r,
                  size: AppButtonSizeEnum.small,
                  backgroundColor: AppColors.background,
                  borderColor: AppColors.primary,
                ),
                AppButton(
                  text: context.appLocaleLanguage.confirm,
                  fontWeight: FontWeight.w700,
                  onPressed: () async {
                    await vm.activateBeneficiary(
                      beneficiaryId,
                      vm.pinController.text,
                    );
                    if (vm.errorMessage != null && context.mounted) {
                      context.showErrorDialog(
                        vm.errorMessage!,
                        onClosed: () => vm.clearError(),
                      );
                      return;
                    }
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  borderRadius: AppSize.size4.r,
                  size: AppButtonSizeEnum.small,
                ),
              ],
            ),
            if (vm.isLoadingBeneficiaries) ...[
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSize.size20.h),
                      child: const CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
