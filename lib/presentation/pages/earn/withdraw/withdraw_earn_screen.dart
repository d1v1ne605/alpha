import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/presentation/pages/earn/withdraw/body_withdraw_earn_screen.dart';
import 'package:alpha/presentation/pages/earn/withdraw/header_withdraw_earn_screen.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../injection/injector.dart';

class WithDrawEarnScreen extends StatefulWidget {
  String? currency;

  WithDrawEarnScreen({super.key, this.currency});

  @override
  State<WithDrawEarnScreen> createState() => _WithDrawEarnScreenState();
}

class _WithDrawEarnScreenState extends State<WithDrawEarnScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<EarnViewModel>(
      useSelector: true,
      autoDispose: false,
      viewModelBuilder: () => getIt<EarnViewModel>(),
      onModelReady: (vm) async {
        await vm.loadEarnWallets();
        if (widget.currency != null && widget.currency!.isNotEmpty) {
          vm.selectWalletById(widget.currency!.toLowerCase());
        }
      },
      padding: false,
      builder: (context, vm, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Stack(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        maxHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        children: [
                          AppHeader(
                            textTitle:
                                context.appLocaleLanguage.assetsButtonWithdraw,
                            actionWidget: GestureDetector(
                              onTap: () {
                                context.push(
                                  RouterPath.transaction,
                                  extra: TransactionType.withdraw_records,
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
                          HeaderWithdrawEarnScreen(),
                          Selector<EarnViewModel, bool>(
                            selector: (_, viewModel) => viewModel.isBusy,
                            builder: (context, isBusy, child) {
                              if (isBusy && vm.selectedWallet == null) {
                                return const Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                );
                              }
                              return Expanded(child: BodyWithdrawEarnScreen());
                            },
                          ),
                        ],
                      ),
                    ),
                    Selector<EarnViewModel, bool>(
                      selector: (context, viewModel) => viewModel.isBusy,
                      builder: (context, isLoading, child) =>
                          (isLoading && vm.selectedWallet != null)
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
            ),
          ),
        );
      },
    );
  }
}
