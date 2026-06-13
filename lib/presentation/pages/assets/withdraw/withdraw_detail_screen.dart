import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/asset/balance_response_model.dart';
import 'package:alpha/data/models/asset/beneficiaries_model.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_fee_response_model.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/assets/withdraw/withdraw_bottom_sheet_screen.dart';
import 'package:alpha/presentation/pages/assets/withdraw/withdraw_form_widget.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:provider/provider.dart';

class WithdrawDetailScreen extends StatefulWidget {
  const WithdrawDetailScreen({super.key});

  @override
  State<WithdrawDetailScreen> createState() => _WithdrawDetailScreenState();
}

class _WithdrawDetailScreenState extends State<WithdrawDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<WithdrawViewModel>();
    return Selector<WithdrawViewModel, CurrencyModel?>(
      selector: (_, viewModel) => viewModel.networkSelected,
      builder: (_, networkSelected, child) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            networkSelected?.id != '' &&
                    networkSelected?.withdrawal_enabled == true
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
                    child:
                        (Selector<
                          WithdrawViewModel,
                          ({
                            WithdrawFeeResponseModel? withdrawFee,
                            BalanceResponseModel? balance,
                          })
                        >(
                          selector: (context, viewModel) => (
                            withdrawFee: viewModel.withdrawFee,
                            balance: viewModel.balance,
                          ),
                          builder: (context, record, child) {
                            return record.withdrawFee != null
                                ? WithdrawFormWidget(
                                    feeOptions: record.withdrawFee!,
                                    availableBalance:
                                        double.tryParse(
                                          record.balance!.balance,
                                        ) ??
                                        0.0,
                                    onFeeChanged: (fee) {
                                      vm.selectedFee = fee;
                                    },
                                    onInputValueChanged: (value) {
                                      vm.onInputValueChange = value;
                                      value;
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  );
                          },
                        )),
                  )
                : _buildDisabledState(context, double.infinity),
            SizedBox(height: AppSize.size16.h),
            Selector<
              WithdrawViewModel,
              ({
                double? onInputValueChange,
                Fee? fee,
                BeneficiariesModel? beneficiarySelected,
              })
            >(
              selector: (_, viewModel) => (
                onInputValueChange: viewModel.onInputValueChange,
                fee: viewModel.selectedFee,
                beneficiarySelected: viewModel.beneficiarySelected,
              ),
              builder: (_, data, child) {
                return WithdrawBottomSheet(
                  isEnableWithdrawButton: _isEnableWithdrawButton(context, vm),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDisabledState(BuildContext context, double maxHeight) {
    return SizedBox(
      height: maxHeight,
      child: RepaintBoundary(
        child: Center(
          child: Text(
            context.appLocaleLanguage.withdrawWillAvailableSoon,
            style: AppTextStyles.content3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  bool _isEnableWithdrawButton(BuildContext context, WithdrawViewModel vm) {
    if (vm.validateAmount() != null ||
        vm.validateOtp() != null ||
        vm.validateExecuteWithdraw() != null) {
      return false;
    }
    return true;
  }
}
