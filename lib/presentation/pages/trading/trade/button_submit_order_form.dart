import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ButtonSubmitOrderForm extends StatelessWidget {
  const ButtonSubmitOrderForm({super.key, required this.market});

  final String market;

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select<AuthChangeNotifier, bool>(
      (auth) => auth.isAuthenticated,
    );
    final TradeViewModel vm = Provider.of<TradeViewModel>(
      context,
      listen: false,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space2.h),
      child: Selector<TradeViewModel, bool?>(
        selector: (_, viewModel) => viewModel.statusExecutingOrder,
        builder: (context, statusOrder, child) {
          if (statusOrder != null) {
            if (statusOrder == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showErrorSnackBar(vm.errorMessage ?? '');
                vm.clearError();
                vm.statusExecutingOrder = null;
              });
            } else if (statusOrder == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.showSuccessSnackBar(
                  vm.orderFormType.value == OrderTypeEnum.buy
                      ? context.appLocaleLanguage.buySuccess
                      : context.appLocaleLanguage.sellSuccess,
                );
                vm.statusExecutingOrder = null;
              });
            }
          }
          return child!;
        },
        child: AppButton(
          fontWeight: FontWeight.w700,
          text: isAuthenticated
              ? vm.orderFormType.value == OrderTypeEnum.buy
                    ? context.appLocaleLanguage.buy
                    : context.appLocaleLanguage.sell
              : context.appLocaleLanguage.loginButton,
          onPressed: () async {
            if (!isAuthenticated) {
              context.go(RouterPath.login);
              return;
            }
            await vm.submitOrder(market);
          },
          backgroundColor: vm.orderFormType.value == OrderTypeEnum.buy
              ? AppColors.green
              : AppColors.red,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.space6.h),
        ),
      ),
    );
  }
}
