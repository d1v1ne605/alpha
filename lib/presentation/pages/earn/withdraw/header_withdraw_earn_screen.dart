import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/presentation/pages/earn/withdraw/coin_earn_selection_withdraw.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HeaderWithdrawEarnScreen extends StatefulWidget {
  const HeaderWithdrawEarnScreen({Key? key}) : super(key: key);

  @override
  State<HeaderWithdrawEarnScreen> createState() =>
      _HeaderWithdrawEarnScreenState();
}

class _HeaderWithdrawEarnScreenState extends State<HeaderWithdrawEarnScreen> {
  WithdrawViewModel? _withdrawViewModel;

  WithdrawViewModel get vm {
    return _withdrawViewModel ??= context.read<WithdrawViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [CoinEarnSelectionWithdraw()],
      ),
    );
  }
}
