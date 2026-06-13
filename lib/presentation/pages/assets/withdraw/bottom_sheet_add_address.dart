import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/validate.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/presentation/pages/assets/withdraw/address_selection/build_text_field.dart';
import 'package:alpha/presentation/pages/assets/withdraw/address_selection/custom_bottom_sheet.dart';
import 'package:alpha/presentation/pages/assets/withdraw/bottom_sheet_verify_address.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void showBottomSheetAddAddress({
  required BuildContext context,
  required bool isLoadingBeneficiaries,
}) async {
  final WithdrawViewModel vm = context.read<WithdrawViewModel>();
  await AppBottomSheetWidget.show(
    context: context,
    minChildSize: AppSize.size0_7,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    child: AnimatedBuilder(
      animation: vm,
      builder: (bottomSheetContext, child) {
        return PopScope(
          canPop: !isLoadingBeneficiaries,
          child: Stack(
            children: [
              Form(
                key: vm.addNewWithdrawAddressFormKey,
                child: CustomBottomSheet(
                  title: context.appLocaleLanguage.addNewAddress,
                  fields: [
                    BuildTextField(
                      maxLength: AppStorageKey.maxLengthNameAddressWithdraw,
                      hint: context.appLocaleLanguage.nameHeader,
                      controller: vm.nameAddressController,
                      validator: (value) =>
                          WithdrawValidate.isValidNameAddress(value, context),
                    ),
                    BuildTextField(
                      hint: context.appLocaleLanguage.withdrawTo,
                      controller: vm.addressController,
                      validator: (value) =>
                          WithdrawValidate.isValidBlockchainAddress(
                            value,
                            vm.coinSelected?.id,
                            context,
                          ),
                    ),
                  ],
                  actions: [
                    AppButton(
                      text: context.appLocaleLanguage.confirm,
                      fontWeight: FontWeight.w700,
                      onPressed: () async {
                        final isValid =
                            vm.addNewWithdrawAddressFormKey.currentState
                                ?.validate() ??
                            false;
                        if (isValid) {
                          _handleAddBeneficiary(
                            context,
                            bottomSheetContext,
                            vm,
                          );
                        }
                      },
                      borderRadius: AppSize.size4.r,
                      size: AppButtonSizeEnum.medium,
                    ),
                  ],
                ),
              ),

              if (vm.isLoadingBeneficiaries) _buildLoadingBeneficiaries(),
            ],
          ),
        );
      },
    ),
  );
}

Positioned _buildLoadingBeneficiaries() {
  return Positioned.fill(
    child: Container(
      color: Colors.black.withOpacity(0.4),
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: AppSize.size20.h),
          child: const CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    ),
  );
}

void _handleAddBeneficiary(
  BuildContext localContext,
  BuildContext bottomSheetContext,
  WithdrawViewModel vm,
) async {
  final BeneficiariesModel? beneficiary = await vm.addBeneficiary();
  if (vm.errorMessage != null && bottomSheetContext.mounted) {
    bottomSheetContext.showErrorDialog(
      vm.errorMessage!,
      onClosed: () => vm.clearError(),
    );
    return;
  }

  if (!localContext.mounted || beneficiary == null) {
    return;
  }
  Navigator.of(localContext).pop();
  await showVerifyAddressBottomSheet(
    context: localContext,
    beneficiaryId: beneficiary.id,
    vm: vm,
  );
}
