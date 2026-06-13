import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/assets/deposit/coin_section/coin_selection_deposit.dart';
import 'package:alpha/presentation/pages/assets/deposit/deposit_action/deposit_action.dart';
import 'package:alpha/presentation/pages/assets/deposit/network_section/network_selection_deposit.dart';
import 'package:alpha/presentation/view_models/deposit/deposit_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DepositScreen extends StatelessWidget {
  final String? currency;

  const DepositScreen({super.key, this.currency});

  @override
  Widget build(BuildContext context) {
    return BaseView<DepositViewModel>(
      useSelector: true,
      viewModelBuilder: () => getIt<DepositViewModel>(),
      onModelReady: (vm) async {
        vm.init(currency);
      },
      padding: false,
      builder: (context, vm, child) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox.expand(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppHeader(
                        textTitle: context.appLocaleLanguage.deposit,
                        actionWidget: GestureDetector(
                          onTap: () {
                            context.push(
                              RouterPath.record,
                              extra: RecordType.deposit,
                            );
                          },
                          child: SvgPicture.asset(
                            AppSvg.historyIcon,
                            width: AppSize.size24.w,
                            height: AppSize.size24.h,
                          ),
                        ),
                        onTap: () {
                          context.pop();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space20.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: AppSpacing.space15.h,
                          children: [
                            CoinSelectionDeposit(),
                            Selector<
                              DepositViewModel,
                              ({CurrencyModel? selectedCoin, bool isBusy})
                            >(
                              selector: (context, viewModel) => (
                                selectedCoin: viewModel.selectedCoin,
                                isBusy: viewModel.isBusy,
                              ),
                              builder: (context, record, child) => Visibility(
                                visible:
                                    !record.isBusy &&
                                    record.selectedCoin != null,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    NetworkSelectionDeposit(),
                                    SizedBox(height: AppSpacing.space10.h),
                                    Text(
                                      context.appLocaleLanguage.depositTo,
                                      style: AppTextStyles.smallTextButton
                                          .copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                    ),
                                    SizedBox(height: AppSpacing.space5.h),
                                    Selector<DepositViewModel, CurrencyModel?>(
                                      selector: (context, viewModel) =>
                                          viewModel.selectedNetwork,
                                      builder:
                                          (context, selectedNetwork, child) {
                                            return Visibility(
                                              visible: selectedNetwork != null,
                                              child: _buildDepositChild(
                                                context,
                                              ),
                                            );
                                          },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: context.select<DepositViewModel, bool>(
                  (vm) => vm.isBusy,
                ),
                child: Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildDepositChild(BuildContext context) {
  final is2FAEnabled = context.select<DepositViewModel, bool>(
    (viewModel) => viewModel.is2FAEnabled,
  );
  if (!is2FAEnabled) {
    return DepositAction();
  }
  final isChildCurrenciesLoaded = context.select<DepositViewModel, bool>(
    (viewModel) => viewModel.isChildCurrenciesLoaded,
  );
  if (isChildCurrenciesLoaded) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppSvg.clock,
            width: AppSize.size34.w,
            height: AppSize.size34.h,
          ),
          SizedBox(height: AppSize.size10.h),
          Text(
            context.appLocaleLanguage.depositDisabled,
            style: AppTextStyles.smallTextButton.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
  final selectedCoinHasAddress = context.select<DepositViewModel, bool>(
    (viewModel) => viewModel.selectedCoinHasAddress,
  );
  if (selectedCoinHasAddress) {
    return DepositAction();
  }
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.5,
    child: Center(
      child: Image.asset(
        AppImage.loading,
        width: AppSize.size60.w,
        height: AppSize.size60.h,
      ),
    ),
  );
}
