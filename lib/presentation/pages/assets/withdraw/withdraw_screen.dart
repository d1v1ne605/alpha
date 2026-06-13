import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/assets/withdraw/body_withdraw_screen.dart';
import 'package:alpha/presentation/pages/assets/withdraw/header_withdraw_screen.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../injection/injector.dart';

class WithdrawScreen extends StatelessWidget {
  final String? currency;

  const WithdrawScreen({super.key, this.currency});

  @override
  Widget build(BuildContext context) {
    return BaseView<WithdrawViewModel>(
      useSelector: true,
      autoDispose: false,
      viewModelBuilder: () => getIt<WithdrawViewModel>(param1: currency),
      padding: false,
      builder: (context, vm, child) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    AppHeader(
                      textTitle: context.appLocaleLanguage.assetsButtonWithdraw,
                      actionWidget: GestureDetector(
                        onTap: () {
                          context.push(
                            RouterPath.record,
                            extra: RecordType.withdraw,
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

                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    HeaderWithdrawScreen(),

                                    // Body
                                    bodyWithdraw(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Selector<WithdrawViewModel, bool>(
                  selector: (context, viewModel) =>
                      viewModel.isBusy || viewModel.isLoadingExecutingWithdraw,
                  builder: (context, isLoading, child) => isLoading
                      ? Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Expanded bodyWithdraw() {
    return Expanded(
      child:
          Selector<
            WithdrawViewModel,
            ({bool isLoadingSelectNetwork, bool isBusy})
          >(
            selector: (_, getLoadingState) => (
              isLoadingSelectNetwork: getLoadingState.isLoadingSelectNetwork,
              isBusy: getLoadingState.isBusy,
            ),
            builder: (context, state, child) {
              if ((state.isLoadingSelectNetwork && !state.isBusy)) {
                return _buildLoadingState(context);
              }

              return !state.isBusy && !state.isLoadingSelectNetwork
                  ? Selector<WithdrawViewModel, CurrencyModel?>(
                      selector: (_, viewModel) => viewModel.coinSelected,
                      builder: (context, coinSelected, child) {
                        if (coinSelected != null &&
                            coinSelected.withdrawal_enabled) {
                          return BodyWithdrawScreen();
                        } else {
                          return _buildDisabledState(context);
                        }
                      },
                    )
                  : const SizedBox.shrink();
            },
          ),
    );
  }

  Widget _buildDisabledState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
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

  Widget _buildLoadingState(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: RepaintBoundary(
        child: Center(
          child: Image.asset(
            AppImage.loading,
            width: AppSize.size60.w,
            height: AppSize.size60.h,
          ),
        ),
      ),
    );
  }
}
