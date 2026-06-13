import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/stakes/stake_record/select_currency_and_filter.dart';
import 'package:alpha/presentation/pages/stakes/stake_record/stake_record_list.dart';
import 'package:alpha/presentation/view_models/stake/stake_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StakeRecordScreen extends StatefulWidget {
  const StakeRecordScreen({super.key});

  @override
  State<StakeRecordScreen> createState() => _StakeRecordScreenState();
}

class _StakeRecordScreenState extends State<StakeRecordScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      useSelector: true,
      autoDispose: false,
      padding: true,
      viewModelBuilder: () => getIt<StakeViewModel>(),
      builder: (context, vm, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                AppHeader(
                  textTitle: context.appLocaleLanguage.stakeRecord,
                  onTap: () {
                    context.pop();
                  },
                ),

                SelectCurrencyAndFilter(),

                Selector<StakeViewModel, bool>(
                  selector: (_, viewModel) => !viewModel.isCurrenciesEmpty,
                  builder: (context, hasCurrencies, child) {
                    return Visibility(
                      visible: hasCurrencies,
                      child: StakeRecordList(),
                    );
                  },
                ),
              ],
            ),
            Selector<StakeViewModel, bool>(
              selector: (_, viewModel) =>
                  (vm.stakeRecords.isEmpty && viewModel.isCurrenciesEmpty) ||
                  viewModel.isBusy,
              builder: (context, isBusy, child) {
                if (isBusy) {
                  return Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
