import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/presentation/pages/assets/withdraw/bottom_sheet_verify_address.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/enums.dart';

class AddressSelectorScreen extends StatefulWidget {
  final VoidCallback onAddAddress;

  const AddressSelectorScreen({Key? key, required this.onAddAddress})
    : super(key: key);

  @override
  State<AddressSelectorScreen> createState() => _AddressSelectorScreenState();
}

class _AddressSelectorScreenState extends State<AddressSelectorScreen> {
  String _truncateAddress(String address) {
    if (address.length <= 40) return address;
    return '${address.substring(0, 30)}...${address.substring(address.length - 4)}';
  }

  WithdrawViewModel? _withdrawViewModel;

  WithdrawViewModel get vm {
    return _withdrawViewModel ??= context.read<WithdrawViewModel>();
  }

  Widget _statusChip(String text, Color color, {VoidCallback? actionButton}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size8.w,
        vertical: AppSize.size4.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSize.size4.r),
      ),
      child: GestureDetector(
        onTap: actionButton,
        child: Text(
          text,
          style: AppTextStyles.content1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAddAddressButton() {
    return GestureDetector(
      onTap: widget.onAddAddress,
      child: InputDecorator(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.size4.r),
            borderSide: BorderSide(color: AppColors.stock),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSize.size15.w,
            vertical: AppSize.size8.h,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocaleLanguage.addAddress,
              style: AppTextStyles.content3.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w400,
              ),
            ),
            SvgPicture.asset(AppSvg.addAddress),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDropdown(
    BuildContext context,
    List<BeneficiariesModel> currentAddresses,
  ) {
    if (currentAddresses.isEmpty) {
      return _buildAddAddressButton();
    }

    return GestureDetector(
      onTap: () => _showAddressSelection(context),
      child: InputDecorator(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSize.size15.w,
            vertical: AppSize.size10.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.size4.r),
            borderSide: BorderSide(color: AppColors.stock),
          ),
        ),
        child: Selector<WithdrawViewModel, BeneficiariesModel?>(
          selector: (context, vm) => vm.beneficiarySelected,
          builder: (context, beneficiarySelected, child) {
            final selectBeneficiary =
                beneficiarySelected ?? vm.selectBeneficiary;
            return selectBeneficiary != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  context.appLocaleLanguage.nameHeader,
                                  style: AppTextStyles.content2.copyWith(
                                    color: AppColors.textTertiary,
                                    fontWeight: FontWeight.w400,
                                    height: AppSize.size1.h,
                                  ),
                                ),
                                SizedBox(width: AppSize.size4.w),
                                Expanded(
                                  child: Text(
                                    selectBeneficiary?.name ?? '',
                                    style: AppTextStyles.content2.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w400,
                                      height: AppSize.size1.h,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSize.size4.h),
                            Text(
                              _truncateAddress(
                                selectBeneficiary?.addressData.address ?? '',
                              ),
                              style: AppTextStyles.content3.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
                                height: AppSize.size1.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(AppSvg.arrowdown),
                    ],
                  )
                : SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showAddressSelection(BuildContext context) {
    final currentAddresses = vm.availableBeneficiaries;
    AppBottomSheetWidget.show(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      minChildSize: AppSize.size0_7,
      maxChildSize: AppSize.size0_7,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: vm,
          builder: (context, child) => Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSize.size8.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size7.w,
                    vertical: AppSize.size2.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: AppSize.size68.w,
                        height: AppSize.size2.h,
                        margin: EdgeInsets.only(top: AppSize.size11.h),
                        decoration: BoxDecoration(
                          color: AppColors.textTertiary,
                          borderRadius: BorderRadius.circular(AppSize.size2.r),
                        ),
                      ),
                      SizedBox(height: AppSize.size18.h),
                      Text(
                        context.appLocaleLanguage.addressList,
                        style: AppTextStyles.title2.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        context.appLocaleLanguage.selectAddress,
                        style: AppTextStyles.content2.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: AppSize.size30.h),

                      Expanded(
                        child: ListView.builder(
                          itemCount: currentAddresses.length,
                          itemBuilder: (context, index) {
                            final address = currentAddresses[index];
                            return Column(
                              children: [
                                _buildAddressItem(context, address),
                                if (index != currentAddresses.length)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: AppSize.size20.w,
                                      right: AppSize.size20.w,
                                      bottom: AppSize.size15.h,
                                      top: AppSize.size10.h,
                                    ),
                                    child: Divider(
                                      color: AppColors.textTertiary,
                                      thickness: 1,
                                      height: AppSize.size1.h,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppSize.size20.w,
                          right: AppSize.size20.w,
                          bottom: AppSize.size30.h,
                        ),
                        child: AppButton(
                          text: context.appLocaleLanguage.addAddress,
                          fontWeight: FontWeight.w700,
                          onPressed: widget.onAddAddress,
                          borderRadius: AppSize.size4.r,
                          size: AppButtonSizeEnum.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (vm.isLoadingDeleteBeneficiary) ...[
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
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

  Widget _buildAddressItem(
    BuildContext context,
    BeneficiariesModel beneficiary,
  ) {
    final isActive = beneficiary.state == AppStorageKey.keyActiveAddressWithdraw
        ? true
        : false;

    return GestureDetector(
      onTap: () async {
        if (isActive) {
          vm.beneficiarySelected = beneficiary;
          Navigator.pop(context);
        } else {
          await showVerifyAddressBottomSheet(
            context: context,
            beneficiaryId: beneficiary.id,
            vm: vm,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: AppSize.size15.w,
          right: AppSize.size15.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _statusChip(
                  isActive
                      ? context.appLocaleLanguage.verifiedAddress
                      : context.appLocaleLanguage.pendingAddress,
                  isActive ? AppColors.green_36 : AppColors.backgroundMain,
                ),
                const Spacer(),
                if (!isActive)
                  _statusChip(
                    context.appLocaleLanguage.verifiedAddress,
                    AppColors.completed,
                  ),
                SizedBox(width: AppSize.size8.w),
                _statusChip(
                  context.appLocaleLanguage.delete,
                  AppColors.textOnSellOrderBook,
                  actionButton: () {
                    _handleDeleteBeneficiary(context, vm, beneficiary);
                  },
                ),
              ],
            ),
            SizedBox(height: AppSize.size8.h),

            Row(
              children: [
                Text(
                  context.appLocaleLanguage.nameHeader,
                  style: AppTextStyles.content3.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(width: AppSize.size4.w),
                Text(
                  beneficiary.name,
                  style: AppTextStyles.content3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.size4.h),
            Text(
              beneficiary.addressData.address,
              style: AppTextStyles.content3.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<WithdrawViewModel, List<BeneficiariesModel>>(
      selector: (_, vm) => vm.availableBeneficiaries,
      builder: (context, availableBeneficiaries, child) {
        return SizedBox(
          height: AppSize.size70.h,
          child: availableBeneficiaries.isEmpty
              ? _buildAddAddressButton()
              : _buildAddressDropdown(context, availableBeneficiaries),
        );
      },
    );
  }

  void _handleDeleteBeneficiary(
    BuildContext bottomSheetContext,
    WithdrawViewModel vm,
    BeneficiariesModel beneficiary,
  ) async {
    await vm.deleteBeneficiary(beneficiary.id, beneficiary.addressData.address);
    if (vm.errorMessage != null && bottomSheetContext.mounted) {
      bottomSheetContext.showErrorDialog(
        vm.errorMessage!,
        onClosed: () => vm.clearError(),
      );
      return;
    }
  }
}
