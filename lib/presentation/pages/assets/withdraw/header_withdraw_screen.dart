import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/presentation/pages/assets/withdraw/address_selection/address_selector_screen.dart';
import 'package:alpha/presentation/pages/assets/withdraw/bottom_sheet_add_address.dart';
import 'package:alpha/presentation/pages/assets/withdraw/coin_selection/coin_selection_withdraw.dart';
import 'package:alpha/presentation/pages/assets/withdraw/network_selection/network_selection_withdraw.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HeaderWithdrawScreen extends StatefulWidget {
  const HeaderWithdrawScreen({super.key});

  @override
  State<HeaderWithdrawScreen> createState() => _HeaderWithdrawScreenState();
}

class _HeaderWithdrawScreenState extends State<HeaderWithdrawScreen> {
  String? selectedAddress;

  WithdrawViewModel? _withdrawViewModel;
  WithdrawViewModel get vm {
    return _withdrawViewModel ??= context.read<WithdrawViewModel>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedAddress = vm.beneficiarySelected?.id.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoinSelectionWithdraw(),
          SizedBox(height: AppSize.size10.h),
          Visibility(
            visible:
                !context.select<WithdrawViewModel, bool>(
                  (viewModel) => viewModel.isLoadingSelectNetwork,
                ) &&
                !context.select<WithdrawViewModel, bool>(
                  (viewModel) => viewModel.isBusy,
                ),
            child: Column(
              children: [
                NetworkSelectionWithdraw(),
                SizedBox(height: AppSize.size10.h),
                Selector<WithdrawViewModel, bool>(
                  selector: (context, vm) => vm.shouldShowAddressSection,
                  builder: (context, shouldShowAddressSection, child) {
                    final isLoadingBeneficiaries = context
                        .select<WithdrawViewModel, bool>(
                          (viewModel) => viewModel.isLoadingBeneficiaries,
                        );
                    return shouldShowAddressSection
                        ? AddressSelectorScreen(
                            onAddAddress: () {
                              showBottomSheetAddAddress(
                                context: context,
                                isLoadingBeneficiaries: isLoadingBeneficiaries,
                              );
                            },
                          )
                        : SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
